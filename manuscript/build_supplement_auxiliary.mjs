import fs from 'node:fs/promises';
import {createRequire} from 'node:module';
const require=createRequire('/private/tmp/phage-supplement-artifact/package.json');
const {Workbook,SpreadsheetFile}=await import(require.resolve('@oai/artifact-tool'));
const out='/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/supplementary_reference_reconciliation_2026-09-22';
const input=JSON.parse(await fs.readFile(`${out}/workbook_auxiliary.json`,'utf8'));
const wb=Workbook.create();
for(const [name,rows] of Object.entries(input)){
  const s=wb.worksheets.add(name);s.showGridLines=false;
  const columns=rows[0].length;
  s.getRangeByIndexes(0,0,rows.length,columns).values=rows;
  const area=s.getRangeByIndexes(0,0,rows.length,columns);
  area.format.font={name:'Arial',size:10};area.format.verticalAlignment='top';area.format.wrapText=true;
  s.getRangeByIndexes(0,0,1,columns).format={fill:'#304659',font:{name:'Arial',size:10,bold:true,color:'#FFFFFF'},rowHeight:32};
  const widths=name==='Index'?[25,30,55,10,100]:name==='Column definitions'?[12,45,110]:[22,42,25,75,100];
  widths.forEach((width,i)=>s.getRangeByIndexes(0,i,rows.length,1).format.columnWidth=width);
  area.format.autofitRows();s.freezePanes.freezeRows(1);
}
wb.recalculate();
console.log((await wb.inspect({kind:'sheet',include:'id,name'})).ndjson);
for(const name of ['Index','S24 Software']){
  const preview=await wb.render({sheetName:name,range:name==='Index'?'A1:E8':'A1:E8',scale:1,format:'png'});
  await fs.writeFile(`${out}/${name.replaceAll(' ','_')}.png`,new Uint8Array(await preview.arrayBuffer()));
}
await (await SpreadsheetFile.exportXlsx(wb)).save(`${out}/auxiliary.xlsx`);
console.log('Auxiliary sheets exported');
