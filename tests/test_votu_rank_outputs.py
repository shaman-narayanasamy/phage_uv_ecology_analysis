"""Independent raw-input check of the R-produced rank review. No files modified."""
import csv
import hashlib
import math
from collections import defaultdict
from pathlib import Path
import re
import sys

out = Path(sys.argv[1])
def rows(path):
    with Path(path).open(newline="") as handle:
        yield from csv.DictReader(handle, delimiter="\t")
inputs = {r["input"]: Path(r["path"]) for r in rows(out / "input_sha256.tsv")}
for manifest, root in ((out / "input_sha256.tsv", None), (out / "output_sha256.tsv", out)):
    for row in rows(manifest):
        path = Path(row["path"]) if root is None else root / row["path"]
        with path.open("rb") as handle:
            digest = hashlib.file_digest(handle, "sha256").hexdigest()
        assert digest == row["sha256"], f"Changed file: {path}"
qc = {r["contig_id"] for r in rows(inputs["checkv"])
      if r["miuvig_quality"] == "High-quality" and int(r["viral_genes"]) > 0}
annotations = defaultdict(list)
for row in rows(inputs["taxonomy"]):
    if row["input_name"] in qc:
        annotations[row["input_name"]].append(row)
taxa = {}
for ident, hits in annotations.items():
    first = sorted(hits, key=lambda x: (-int(x["virus_seq_length"]), x["taxonomy_hierarchy"]))[0]
    taxa[ident] = first["taxonomy_hierarchy"]
missing_ids = qc - taxa.keys()
blank_ids = {ident for ident, lineage in taxa.items() if not lineage}
assert len(missing_ids)==18 and len(blank_ids)==9
taxa.update({ident: "" for ident in missing_ids})
baseline_ids = {ident for ident, lineage in taxa.items() if lineage}
assert len(qc) == len(taxa) == 634 and len(baseline_ids) == 607
assert qc <= {r["representative"] for r in rows(inputs["representatives"])}
samples = {r["metagenome_run_accession"]: r["sample_title"] for r in rows(inputs["metadata"])}
assert len(samples) == len(set(samples.values())) == 12
counts = {}
for row in rows(inputs["counts"]):
    if row["Contig"] not in qc:
        continue
    assert row["Contig"] not in counts
    counts[row["Contig"]] = {samples[re.search(r"ERR\d+", key)[0]]: float(value)
                            for key, value in row.items() if key != "Contig"}
assert set(counts) == qc
totals = {s: math.fsum(counts[i][s] for i in taxa) for s in samples.values()}
prefixes = dict(realm="r_", kingdom="k_", phylum="p_", **{"class": "c_"}, order="o_", family="f_", genus="g_")
all_prefixes = ("r_","k_","p_","c_","o_","f_","sf_","g_","s_")
for rank, prefix in {**prefixes,"mixed":""}.items():
    expected = defaultdict(float)
    for ident, lineage in taxa.items():
        parts = lineage.split(";")
        match = [p[len(prefix):] for p in parts if p.startswith(prefix)]
        if rank == "realm" and not match and len(parts) > 1 and parts[0] == "-_Viruses":
            match = [parts[1].removeprefix("-_")]
        label = match[0] if match else ""
        if rank == "mixed":
            assigned = {p[:p.index("_")+1]: p for p in parts if "_" in p and not p.startswith("-_")}
            if len(parts)>1 and parts[0]=="-_Viruses" and parts[1].startswith("-_"):
                assigned["r_"] = "r_"+parts[1][2:]
            specific = [assigned[p] for p in all_prefixes if p in assigned and
                        not re.search(r"unclassified|unknown|incertae|_NA$",assigned[p],re.I)]
            label = specific[-1] if specific else ""
        if not label or re.search(r"unclassified|unknown|incertae|^NA$", label, re.I):
            label = "Unresolved at this rank"
        for sample, reads in counts[ident].items():
            expected[sample, label] += reads
    observed = list(rows(out / "tables" / f"{rank}_profile.tsv"))
    shown = {r["category"] for r in observed}
    if "Other classified taxa" in shown:
        collapsed = defaultdict(float)
        for (sample,label),reads in expected.items():
            collapsed[sample,label if label in shown else "Other classified taxa"] += reads
        expected = collapsed
    assert len(observed) == len(expected)
    for row in observed:
        key = row["sample_title"], row["category"]
        assert float(row["reads"]) == expected[key], (rank, key)
        assert math.isclose(float(row["relative_abundance"]), expected[key] / totals[key[0]], abs_tol=1e-12)
    print(f"PASS {rank}: raw counts, taxonomy, sample mapping, denominator, proportions")
for row in rows(out / "tables/denominator_sensitivity.tsv"):
    s = row["sample_title"]
    assert float(row["all_634_reads"]) == math.fsum(counts[i][s] for i in qc)
    assert float(row["excluded_27_reads"]) == math.fsum(counts[i][s] for i in qc - baseline_ids)
    assert float(row["missing_18_reads"]) == math.fsum(counts[i][s] for i in missing_ids)
    assert float(row["blank_9_reads"]) == math.fsum(counts[i][s] for i in blank_ids)
print("PASS: all input/output SHA-256 hashes and excluded-27-vOTU audit")
