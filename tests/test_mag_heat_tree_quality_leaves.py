"""Check every individual MAG quality tile, tree attachment and plotted area."""
import csv
import hashlib
import math
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

out = Path(sys.argv[1])


def rows(path, delimiter="\t"):
    with Path(path).open(newline="") as handle:
        return list(csv.DictReader(handle, delimiter=delimiter))


for manifest, root in ((out / "input_sha256.tsv", None), (out / "output_sha256.tsv", out)):
    for r in rows(manifest):
        path = Path(r["path"]) if root is None else root / r["path"]
        with path.open("rb") as handle:
            assert hashlib.file_digest(handle, "sha256").hexdigest() == r["sha256"], str(path)
source = {r["node_id"]: r for r in rows(out / "source/mag_plotted_nodes.tsv")}
assigned = {r["MAG_ID"]: r for r in rows(out / "source/deepest_assignments.tsv")}
qc = {r["genome"].removesuffix(".fasta"): r for r in rows(out / "source/Widb.csv", ",")}
leaves = {r["MAG_ID"]: r for r in rows(out / "tables/mag_leaves.tsv")}
nodes = {r["node_id"]: r for r in rows(out / "tables/tree_nodes.tsv")}
assert len(nodes) == 1046 and len(source) == 698 and len(leaves) == 348
assert set(qc) == set(assigned) == set(leaves)
children = defaultdict(list)
for n in nodes.values():
    if n["parent"]:
        children[n["parent"]].append(n)
    assert math.isclose(float(n["clade_abundance"]), float(n["direct_abundance"]) + sum(float(c["clade_abundance"]) for c in nodes.values() if c["parent"] == n["node_id"]), abs_tol=1e-12)
assert {n["node_id"] for n in nodes.values() if n["rank"] == "MAG"} == {n["node_id"] for n in nodes.values() if not children[n["node_id"]]}
assert math.isclose(sum(float(n["direct_abundance"]) for n in nodes.values()), 1, abs_tol=1e-12)
for ident, old in source.items():
    new = nodes[ident]
    for key in ("parent", "rank", "taxon", "phylum", "clade_mags", "colour", "plot_label"):
        assert new[key] == old[key], (ident, key)
    assert float(new["clade_abundance"]) == float(old["clade_abundance"])
    assert float(new["direct_abundance"]) == int(new["direct_mags"]) == 0
for mag, leaf in leaves.items():
    n = nodes[leaf["node_id"]]
    assert n["rank"] == "MAG" and n["taxon"] == mag
    assert n["parent"] == assigned[mag]["assigned_node"]
    assert n["colour"] == source[n["parent"]]["colour"]
    assert float(n["clade_abundance"]) == float(assigned[mag]["mean_abundance"])
    for metric in ("completeness", "contamination"):
        assert float(leaf[metric]) == float(qc[mag][metric])
tiles = rows(out / "tables/quality_tiles.tsv")
assert len(tiles) == 696
assert len({(r["MAG_ID"], r["metric"]) for r in tiles}) == 696
for r in tiles:
    assert r["node_id"] == leaves[r["MAG_ID"]]["node_id"]
    assert float(r["value"]) == float(qc[r["MAG_ID"]][r["metric"]])
for mag in leaves:
    pair = {r["metric"]: r for r in tiles if r["MAG_ID"] == mag}
    distances = {metric: math.hypot(float(r["cx"])-float(r["leaf_x"]), float(r["cy"])-float(r["leaf_y"])) for metric, r in pair.items()}
    assert distances["completeness"] < distances["contamination"]


def area(poly):
    x, y = [float(r["x"]) for r in poly], [float(r["y"]) for r in poly]
    return abs(sum(x[i] * y[(i+1) % len(x)] - x[(i+1) % len(x)] * y[i] for i in range(len(x)))) / 2


polys = defaultdict(list)
for r in rows(out / "tables/native_tree_polygons.tsv"):
    polys[r["group"]].append(r)
root_area = area(polys["n000_node"])
for ident, n in nodes.items():
    poly = polys[ident + "_node"]
    assert poly and all(r["color"] == n["colour"] for r in poly)
    assert math.isclose(area(poly) / root_area, float(n["clade_abundance"]), abs_tol=1e-8)
tile_polys = defaultdict(list)
for r in rows(out / "tables/quality_tile_polygons.tsv"):
    tile_polys[(r["MAG_ID"], r["metric"])].append(r)
assert len(tile_polys) == 696
for (mag, metric), poly in tile_polys.items():
    assert len(poly) == 4
    assert all(float(r["value"]) == float(qc[mag][metric]) for r in poly)
    assert math.isclose(area(poly), .005**2, abs_tol=1e-12)
bounds = {}
for mag in leaves:
    p = tile_polys[(mag, "completeness")] + tile_polys[(mag, "contamination")]
    bounds[mag] = (min(float(r["x"]) for r in p), max(float(r["x"]) for r in p), min(float(r["y"]) for r in p), max(float(r["y"]) for r in p))
ids = list(bounds)
for i, mag in enumerate(ids):
    a = bounds[mag]
    for other in ids[i+1:]:
        b = bounds[other]
        assert not (a[0] < b[1] and a[1] > b[0] and a[2] < b[3] and a[3] > b[2]), (mag, other)
pdf_text = subprocess.check_output(["pdftotext", str(out / "figures/mag_heat_tree_quality_leaves.pdf"), "-"], text=True)
assert "Completeness (%)" in pdf_text and "Contamination (%)" in pdf_text
print("PASS: 348 individual MAG leaves; 696 exact quality tiles in the correct order with no pair overlaps; 1046 native node areas and all taxonomic clade abundances verified; both PDF quality legends and SHA-256 passed.")
