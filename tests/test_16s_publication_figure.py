"""Validate S10 geometry, frozen results and displayed returned 16S values."""
import csv
import hashlib
from pathlib import Path
import subprocess
import sys
import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
baseline = root.parent / "16s_figure_top25_revision_2026-09-09"

def rows(path):
    with path.open() as handle:
        return list(csv.DictReader(handle, delimiter="\t"))

frozen = [p for p in (baseline / "tables").glob("*.tsv") if p.name != "input_provenance.tsv"]
assert len(frozen) == 8, len(frozen)
for path in frozen:
    assert (root / "tables" / path.name).read_bytes() == path.read_bytes(), path.name
inputs = {r["input"]: r for r in rows(root / "tables/input_provenance.tsv")}
for row in inputs.values():
    assert hashlib.md5(Path(row["path"]).read_bytes()).hexdigest() == row["md5"]
metadata = {r["metric"]: r["value"] for r in rows(root / "tables/publication_layout_metadata.tsv")}
assert metadata["models_refitted"] == "false"
archived = root / "source" / Path(metadata["source_notebook"]).name
assert hashlib.md5(archived.read_bytes()).hexdigest() == metadata["source_notebook_md5"]
original_ord = {r["sample_title"]: r for r in rows(Path(inputs["ordination"]["path"])) if r["metric"] == "bray_curtis"}
display_ord = rows(root / "tables/publication_ordination_display.tsv")
assert len(display_ord) == 12 and {r["sample_title"] for r in display_ord} == set(original_ord)
for row in display_ord:
    for key in ["axis1", "axis2", "axis1_percent_variance", "axis2_percent_variance"]:
        assert abs(float(row[key]) - float(original_ord[row["sample_title"]][key])) < 1e-12
original_alpha = {r["sample_title"]: r for r in rows(Path(inputs["alpha"]["path"]))}
display_alpha = rows(root / "tables/publication_alpha_display.tsv")
assert len(display_alpha) == 24
for row in display_alpha:
    key = {"Observed ASVs": "observed_asvs", "Shannon diversity": "shannon"}[row["measure"]]
    assert abs(float(row["value"]) - float(original_alpha[row["sample_title"]][key])) < 1e-12
path = root / "figures/16s-longitudinal-community-context.pdf"
assert len(list((root / "figures").glob("*.pdf"))) == 1
with pdfplumber.open(path) as doc:
    assert len(doc.pages) == 1
    page = doc.pages[0]
    assert abs(page.width / 72 * 25.4 - 180) < .01
    assert abs(page.height / 72 * 25.4 - 265) < .01
    assert not page.images
    chars = [c for c in page.chars if c["text"].strip()]
    assert min(c["size"] if c["upright"] else c["width"] for c in chars) >= 6.4
    assert all(c["x0"] >= 0 and c["x1"] <= page.width and c["top"] >= 0 and c["bottom"] <= page.height for c in chars)
    text = page.extract_text()
    raw = "".join(c["text"] for c in page.chars)
    for label in ["Observed ASVs", "Shannon diversity", "C1 to C2", "C2 to C3", "Control", "Phage-UV"]:
        assert label in text or label in raw, label
    for row in rows(root / "tables/16s_family_colour_key.tsv"):
        assert row["display_family"] in text or row["display_family"] in raw, row["display_family"]
fonts = subprocess.run(["pdffonts", str(path)], capture_output=True, text=True, check=True).stdout.splitlines()[2:]
assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), fonts
for row in rows(root / "output_checksums.md5.tsv"):
    file = root / row["path"]
    assert file.stat().st_size == int(row["bytes"])
    assert hashlib.md5(file.read_bytes()).hexdigest() == row["md5"]
print("PASS: S10 at 180 x 265 mm; >=6.5 pt within tolerance; embedded fonts; vector-only; eight frozen tables and all returned ordination/alpha values preserved; hashes verified. Visual review is separate.")
