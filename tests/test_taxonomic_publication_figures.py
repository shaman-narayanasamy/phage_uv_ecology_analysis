"""Display-only S6/S7 rebuild: frozen trees, tables, labels and PDF geometry."""
import csv
import hashlib
from pathlib import Path
import subprocess
import sys
import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
baseline = root.parent / "taxonomic_context_revision_2026-09-09-v2"

def rows(path):
    with path.open() as handle:
        return list(csv.DictReader(handle, delimiter="\t"))

frozen = list((baseline / "tables").glob("*.tsv"))
frozen = [p for p in frozen if p.name != "input_provenance.tsv"]
frozen += list((baseline / "trees").glob("*.nwk"))
for source in frozen:
    path = root / source.relative_to(baseline)
    assert path.read_bytes() == source.read_bytes(), path
assert len(frozen) == 10, len(frozen)
for row in rows(root / "tables/input_provenance.tsv"):
    assert hashlib.md5(Path(row["path"]).read_bytes()).hexdigest() == row["md5"], row["input"]
metadata = {r["metric"]: r["value"] for r in rows(root / "tables/publication_layout_metadata.tsv")}
assert metadata["models_refitted"] == "false"
archived = root / "source" / Path(metadata["source_notebook"]).name
assert hashlib.md5(archived.read_bytes()).hexdigest() == metadata["source_notebook_md5"]
groups = rows(root / "tables/votu_taxonomic_context_groups.tsv")
assert len(groups) == 45 and sum(int(r["n_votus"]) for r in groups) == 607
expected = sorted(groups, key=lambda r: (-int(r["n_votus"]), r["display_label"]))[:18]
display = rows(root / "tables/votu_publication_label_positions.tsv")
assert {r["label"] for r in display} == {r["vOTU_group"] for r in expected}
assert {r["tree_label"] for r in display} == {r["display_label"] for r in expected}
for name, height in [("mag-taxonomic-context.pdf", 250), ("votu-taxonomic-context.pdf", 230)]:
    path = root / "figures" / name
    with pdfplumber.open(path) as doc:
        assert len(doc.pages) == 1
        page = doc.pages[0]
        assert abs(page.width / 72 * 25.4 - 180) < .01
        assert abs(page.height / 72 * 25.4 - height) < .01
        assert not page.images, name
        chars = [c for c in page.chars if c["text"].strip()]
        sizes = [c["size"] if c["upright"] else c["width"] for c in chars]
        assert min(sizes) >= 6.4, (name, min(sizes))
        assert all(c["x0"] >= 0 and c["x1"] <= page.width and c["top"] >= 0 and c["bottom"] <= page.height for c in chars), name
        text = page.extract_text()
        if name.startswith("votu"):
            for row in expected:
                assert row["display_label"] in text, row["display_label"]
            for count in ["462", "103", "32"]:
                assert count in text, count
        else:
            for label in ["Completeness", "Contamination", "Control", "Phage-UV", "Other phyla", "MAG-mapped reads"]:
                assert label in text or label in "".join(c["text"] for c in page.chars), label
    fonts = subprocess.run(["pdffonts", str(path)], capture_output=True, text=True, check=True).stdout.splitlines()[2:]
    assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), fonts
for row in rows(root / "output_checksums.md5.tsv"):
    path = root / row["path"]
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
print("PASS: S6/S7 at 180 mm; >=6.5 pt within tolerance; embedded fonts; vector-only; ten frozen tables/trees unchanged; same 18 labelled viral groups; provenance and output checksums verified. Visual review remains separate.")
