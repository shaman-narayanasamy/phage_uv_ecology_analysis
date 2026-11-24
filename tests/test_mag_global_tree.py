"""Independently reconstruct all MAG clade weights from raw contig counts."""
import csv
import hashlib
import math
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

out = Path(sys.argv[1])


def rows(path):
    with Path(path).open(newline="") as handle:
        yield from csv.DictReader(handle, delimiter="\t")


inputs = {r["input"]: Path(r["path"]) for r in rows(out / "input_sha256.tsv")}
for manifest, root in ((out / "input_sha256.tsv", None), (out / "output_sha256.tsv", out)):
    for record in rows(manifest):
        path = Path(record["path"]) if root is None else root / record["path"]
        with path.open("rb") as handle:
            assert hashlib.file_digest(handle, "sha256").hexdigest() == record["sha256"], str(path)

taxa = {r["# bin"].removesuffix(".fasta"): r for r in rows(inputs["taxonomy"])}
assert len(taxa) == 348
meta = {r["metagenome_run_accession"]: r["sample_title"] for r in rows(inputs["metadata"])}
assert len(meta) == len(set(meta.values())) == 12
raw_counts = defaultdict(lambda: defaultdict(float))
contig_numbers = Counter()
seen = set()
with inputs["counts"].open(newline="") as handle:
    reader = csv.DictReader(handle, delimiter="\t")
    columns = [c for c in reader.fieldnames if c != "Contig"]
    runs = [re.search(r"ERR\d+", c).group() for c in columns]
    assert len(runs) == 12 and set(runs) == set(meta)
    samples = [meta[run] for run in runs]
    for record in reader:
        contig = record["Contig"]
        assert contig not in seen
        seen.add(contig)
        if "_MAGScoT_" not in contig:
            continue
        # Independent parser uses token structure, not the R substitution.
        pieces = contig.split("_")
        assert pieces[1:3] == ["MAGScoT", "cleanbin"] and pieces[3].isdigit()
        mag = "_".join(pieces[:4])
        assert mag in taxa
        contig_numbers[mag] += 1
        for column, sample in zip(columns, samples):
            value = float(record[column])
            assert math.isfinite(value) and value >= 0
            raw_counts[mag][sample] += value
assert set(raw_counts) == set(taxa)
totals = {sample: sum(raw_counts[mag][sample] for mag in taxa) for sample in meta.values()}
assert all(v > 0 for v in totals.values())
weights = {mag: sum(raw_counts[mag][s] / totals[s] for s in totals) / 12 for mag in taxa}
assert math.isclose(sum(weights.values()), 1, abs_tol=1e-12)
published_counts = list(rows(out / "tables/mag_sample_counts.tsv"))
assert len(published_counts) == 348 * 12
assert len({(r["MAG_ID"], r["sample_title"]) for r in published_counts}) == 348 * 12
for r in published_counts:
    mag, sample = r["MAG_ID"], r["sample_title"]
    assert float(r["reads"]) == raw_counts[mag][sample]
    assert math.isclose(float(r["proportion"]), raw_counts[mag][sample] / totals[sample], abs_tol=1e-12)
for r in rows(out / "tables/sample_denominators.tsv"):
    assert float(r["total_reads"]) == totals[r["sample_title"]]
assert {r["MAG_ID"]: int(r["contigs"]) for r in rows(out / "tables/contig_inventory.tsv")} == contig_numbers
nodes = {r["node_id"]: r for r in rows(out / "tables/tree_nodes.tsv")}
assignments = {r["MAG_ID"]: r for r in rows(out / "tables/deepest_assignments.tsv")}
assert set(assignments) == set(taxa)
rank_names = dict(zip("dpcofgs", ("domain", "phylum", "class", "order", "family", "genus", "species")))
abundance = defaultdict(float)
direct = defaultdict(float)
members = defaultdict(set)
direct_members = defaultdict(set)
for mag, record in assignments.items():
    assert math.isclose(float(record["mean_abundance"]), weights[mag], abs_tol=1e-12)
    assigned = record["assigned_node"]
    direct[assigned] += weights[mag]
    direct_members[assigned].add(mag)
    node, visited, actual = assigned, set(), []
    while node:
        assert node not in visited, "Cycle"
        visited.add(node)
        abundance[node] += weights[mag]
        members[node].add(mag)
        if nodes[node]["rank"] != "root":
            actual.append((nodes[node]["rank"], nodes[node]["taxon"]))
        node = nodes[node]["parent"]
    expected = [(rank_names[t[0]], t[3:]) for t in taxa[mag]["lineage"].split(";") if len(t) > 3 and t[1:3] == "__" and t[0] in rank_names]
    assert list(reversed(actual)) == expected, (mag, actual, expected)
for ident, node in nodes.items():
    assert math.isclose(float(node["clade_abundance"]), abundance[ident], abs_tol=1e-12)
    assert math.isclose(float(node["direct_abundance"]), direct[ident], abs_tol=1e-12)
    assert int(node["clade_mags"]) == len(members[ident])
    assert int(node["direct_mags"]) == len(direct_members[ident])
    children = [r for r in nodes.values() if r["parent"] == ident]
    assert math.isclose(abundance[ident], direct[ident] + sum(float(r["clade_abundance"]) for r in children), abs_tol=1e-12)
    if node["rank"] in ("root", "domain"):
        assert node["phylum"] == "Domain"
    else:
        for mag in members[ident]:
            expected_phylum = next((t[3:] for t in taxa[mag]["lineage"].split(";") if t.startswith("p__")), "Unclassified")
            assert node["phylum"] == expected_phylum
layout = list(rows(out / "tables/tree_layout.tsv"))
assert {r["label"] for r in layout} == set(nodes)
assert all(math.isfinite(float(r[k])) for r in layout for k in ("x", "y"))
print(f"PASS: {sum(contig_numbers.values())} contigs, 348 MAGs, 12 equally weighted samples, {len(nodes)} nodes; raw counts, paths, clade/direct weights, phylum groups, SHA-256 verified.")
