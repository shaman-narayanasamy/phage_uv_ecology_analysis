"""Publication geometry and source-preservation checks for S1-S5; inspect renders separately."""
import csv
import hashlib
import math
from pathlib import Path
import subprocess
import sys
import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
baseline = root.parent / "manuscript_figure_candidates/tables"
frozen = ["supplementary_model_diagnostics.tsv", "supplementary_interaction_feature_counts.tsv",
          "supplementary_functional_coefficients.tsv", "supplementary_mag_coherence_counts.tsv",
          "supplementary_population_genomics_cells.tsv"]
for name in frozen:
    assert (root / "tables" / name).read_bytes() == (baseline / name).read_bytes(), name

def rows(path):
    with path.open() as handle:
        return list(csv.DictReader(handle, delimiter="\t"))

inputs = rows(root / "tables/publication_input_provenance.tsv")
assert len(inputs) == 9
for row in inputs:
    path = Path(row["path"])
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
metadata = rows(root / "tables/publication_layout_metadata.tsv")
assert len(metadata) == 5
archived = root / "source/supplementary_publication_figures.qmd"
assert all(hashlib.md5(archived.read_bytes()).hexdigest() == r["source_notebook_md5"] for r in metadata)
assert all(r["models_refitted"] == "FALSE" for r in metadata)

for name, height, expected in [
    ("supplementary-model-diagnostics.pdf", 165, ["1,734,019", "361,907", "Trended dispersion", "QL posterior variance"]),
    ("supplementary-cycle-interaction-landscape.pdf", 175, ["1 at BH FDR < 0.05", "11 at BH FDR < 0.05", "357 at BH FDR < 0.05"]),
    ("supplementary-functional-coefficients.pdf", 240, ["Adjusted condition", "Interaction omnibus", "FDR = 0.0021", "SOS response"]),
    ("supplementary-mag-coherence.pdf", 170, ["100", "75", "65", "68", "73", "59"]),
    ("supplementary-population-genomics.pdf", 245, ["Propionicimonas sp023458095", "UBA8904 sp002070455", "SHND01 sp004295045", "Chloroflexota", "Aliarcobacter"]),
]:
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
        raw = "".join(c["text"] for c in page.chars)
        for value in expected:
            assert value in text or value in raw, (name, value)
    fonts = subprocess.run(["pdffonts", str(path)], capture_output=True, text=True, check=True).stdout.splitlines()[2:]
    assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), (name, fonts)

ip = rows(root / "tables/s2_interaction_display.tsv")
for coefficient, supported in [("cycle2:conditiontreatment", 1), ("cycle3:conditiontreatment", 11)]:
    selected = [r for r in ip if r["coefficient"] == coefficient]
    assert len(selected) == 20000 + supported
    assert len({r["feature_id"] for r in selected}) == len(selected)
    assert sum(float(r["FDR"]) < .05 for r in selected) == supported
op = rows(root / "tables/s2_omnibus_display.tsv")
assert len(op) == 20357 and len({r["feature_id"] for r in op}) == 20357
assert sum(float(r["FDR"]) < .05 for r in op) == 357
# Independently reconstruct the deterministic selections in source row order,
# and compare every plotted value with its original result row.
path_map = {r["input"]: Path(r["path"]) for r in inputs}
for kind, displayed, fields in [("interaction", ip, ["logFC", "logCPM", "FDR"]),
                                 ("omnibus", op, ["logCPM", "FDR"])]:
    display_map = {(r.get("coefficient", "omnibus"), r["feature_id"]): r for r in displayed}
    source_context = {}
    source_supported = set()
    verified = set()
    with path_map[kind].open() as handle:
        for row in csv.DictReader(handle, delimiter="\t"):
            key = (row["coefficient"] if kind == "interaction" else "omnibus", row["feature_id"])
            if float(row["FDR"]) < .05:
                source_supported.add(key)
            else:
                source_context.setdefault(key[0], []).append(key)
            if key in display_map:
                for field in fields:
                    assert math.isclose(float(row[field]), float(display_map[key][field]), rel_tol=1e-12, abs_tol=1e-12), (key, field)
                verified.add(key)
    expected_keys = set(source_supported)
    for keys in source_context.values():
        n = min(20000, len(keys))
        indices = [round(i * (len(keys) - 1) / (n - 1)) for i in range(n)] if n > 1 else [0]
        expected_keys.update(keys[i] for i in indices)
    assert set(display_map) == expected_keys == verified, kind
assert len(rows(root / "tables/s1_library_display.tsv")) == 12
for row in rows(root / "output_checksums.md5.tsv"):
    path = root / row["path"]
    assert path.stat().st_size == int(row["bytes"])
    assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
print("PASS: S1-S5 dimensions, embedded fonts, >=6.5 pt within tolerance, vector content, five frozen tables, nine inputs, selected-feature counts and output hashes. Visual review remains separate.")
