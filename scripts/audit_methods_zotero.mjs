// Read-only Zotero matching and Crossref metadata verification. No library writes.
import fs from 'node:fs/promises';
import path from 'node:path';
const out=process.argv[2];
await fs.mkdir(out,{recursive:false});
const bib=await fs.readFile('manuscript/references.bib','utf8');
const refs=bib.split(/(?=^@)/m).flatMap(b=>{
 const key=b.match(/^@\w+\{([^,]+),/),doi=b.match(/doi\s*=\s*\{([^}]+)\}/i);
 return key&&doi?[{citekey:key[1],doi:doi[1]}]:[];
});
refs.push({citekey:'Parks2015CheckM',doi:'10.1101/gr.186072.114'},
 {citekey:'Foster2017Metacoder',doi:'10.1371/journal.pcbi.1005404'},
 {citekey:'Chen2016QL',doi:'10.12688/f1000research.8987.2'},
 {citekey:'MinCED',doi:'',title:'MinCED: Mining CRISPRs in Environmental Datasets',url:'https://github.com/ctSkennerton/minced'});
refs.find(x=>x.citekey==='Li2013BWAMEM').title='Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM';
const norm=x=>(x||'').toLowerCase().replace(/^https?:\/\/(dx\.)?doi.org\//,'').trim();
const titleNorm=x=>(x||'').toLowerCase().replace(/<[^>]+>/g,'').replace(/[^a-z0-9]/g,'');
async function get(url){const r=await fetch(url,{signal:AbortSignal.timeout(20000)});if(!r.ok)throw new Error(`HTTP ${r.status}`);return r.json();}
const result=[];
// Local API text search did not constrain results reliably. Match exact DOI
// against the entire paginated top-level library instead.
const firstResponse=await fetch('http://localhost:23119/api/users/5080709/items/top?format=json&limit=100&start=0');
if(!firstResponse.ok)throw new Error(`Library HTTP ${firstResponse.status}`);
const total=Number(firstResponse.headers.get('total-results'));
if(!Number.isInteger(total)||total<1)throw new Error('Missing library total');
const library=await firstResponse.json();
for(let start=100;start<total;start+=300){
 const offsets=[start,start+100,start+200].filter(x=>x<total);
 const pages=await Promise.all(offsets.map(n=>get(`http://localhost:23119/api/users/5080709/items/top?format=json&limit=100&start=${n}`)));
 library.push(...pages.flat());
}
if(new Set(library.map(x=>x.key)).size!==total)throw new Error('Incomplete/duplicate pagination');
console.log(`Verified complete library: ${total} top-level items`);
const prior=process.argv[3]?JSON.parse(await fs.readFile(process.argv[3],'utf8')):[];
let pos=0;
async function worker(){while(pos<refs.length){const ref=refs[pos++];const row={...ref};
 const cached=prior.find(x=>norm(x.doi)===norm(ref.doi));
 try {const matches=library.filter(x=>(ref.doi && norm(x.data?.DOI)===norm(ref.doi)) || ((cached?.crossref?.title || ref.title) && titleNorm(x.data?.title)===titleNorm(cached?.crossref?.title || ref.title)) || (ref.url && (x.data?.url||'').replace(/\/$/,'')===ref.url));
 row.zotero_matches=matches.map(x=>({key:x.key,title:x.data.title,collections:x.data.collections,date:x.data.date}));
 row.zotero_status=matches.length===1?'matched':matches.length>1?'multiple_existing':'missing';
 }catch(e){row.zotero_status='unavailable';row.zotero_error=e.message;}
 if(cached?.crossref){row.crossref=cached.crossref;}else if(ref.doi && !ref.doi.toLowerCase().startsWith('10.48550/arxiv.')) try{const c=(await get(`https://api.crossref.org/works/${encodeURIComponent(ref.doi)}`)).message;
 row.crossref={DOI:c.DOI,title:c.title?.[0],author:c.author,published:c.published,container:c['container-title']?.[0],volume:c.volume,issue:c.issue,page:c.page,URL:c.URL,type:c.type};
 }catch(e){row.crossref_error=e.message;}
 result.push(row);console.log(`${row.citekey}: ${row.zotero_status}, Crossref ${row.crossref?'verified':row.crossref_error}`);
}}
await Promise.all(Array.from({length:3},worker));
result.sort((a,b)=>a.citekey.localeCompare(b.citekey));
await fs.writeFile(path.join(out,'methods_reference_audit.json'),JSON.stringify(result,null,2));
const cell=x=>String(x??'').replace(/[\t\r\n]+/g,' ');
await fs.writeFile(path.join(out,'methods_reference_audit.tsv'),['citekey\tdoi\tzotero_status\titem_keys\tverified_title',...result.map(x=>[x.citekey,x.doi,x.zotero_status,x.zotero_matches?.map(y=>y.key).join(';'),x.crossref?.title].map(cell).join('\t'))].join('\n')+'\n');
const missing=result.filter(x=>x.zotero_status==='missing'&&x.crossref);
const ris=missing.map(x=>{const c=x.crossref;return ['TY  - JOUR',`TI  - ${c.title}`,...(c.author||[]).map(a=>`AU  - ${a.family}, ${a.given||''}`),`PY  - ${c.published?.['date-parts']?.[0]?.[0]||''}`,`JO  - ${c.container||''}`,`VL  - ${c.volume||''}`,`IS  - ${c.issue||''}`,`SP  - ${c.page||''}`,`DO  - ${x.doi}`,`UR  - https://doi.org/${x.doi}`,'ER  - '].join('\n');}).join('\n\n');
await fs.writeFile(path.join(out,'missing_methods_references.ris'),ris+'\n');
console.log(JSON.stringify({total:result.length,matched:result.filter(x=>x.zotero_status==='matched').length,multiple:result.filter(x=>x.zotero_status==='multiple_existing').length,missing:result.filter(x=>x.zotero_status==='missing').length,missing_with_crossref_metadata:missing.length,unavailable:result.filter(x=>x.zotero_status==='unavailable').length}));
