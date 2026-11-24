import fs from 'node:fs/promises';
import {Workbook,SpreadsheetFile} from '/Users/shaman.narayanasamy/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/@oai/artifact-tool/dist/artifact_tool.mjs';
const out=process.argv[2];
const index=JSON.parse(await fs.readFile(`${out}/INDEX.json`,'utf8'));
const w=Workbook.create();
const front=w.worksheets.add('Index');
const keys=['Table','Sheet','Title','Rows','Scope'];
front.getRangeByIndexes(0,0,index.length+1,5).values=[keys,...index.map(r=>keys.map(k=>r[k]))];
front.getRangeByIndexes(0,0,index.length+1,5).format.font={name:'Arial',size:10};
for(const [j,width] of [20,30,65,12,115].entries())front.getRangeByIndexes(0,j,index.length+1,1).format.columnWidth=width;
front.getRangeByIndexes(0,0,1,5).format.fill='#29465B';
front.getRangeByIndexes(0,0,1,5).format.font={bold:true,color:'#FFFFFF'};
front.getRangeByIndexes(0,0,index.length+1,5).format.wrapText=true;
front.getRangeByIndexes(0,0,index.length+1,5).format.rowHeight=48;
front.showGridLines=false;front.freezePanes.freezeRows(1);
for(let i=0;i<index.length;i++){
 const d=JSON.parse(await fs.readFile(`${out}/S${i+1}.json`,'utf8'));
 const s=w.worksheets.add(d.sheet),n=d.headers.length;
 s.getRangeByIndexes(0,0,1,n).values=[d.headers];
 // The runtime's cell-by-cell indexing does not scale to the 4.3-million-cell
 // transcriptome sheet (two attempts, first stopped after >9 minutes).
 // Author and render its exact opening rows here; the documented streaming
 // completion step writes its static body without changing other sheets.
 const viewRows=d.rows.length>100000?d.rows.slice(0,20):d.rows;
 s.getRangeByIndexes(1,0,viewRows.length,n).values=viewRows;
 console.log(`${d.sheet}: data written`);
 // Style the opening view and header, avoiding per-cell styling of millions of data cells.
 const head=s.getRangeByIndexes(0,0,1,n);
 head.format.fill='#29465B';head.format.font={name:'Arial',size:10,bold:true,color:'#FFFFFF'};
 head.format.wrapText=true;head.format.rowHeight=42;head.format.verticalAlignment='center';
 s.getRangeByIndexes(0,0,Math.min(d.rows.length+1,20),n).format.font.name='Arial';
 for(let j=0;j<n;j++){
  const h=d.headers[j];
  s.getRangeByIndexes(0,j,1,1).format.columnWidth=/feature_id|vOTU_ID/i.test(h)?135:/contig|phage_id|representative|panel_label/i.test(h)?85:/annotation|gene_label/i.test(h)?65:/MAG_ID|sample_title|sample_a|sample_b/i.test(h)?45:23;
  if(d.numeric[j]&&/p_value|pvalue|^p$|_P$|FDR|padj|q_BH/.test(h))s.getRangeByIndexes(1,j,Math.min(d.rows.length,20),1).setNumberFormat('0.00E+00');
 }
 s.showGridLines=false;s.freezePanes.freezeRows(1);
 console.log(`${d.sheet}: ${d.rows.length} rows`);
}
const legacy=JSON.parse(await fs.readFile(`${out}/../catalogue_sample_supplement_2026-09-22-v1/workbook_data.json`,'utf8'));
const definitions=legacy['Column definitions'].map(r=>({...r,table:({'MAG quality':'S1','vOTU quality':'S2','Samples':'S20','Sequencing runs':'S21'})[r.table]??r.table}));
definitions.push(
 {table:'S3',column:'test, padj, padj_BH_all_nonmissing',definition:'main_wald is the adjusted condition effect; interaction_lrt is the joint condition-by-cycle test. Original adjusted-value columns are preserved and their distinct scopes must not be pooled.'},
 {table:'S8',column:'main_logFC; main_P; main_FDR_BH',definition:'Treatment-versus-control log2 fold change, raw P value and Benjamini-Hochberg-adjusted P value over the complete tested transcriptome.'},
 {table:'S8',column:'interaction_P; interaction_FDR_BH',definition:'Joint two-degree-of-freedom condition-by-cycle test and its global BH correction.'},
 {table:'S8',column:'interaction_cycle2_*; interaction_cycle3_*',definition:'Individual condition-by-cycle coefficients relative to cycle 1. Raw and BH-adjusted tests retain their original coefficient-specific testing families.'},
 {table:'S9',column:'historical flags; matching_rules',definition:'Membership provenance for the combined biofilm definition, not alternative active biofilm lists.'},
 {table:'S10-S11',column:'null; resolution; p; FDR columns',definition:'Null or block resolution identifies the randomisation/dependence test. Monte Carlo intervals and the original adjusted-value columns are retained separately.'},
 {table:'S16',column:'R_*; P; lag_days; z_P; z_lag; score',definition:'R is initial/(initial+backflush). P is the mean of three ratios, not a P value. Score is 0.5*z_P + 0.5*z_lag using the displayed fixed reference means and sample standard deviations.'},
 {table:'S17',column:'FDR_56; FDR_168; HC3_*',definition:'BH correction across 56 slopes within specification or all 168 candidate fits. HC3 fields use heteroscedasticity-consistent standard errors and separate corrections.'},
 {table:'S18',column:'delta_score; low; high',definition:'Simulated change in the composite score at reduced whole-MAG abundance and its coefficient-derived interval. Not percentage biofilm reduction.'},
 {table:'S19',column:'FDR_696; FDR_2088',definition:'BH correction across 696 slopes within specification or all 2,088 all-MAG fits. These are distinct from candidate-only corrections.'},
 {table:'S22',column:'Mapped alignment records (%)',definition:'Mapped coassembly alignment records/all coassembly alignment records, including secondary alignments. Catalogue-assigned totals have a different target and denominator.'}
);
const ds=w.worksheets.add('Column definitions');
ds.getRangeByIndexes(0,0,definitions.length+1,3).values=[['Table','Column','Definition'],...definitions.map(r=>[r.table,r.column,r.definition])];
ds.getRangeByIndexes(0,0,definitions.length+1,3).format.font={name:'Arial',size:10};
for(const [j,width] of [18,42,110].entries())ds.getRangeByIndexes(0,j,definitions.length+1,1).format.columnWidth=width;
ds.getRangeByIndexes(0,0,definitions.length+1,3).format.wrapText=true;
ds.getRangeByIndexes(0,0,definitions.length+1,3).format.rowHeight=48;
ds.getRange('A1:C1').format.fill='#29465B';ds.getRange('A1:C1').format.font={bold:true,color:'#FFFFFF'};
ds.showGridLines=false;ds.freezePanes.freezeRows(1);
await fs.writeFile(`${out}/DEFINITIONS.json`,JSON.stringify(definitions));
w.recalculate();
console.log((await w.inspect({kind:'table',range:'Index!A1:D5',include:'values',tableMaxRows:5,tableMaxCols:4,maxChars:1500})).ndjson);
await fs.mkdir(`${out}/previews`,{recursive:true});
for(const name of ['Index',...index.map(x=>x.Sheet),'Column definitions']){
 const blob=await w.render({sheetName:name,range:name==='Index'?'A1:D8':'A1:D5',scale:1,format:'png'});
 await fs.writeFile(`${out}/previews/${name.split(' ')[0]}.png`,new Uint8Array(await blob.arrayBuffer()));
}
const x=await SpreadsheetFile.exportXlsx(w);
await x.save(`${out}/workbook_template.xlsx`);
console.log('EXPORTED');
