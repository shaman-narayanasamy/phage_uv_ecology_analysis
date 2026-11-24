"""Independent equal-sample-weighting and node-aggregation verification."""
import csv
import hashlib
import math
from collections import defaultdict
from pathlib import Path
import sys
out = Path(sys.argv[1])
def rows(path):
    with Path(path).open(newline="") as handle:
        yield from csv.DictReader(handle,delimiter="\t")
inputs = {r["input"]: Path(r["path"]) for r in rows(out/"input_sha256.tsv")}
for manifest,root in ((out/"input_sha256.tsv",None),(out/"output_sha256.tsv",out)):
    for row in rows(manifest):
        path = Path(row["path"]) if root is None else root/row["path"]
        with path.open("rb") as handle:
            assert hashlib.file_digest(handle,"sha256").hexdigest()==row["sha256"],str(path)
counts = list(rows(inputs["counts"]))
totals = defaultdict(float)
for r in counts: totals[r["sample_title"]]+=float(r["reads"])
assert len(totals)==12 and all(v>0 for v in totals.values())
weights = defaultdict(float)
for r in counts: weights[r["contig_id"]]+=float(r["reads"])/totals[r["sample_title"]]/12
assert len(weights)==634 and math.isclose(sum(weights.values()),1,abs_tol=1e-12)
nodes = {r["node_id"]:r for r in rows(out/"tables/tree_nodes.tsv")}
assignments = {r["contig_id"]:r for r in rows(out/"tables/deepest_assignments.tsv")}
assert set(assignments)==set(weights)
taxonomy = {r["contig_id"]:r for r in rows(inputs["taxonomy"])}
ranks = ["realm","kingdom","phylum","class","order","family","subfamily","genus","species"]
abundance = defaultdict(float); members = defaultdict(set); direct=defaultdict(float)
for ident,record in assignments.items():
    assert math.isclose(float(record["mean_abundance"]),weights[ident],abs_tol=1e-12)
    assigned=record["assigned_node"]
    direct[assigned]+=weights[ident]
    actual=[]; visited=set(); node=assigned
    while node:
        assert node not in visited,"Cycle in taxonomy tree"
        visited.add(node)
        abundance[node]+=weights[ident];members[node].add(ident)
        if nodes[node]["rank"] not in ("root","unclassified"):
            actual.append((nodes[node]["rank"],nodes[node]["taxon"]))
        node=nodes[node]["parent"]
    expected=[(rank,taxonomy[ident][rank]) for rank in ranks if taxonomy[ident][rank]]
    assert list(reversed(actual))==expected,(ident,actual,expected)
for ident,node in nodes.items():
    assert math.isclose(float(node["clade_abundance"]),abundance[ident],abs_tol=1e-12)
    assert math.isclose(float(node["direct_abundance"]),direct[ident],abs_tol=1e-12)
    assert int(node["clade_votus"])==len(members[ident])
    children=[r for r in nodes.values() if r["parent"]==ident]
    assert math.isclose(abundance[ident],direct[ident]+sum(float(r["clade_abundance"]) for r in children),abs_tol=1e-12)
print(f"PASS: {len(nodes)} nodes, 634 assignments, 12 equally weighted samples; all ancestral paths, clade abundances, direct assignments and SHA-256 hashes verified.")
