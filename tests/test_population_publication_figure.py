"""Verify Figure 5's publication layout against frozen population panels."""
import csv
import hashlib
from pathlib import Path
import subprocess
import sys
import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
baseline = root.parent / "manuscript_figure_candidates"
for name in ["population_genomics_cluster_panel.tsv", "population_genomics_summary_panel.tsv", "population_genomics_propionicimonas_panel.tsv"]:
    assert (root / "tables" / name).read_bytes() == (baseline / "tables" / name).read_bytes(), name

def rows(path):
    with path.open() as handle:
        return list(csv.DictReader(handle, delimiter="\t"))

inputs = rows(root / "tables/publication_input_provenance.tsv")
assert {r["input"] for r in inputs} == {"clusters", "pair_qc", "mag_qc"}
for row in inputs:
    path = Path(row["path"])
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
metadata = {r["metric"]: r["value"] for r in rows(root / "tables/publication_layout_metadata.tsv")}
assert metadata["models_refitted"] == "false"
assert hashlib.md5(Path(metadata["source_notebook"]).read_bytes()).hexdigest() == metadata["source_notebook_md5"]
path = root / "figures/population-genomic-heterogeneity.pdf"
assert len(list((root / "figures").glob("*.pdf"))) == 1
with pdfplumber.open(path) as doc:
    assert len(doc.pages) == 1
    page = doc.pages[0]
    assert abs(page.width / 72 * 25.4 - 180) < .01
    assert abs(page.height / 72 * 25.4 - 225) < .01
    assert not page.images
    chars = [c for c in page.chars if c["text"].strip()]
    sizes = [c["size"] if c["upright"] else c["width"] for c in chars]
    assert min(sizes) >= 6.4, min(sizes)
    assert all(c["x0"] >= 0 and c["x1"] <= page.width and c["top"] >= 0 and c["bottom"] <= page.height for c in chars)
    text = page.extract_text()
    raw = "".join(c["text"] for c in page.chars)
    for value in ["Propionicimonas sp023458095", "UBA8904 sp002070455", "SHND01 sp004295045", "Observed samples", "S1", "S2", "S3", "Consensus differences"]:
        assert value in text or value in raw, value
fonts = subprocess.run(["pdffonts", str(path)], capture_output=True, text=True, check=True).stdout.splitlines()[2:]
assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), fonts
for row in rows(root / "output_checksums.md5.tsv"):
    path = root / row["path"]
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
print("PASS: Figure 5 at 180 x 225 mm; >=6.5 pt within tolerance; vector-only; embedded fonts; three frozen panels unchanged; provenance and checksums verified. Visual review is separate.")
