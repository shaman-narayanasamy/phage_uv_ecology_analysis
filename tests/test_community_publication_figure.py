"""Physical-size and unchanged-source checks for the Figure 1 candidate.

Visual review is still required; this is not a journal-compliance certificate.
"""
from pathlib import Path
import subprocess
import sys
import pdfplumber

candidate = Path(sys.argv[1]).resolve(strict=True)
baseline = candidate.parent/'community_figure_one'
for name in ['figure_one_panel_registry.tsv','figure_one_statistics.tsv','input_provenance.tsv']:
    assert (candidate/'tables'/name).read_bytes() == (baseline/'tables'/name).read_bytes(), name
source = candidate/'figures/community-structure-figure-one.pdf'
with pdfplumber.open(source) as pdf:
    assert len(pdf.pages) == 1
    page = pdf.pages[0]
    assert abs(page.width/72*25.4-180) < .01
    assert abs(page.height/72*25.4-200) < .01
    assert not page.images, 'Expected a vector-only plate'
    chars = [c for c in page.chars if c['text'].strip()]
    sizes = [c['size'] if c['upright'] else c['width'] for c in chars]
    assert min(sizes) >= 6.4, min(sizes)
    assert all(c['x0'] >= 0 and c['x1'] <= page.width and c['top'] >= 0 and c['bottom'] <= page.height for c in chars)
    text = page.extract_text()
    assert 'Microbial and phage community structure across three cleaning cycles' not in text
    assert 'Stacked bars retain the six discrete observations' not in text
    for expected in ['MAG family','JAFGLZ01','Thermoanaerobaculaceae','Other phyla','Paired BC: p = 0.125','Paired BC: p = 0.0625','Adjusted DA: 1/348','Adjusted DA: 0/560','Matched CLR: 0/348','Matched CLR: 0/616']:
        assert expected in text, expected
font_lines = subprocess.run(['pdffonts', str(source)],check=True,capture_output=True,text=True).stdout.splitlines()[2:]
assert font_lines and all(line.split()[-5] == 'yes' for line in font_lines if line.strip()), font_lines
print('PASS: 180 x 200 mm; all text at least 6.5 pt within tolerance; embedded fonts; vector-only; three source/statistics tables byte-identical; visual review remains separate')
