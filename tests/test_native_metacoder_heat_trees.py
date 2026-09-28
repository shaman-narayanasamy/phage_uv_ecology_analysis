"""Verify native-renderer inputs preserve every previously audited node/value."""
import csv
import hashlib
import math
import sys
from pathlib import Path

out = Path(sys.argv[1])


def rows(path):
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


for manifest, root in ((out / "input_sha256.tsv", None), (out / "output_sha256.tsv", out)):
    for record in rows(manifest):
        path = Path(record["path"]) if root is None else root / record["path"]
        with path.open("rb") as handle:
            assert hashlib.file_digest(handle, "sha256").hexdigest() == record["sha256"], str(path)
for community, expected, members in (("votu", 76, 634), ("mag", 698, 348)):
    source = {r["node_id"]: r for r in rows(out / f"source/{community}_nodes.tsv")}
    plotted = rows(out / f"tables/{community}_plotted_nodes.tsv")
    assert len(source) == len(plotted) == expected
    assert {r["node_id"] for r in plotted} == set(source)
    labels = {r["label"]: r for r in rows(out / f"source/{community}_labels.tsv")}
    for record in plotted:
        ident = record["node_id"]
        for field, value in source[ident].items():
            assert record[field] == value, (community, ident, field)
        assert math.isclose(float(record["mean_percent"]), 100 * float(record["clade_abundance"]), abs_tol=1e-11)
        label = labels[ident]
        show = label["show_label"] == "TRUE"
        if community == "mag" and record["rank"] == "phylum" and float(record["clade_abundance"]) < .01:
            show = False
        assert record["plot_label"] == (label["label_text"] if show else "")
        assert record["colour"].startswith("#") and len(record["colour"]) == 7
    root = source["n000"]
    assert float(root["clade_abundance"]) == 1
    assert int(root["clade_mags" if community == "mag" else "clade_votus"]) == members
    assert (out / f"figures/{community}_native_heat_tree.pdf").stat().st_size > 1000
    assert (out / f"source/{community}_native_heat_tree.rds").is_file()
code = (out / "source/native_metacoder_heat_trees.qmd").read_text()
assert "metacoder::heat_tree(" in code
assert 'layout="davidson-harel",initial_layout="reingold-tilford"' in code
assert "library(ggtree)" not in code and "geom_label_repel(" not in code
assert "ggtree::" not in code and "ggrepel::" not in code
runtime = {r["Package"]: r["Version"] for r in rows(out / "source/runtime_packages.tsv")}
assert runtime["metacoder"] == "0.3.9"
print("PASS: native metacoder 0.3.9; all 774 node records, labels, clade weights and source/output hashes preserved; both PDFs present.")
