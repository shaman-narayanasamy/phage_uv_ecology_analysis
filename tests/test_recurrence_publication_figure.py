"""Check Figure 4 geometry and unchanged frozen recurrence selections/values."""
import csv
import hashlib
from pathlib import Path
import subprocess
import sys

import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
baseline = root.parent / "manuscript_figure_candidates"
table_names = [
    "recurrence_selection_funnel.tsv",
    "recurrence_direction_concordance.tsv",
    "recurrent_gene_heatmap_selection.tsv",
    "recurrent_gene_heatmap_cells.tsv",
]
for name in table_names:
    assert (root / "tables" / name).read_bytes() == (baseline / "tables" / name).read_bytes(), name

def rows(path):
    with path.open() as stream:
        return list(csv.DictReader(stream, delimiter="\t"))

inputs = rows(root / "tables/publication_input_provenance.tsv")
assert {r["input"] for r in inputs} == {"annotated", "recurrence", "candidates", "registry"}
for row in inputs:
    path = Path(row["path"])
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
metadata = {r["metric"]: r["value"] for r in rows(root / "tables/publication_layout_metadata.tsv")}
assert metadata["models_refitted"] == "false"
assert hashlib.md5(Path(metadata["source_notebook"]).read_bytes()).hexdigest() == metadata["source_notebook_md5"]

path = root / "figures/recurrent-gene-structure.pdf"
with pdfplumber.open(path) as doc:
    assert len(doc.pages) == 1
    page = doc.pages[0]
    assert abs(page.width / 72 * 25.4 - 180) < .01
    assert abs(page.height / 72 * 25.4 - 200) < .01
    assert not page.images, "Expected vector-only figure"
    chars = [c for c in page.chars if c["text"].strip()]
    sizes = [c["size"] if c["upright"] else c["width"] for c in chars]
    assert min(sizes) >= 6.4, min(sizes)
    assert all(c["x0"] >= 0 and c["x1"] <= page.width and c["top"] >= 0 and c["bottom"] <= page.height for c in chars)
    text = page.extract_text()
    raw_text = "".join(c["text"] for c in page.chars)
    for value in ["361,907", "7,699", "7,603", "7,141", "6,985", "2,671", "2,709", "663", "942", "Control", "Phage-UV"]:
        assert value in text or value in raw_text, value
fonts = subprocess.run(["pdffonts", str(path)], capture_output=True, text=True, check=True).stdout.splitlines()[2:]
assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), fonts
for row in rows(root / "output_checksums.md5.tsv"):
    path = root / row["path"]
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
print("PASS: Figure 4 at 180 x 200 mm; >=6.5 pt within tolerance; vector-only; embedded fonts; four frozen tables unchanged; provenance and checksums verified. Visual review is separate.")
