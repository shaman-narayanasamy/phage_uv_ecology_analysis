"""Verify visual-only Figure 2/3 rebuilds against their frozen source panels."""
import csv
import hashlib
from pathlib import Path
import subprocess
import sys
import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
baseline = root.parent/'manuscript_figure_revision_2026-09-09'
for name in ['mds_coordinates.tsv','figure_summary.tsv','functional_condition_panel.tsv','top_mag_condition_panel.tsv']:
    assert (root/'tables'/name).read_bytes() == (baseline/'tables'/name).read_bytes(), name
with (root/'tables/publication_input_provenance.tsv').open() as handle:
    inputs = list(csv.DictReader(handle,delimiter='\t'))
assert len(inputs) == 7 and 'counts' not in {row['input'] for row in inputs}
for row in inputs:
    p = Path(row['path'])
    assert p.stat().st_size == int(row['bytes'])
    assert hashlib.md5(p.read_bytes()).hexdigest() == row['md5']
with (root/'tables/publication_layout_metadata.tsv').open() as handle:
    metadata = {r['metric']:r['value'] for r in csv.DictReader(handle,delimiter='\t')}
assert metadata['mds_recomputed'] == metadata['models_refitted'] == 'false'
assert hashlib.md5(Path(metadata['source_notebook']).read_bytes()).hexdigest() == metadata['source_notebook_md5']
for name, height, expected in [
    ('global-transcriptome-structure.pdf',100,['361,907 tested features','7,703 at BH FDR < 0.05','7,699 also |log2FC| >= 1','Leading logFC dimension 1']),
    ('functional-organism-restructuring.pdf',195,['BH FDR = 0.0021','Supported MAGs','75','100','SOS response','Giesbergeria','Methanothrix'])
]:
    p = root/'figures'/name
    with pdfplumber.open(p) as doc:
        assert len(doc.pages) == 1
        page = doc.pages[0]
        assert abs(page.width/72*25.4-180) < .01
        assert abs(page.height/72*25.4-height) < .01
        assert not page.images, 'Expected vector-only content'
        chars = [c for c in page.chars if c['text'].strip()]
        sizes = [c['size'] if c['upright'] else c['width'] for c in chars]
        assert min(sizes) >= 6.4, (name,min(sizes))
        assert all(c['x0'] >= 0 and c['x1'] <= page.width and c['top'] >= 0 and c['bottom'] <= page.height for c in chars)
        text = page.extract_text()
        # Rotated axis labels can be split/reversed by reading-order extraction.
        # Retain the original PDF character order as an independent text check.
        raw_text = ''.join(c['text'] for c in page.chars)
        for value in expected:
            assert value in text or value in raw_text, (name,value)
    fonts = subprocess.run(['pdffonts',str(p)],check=True,capture_output=True,text=True).stdout.splitlines()[2:]
    assert fonts and all(line.split()[-5] == 'yes' for line in fonts if line.strip()),fonts
with (root/'output_checksums.md5.tsv').open() as handle:
    for row in csv.DictReader(handle,delimiter='\t'):
        p = root/row['path']
        assert p.stat().st_size == int(row['bytes'])
        assert hashlib.md5(p.read_bytes()).hexdigest() == row['md5']
print('PASS: Figures 2/3 at 180 mm; >=6.5 pt text within tolerance; embedded fonts; four frozen tables byte-identical; seven used inputs verified; visual review remains separate')
