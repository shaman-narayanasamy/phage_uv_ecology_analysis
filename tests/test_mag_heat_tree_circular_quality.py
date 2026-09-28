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
    for key in ("parent", "rank", "taxon", "phylum", "clade_mags", "plot_label"):
        assert new[key] == old[key], (ident, key)
    assert float(new["clade_abundance"]) == float(old["clade_abundance"])
    assert float(new["direct_abundance"]) == int(new["direct_mags"]) == 0
for mag, leaf in leaves.items():
    n = nodes[leaf["node_id"]]
    assert n["rank"] == "MAG" and n["taxon"] == mag
    assert n["parent"] == assigned[mag]["assigned_node"]
    assert n["colour"] == leaf["colour"]
    assert float(n["clade_abundance"]) == float(assigned[mag]["mean_abundance"])
    for metric in ("completeness", "contamination"):
        assert float(leaf[metric]) == float(qc[mag][metric])
palette_file = out / "source/family_microshades_colour_key.tsv"
if palette_file.exists():
    palette = rows(palette_file)
    named = {(r["phylum"],r["display_category"]):r for r in palette if r["category_type"]=="top25 named"}
    remainder = {r["phylum"]:r for r in palette if r["category_type"]=="within-phylum remainder"}
    other = next(r for r in palette if r["category_type"]=="global remainder")
    for n in nodes.values():
        if n["rank"] not in ("family","genus","species","MAG"):
            assert n["colour"]==source[n["node_id"]]["colour"]
            continue
        ancestor = n
        while ancestor["rank"]!="family" and ancestor["parent"] in nodes:
            ancestor = nodes[ancestor["parent"]]
        family = ancestor["taxon"] if ancestor["rank"]=="family" else None
        expected = named.get((n["phylum"],family),remainder.get(n["phylum"],other))
        assert n["colour"]==expected["colour"], n["node_id"]
        assert n["colour_category"]==expected["display_category"]
    print("PASS: exact frozen stacked-bar colours for families and descendants; higher-rank colours unchanged")
else:
    for ident, old in source.items():
        assert nodes[ident]["colour"]==old["colour"]
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
radii = [float(r["leaf_radius"]) for r in leaves.values()]
assert max(radii)-min(radii) < 1e-8
assert sorted(int(r["leaf_order"]) for r in leaves.values()) == list(range(1,349))
for (mag, metric), poly in tile_polys.items():
    assert len(poly) == 10
    assert all(float(r["value"]) == float(qc[mag][metric]) for r in poly)
    tile = next(r for r in tiles if r["MAG_ID"]==mag and r["metric"]==metric)
    leaf = leaves[mag]
    ox, oy = float(leaf["origin_x"]), float(leaf["origin_y"])
    theta = math.atan2(float(tile["cy"])-oy,float(tile["cx"])-ox)
    expected = float(leaf["angle"])
    assert abs(math.atan2(math.sin(theta-expected),math.cos(theta-expected))) < 1e-10
    for i, p in enumerate(poly):
        radius = math.hypot(float(p["x"])-ox,float(p["y"])-oy)
        assert math.isclose(radius,float(tile["inner_radius"] if i<5 else tile["outer_radius"]),abs_tol=1e-10)
    assert float(tile["inner_radius"]) > max(radii)
# Equal angular widths smaller than spacing guarantee disjoint ring sectors.
angles = sorted((float(r["angle"]) % (2*math.pi)) for r in leaves.values())
gaps = [(angles[(i+1)%348]-angles[i])%(2*math.pi) for i in range(348)]
assert all(math.isclose(g,2*math.pi/348,abs_tol=1e-10) for g in gaps)
for metric in ("completeness","contamination"):
    assert len({r["inner_radius"] for r in tiles if r["metric"]==metric})==1
    assert len({r["outer_radius"] for r in tiles if r["metric"]==metric})==1
pdf_text = subprocess.check_output(["pdftotext", str(out / "figures/mag_heat_tree_circular_quality.pdf"), "-"], text=True)
assert "Completeness (%)" in pdf_text and "Contamination (%)" in pdf_text
print("PASS: 348 individual MAG leaves; 696 exact aligned ring sectors; common leaf radius and equal angular spacing; 1046 native node areas and all taxonomic clade abundances verified; both PDF quality legends and SHA-256 passed.")
