"""Build a versioned figure-and-caption review DOCX without manuscript prose."""
import argparse, json, hashlib, re
from pathlib import Path
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH

p=argparse.ArgumentParser()
p.add_argument('spec'); p.add_argument('out')
a=p.parse_args(); spec=json.loads(Path(a.spec).read_text()); out=Path(a.out)
if spec.get('figure3_caption_file'):
    lines=Path(spec['figure3_caption_file']).read_text().splitlines()
    lines[1]=lines[1].rstrip('.')+' (Myshkevych et al., 2025; doi:10.1016/j.ceja.2025.100796).'
    spec['figures'].append({'label':'Figure 3','title':lines[0].split('|',1)[1].strip(),'image':spec['figure3_image'],'caption':[{'label':line.split(',',1)[0]+',','text':line.split(',',1)[1].strip()} for line in lines[1:] if line.strip()]})
def rich(q, text):
    text=text.replace('sum_m','Σ_m').replace('^2','²').replace('>=','≥').replace('beta','β').replace('Delta S','ΔS')
    for part in re.split(r'(C_obs|E_0|h_m|Σ_m)',text):
        if re.fullmatch(r'C_obs|E_0|h_m|Σ_m',part):
            base,sub=part.split('_'); q.add_run(base); q.add_run(sub).font.subscript=True
        else: q.add_run(part)
out.mkdir(parents=True, exist_ok=False)
d=Document(); s=d.sections[0]
s.page_width=Inches(8.5); s.page_height=Inches(11)
s.top_margin=s.bottom_margin=Inches(.65)
s.left_margin=s.right_margin=Inches(.75)
d.core_properties.title=spec['title']; d.core_properties.author='Shaman Narayanasamy'
for name in ('Normal','Caption','Title'):
    st=d.styles[name]; st.font.name='Arial'; st.font.size=Pt(11); st.font.color.rgb=RGBColor(0,0,0)
    st.paragraph_format.space_after=Pt(8)
    st.paragraph_format.line_spacing=1.1
for i,fig in enumerate(spec['figures']):
    if i: d.add_page_break()
    pic=d.add_paragraph(); pic.alignment=WD_ALIGN_PARAGRAPH.CENTER
    pic.paragraph_format.space_after=Pt(0)
    pic.add_run().add_picture(fig['image'], width=Inches(6.75))
    d.add_page_break()
    head=d.add_paragraph(); head.add_run(fig['label']+': ').bold=True
    head.add_run(fig['title'])
    for panel in fig['caption']:
        q=d.add_paragraph(); q.add_run(panel['label']+' ').bold=True; rich(q,panel['text'])
d.save(out/'figures_and_captions_v3.docx')
(out/'source_spec.json').write_text(json.dumps(spec,indent=2))
sources=[Path(a.spec)]+[Path(f['image']) for f in spec['figures']]
(out/'input_sha256.json').write_text(json.dumps({str(x):hashlib.sha256(x.read_bytes()).hexdigest() for x in sources},indent=2))
print(out/'figures_and_captions_v3.docx')
