import fs from 'node:fs/promises';
import {Workbook,SpreadsheetFile} from '/Users/shaman.narayanasamy/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';
const out=process.argv[2];
const data=JSON.parse(await fs.readFile(`${out}/workbook_data.json`,'utf8'));
const w=Workbook.create();
for(const [name,rows] of Object.entries(data)){
 const s=w.worksheets.add(name),headers=Object.keys(rows[0]);
 const grid=[headers,...rows.map(r=>headers.map(k=>r[k]??'NA'))];
 s.getRangeByIndexes(0,0,grid.length,headers.length).values=grid;
 const used=s.getRangeByIndexes(0,0,grid.length,headers.length);
 used.format.font={name:'Arial',size:10};used.format.rowHeight=19;used.format.columnWidth=22;
 const h=s.getRangeByIndexes(0,0,1,headers.length);
 h.format.fill='#29465B';h.format.font={name:'Arial',size:10,bold:true,color:'#FFFFFF'};
 h.format.wrapText=true;h.format.rowHeight=42;
 s.getRangeByIndexes(0,0,grid.length,1).format.columnWidth=name==='vOTU quality'?70:42;
 for(let j=0;j<headers.length;j++){
  const col=s.getRangeByIndexes(1,j,rows.length,1);
  if(['sample_title','completeness_method','warnings','ena_secondary_sample_accession'].includes(headers[j]))s.getRangeByIndexes(0,j,grid.length,1).format.columnWidth=headers[j]==='warnings'?70:42;
  if(rows.some(r=>typeof r[headers[j]]==='number'))col.setNumberFormat(headers[j].endsWith('_percent')?'0.00':'#,##0');
 }
 if(name==='Column definitions'){
  s.getRangeByIndexes(0,0,grid.length,1).format.columnWidth=22;
  s.getRangeByIndexes(0,1,grid.length,1).format.columnWidth=32;
  s.getRangeByIndexes(0,2,grid.length,1).format.columnWidth=105;
  s.getRangeByIndexes(1,2,rows.length,1).format.wrapText=true;
  used.format.rowHeight=35;h.format.rowHeight=42;
 }
 s.showGridLines=false;s.freezePanes.freezeRows(1);
}
w.recalculate();
console.log((await w.inspect({kind:'sheet',include:'id,name',maxChars:1000})).ndjson);
const x=await SpreadsheetFile.exportXlsx(w);await x.save(`${out}/Catalogue_quality_and_sample_provenance.xlsx`);
for(const [name,rows] of Object.entries(data)){
 const n=name==='Column definitions'?3:Math.min(Object.keys(rows[0]).length,7);
 const end=String.fromCharCode(64+n);
 const img=await w.render({sheetName:name,range:`A1:${end}8`,scale:1,format:'png'});
 await fs.writeFile(`${out}/preview_${name.replaceAll(' ','_')}.png`,new Uint8Array(await img.arrayBuffer()));
}
