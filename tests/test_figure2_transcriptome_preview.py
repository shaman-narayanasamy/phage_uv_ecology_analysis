"""Independent source/output audit; no refitting or figure changes."""
import csv
import hashlib
import itertools
import math
from collections import Counter
from pathlib import Path
import subprocess
import sys

root = Path(sys.argv[1]).resolve(strict=True)

def sha(path):
    with open(path, "rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()

def rows(path):
    with open(path, newline="") as stream:
        yield from csv.DictReader(stream, delimiter="\t")

inputs = {row["input"]: row for row in rows(root / "input_sha256.tsv")}
for row in inputs.values():
    assert sha(row["path"]) == row["sha256"], row["input"]
for row in rows(root / "output_sha256.tsv"):
    assert sha(root / row["path"]) == row["sha256"], row["path"]
assert sha(root / "tables/mds_coordinates.tsv") == inputs["mds"]["sha256"]

counts = Counter()
both = Counter()
seen = set()
for original, plotted in itertools.zip_longest(
    rows(inputs["de"]["path"]), rows(root / "tables/plotted_genes.tsv")
):
    assert original is not None and plotted is not None
    assert original["feature_id"] == plotted["feature_id"]
    assert plotted["feature_id"] not in seen
    seen.add(plotted["feature_id"])
    for field in ("logFC", "logCPM", "FDR"):
        assert math.isclose(float(original[field]), float(plotted[field]), rel_tol=1e-12, abs_tol=1e-14)
    fdr, fc = float(original["FDR"]), float(original["logFC"])
    expected = "Not significant" if fdr >= .05 else "Upregulated" if fc > 0 else "Downregulated"
    assert plotted["display_class"] == expected
    counts[expected] += 1
    if abs(fc) >= 1:
        both[expected] += 1
assert len(seen) == 361907
assert counts == {"Not significant": 354204, "Upregulated": 3697, "Downregulated": 4006}
assert both["Upregulated"] == 3694 and both["Downregulated"] == 4005
assert len(list(rows(root / "tables/old_background_subset.tsv"))) == 20000

pdf = root / "figures/figure2-transcriptome-preview.pdf"
text = subprocess.check_output(["pdftotext", "-layout", str(pdf), "-"], text=True)
for value in ("Leading logFC dimension 1", "Average expression", "Not significant (354,204)",
              "Downregulated (4,006)", "Upregulated (3,697)", "BH FDR < 0.05"):
    assert value in text, value
assert "tested features" not in text
fonts = subprocess.check_output(["pdffonts", str(pdf)], text=True).splitlines()[2:]
assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), fonts
print("PASS: all 361907 unique genes and exact source values; thresholds/counts; frozen MDS; hashes; PDF labels and embedded fonts. Visual inspection remains separate.")
