#!/usr/bin/env python3
"""Normalize inStrain genome-wide compare output to manuscript-ready TSVs."""

import argparse
import csv
import os
from collections import defaultdict
from pathlib import Path


COMPARE_COLUMNS = [
    "MAG_ID",
    "sample_a",
    "sample_b",
    "condition_a",
    "condition_b",
    "phase_a",
    "phase_b",
    "cycle_a",
    "cycle_b",
    "analysis_group_a",
    "analysis_group_b",
    "comparison_axis",
    "comparison_label",
    "coverage_overlap",
    "compared_bases_count",
    "percent_compared",
    "consensus_SNPs",
    "population_SNPs",
    "popANI",
    "conANI",
    "SNV_distance",
]

RMAG_COLUMNS = [
    "MAG_ID",
    "comparison_axis",
    "comparison_label",
    "n_valid_pairs",
    "mean_snv_distance",
    "mean_popani",
    "mean_compared_bases",
    "interpretation_status",
]


def read_tsv(path):
    with path.open(newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        if reader.fieldnames is None:
            raise SystemExit("{} is empty or missing a header".format(path))
        return [{key: (value or "") for key, value in row.items()} for row in reader]


def write_tsv(path, rows, columns):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, columns, delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def as_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def basename(path):
    return os.path.basename(path)


def build_bam_metadata(manifest_rows):
    by_bam = {}
    required = {"sample_id", "condition", "phase", "cycle", "analysis_group", "bam_path"}
    present = set(manifest_rows[0]) if manifest_rows else set()
    missing = sorted(required - present)
    if missing:
        raise SystemExit("BAM manifest missing columns: {}".format(", ".join(missing)))
    for row in manifest_rows:
        bam_name = basename(row["bam_path"])
        by_bam[bam_name] = row
    return by_bam


def comparison_axis(meta_a, meta_b):
    if meta_a["condition"] != meta_b["condition"]:
        return "condition"
    if meta_a["cycle"] != meta_b["cycle"]:
        return "cycle"
    if meta_a["phase"] != meta_b["phase"]:
        return "phase"
    return "technical_or_same_group"


def comparison_label(axis, meta_a, meta_b):
    if axis == "condition":
        order = {"control": 0, "uv": 1, "treatment": 1}
        values = sorted([meta_a["condition"], meta_b["condition"]], key=lambda value: (order.get(value, 99), value))
        return "{}__vs__{}".format(values[0], values[1])
    if axis == "cycle":
        values = sorted([meta_a["cycle"], meta_b["cycle"]], key=lambda value: int(value) if value.isdigit() else 99)
        return "cycle{}__vs__cycle{}".format(values[0], values[1])
    if axis == "phase":
        order = {"initial_flow": 0, "initial": 0, "backflush": 1}
        values = sorted([meta_a["phase"], meta_b["phase"]], key=lambda value: (order.get(value, 99), value))
        return "{}__vs__{}".format(values[0], values[1])
    values = sorted([meta_a["analysis_group"], meta_b["analysis_group"]])
    return "{}__vs__{}".format(values[0], values[1])


def summarize(rows):
    groups = defaultdict(list)
    for row in rows:
        compared = as_float(row["compared_bases_count"])
        if compared is None or compared <= 0:
            continue
        groups[(row["MAG_ID"], row["comparison_axis"], row["comparison_label"])].append(row)

    out = []
    for (mag, axis, label), group_rows in sorted(groups.items()):
        snv = [as_float(row["SNV_distance"]) for row in group_rows]
        popani = [as_float(row["popANI"]) for row in group_rows]
        bases = [as_float(row["compared_bases_count"]) for row in group_rows]
        snv = [value for value in snv if value is not None]
        popani = [value for value in popani if value is not None]
        bases = [value for value in bases if value is not None]
        out.append(
            {
                "MAG_ID": mag,
                "comparison_axis": axis,
                "comparison_label": label,
                "n_valid_pairs": len(group_rows),
                "mean_snv_distance": "{:.6g}".format(sum(snv) / len(snv)) if snv else "",
                "mean_popani": "{:.8g}".format(sum(popani) / len(popani)) if popani else "",
                "mean_compared_bases": "{:.6g}".format(sum(bases) / len(bases)) if bases else "",
                "interpretation_status": "strain_divergence_summary",
            }
        )
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--genomewide-compare", required=True, type=Path)
    parser.add_argument("--bam-manifest", required=True, type=Path)
    parser.add_argument("--compare-summary-output", required=True, type=Path)
    parser.add_argument("--rmag-output", required=True, type=Path)
    args = parser.parse_args()

    compare_rows = read_tsv(args.genomewide_compare)
    metadata_by_bam = build_bam_metadata(read_tsv(args.bam_manifest))

    normalized = []
    for row in compare_rows:
        meta_a = metadata_by_bam.get(row.get("name1", ""))
        meta_b = metadata_by_bam.get(row.get("name2", ""))
        if meta_a is None or meta_b is None:
            raise SystemExit(
                "Could not map compare names to BAM manifest: {} {}".format(
                    row.get("name1", ""), row.get("name2", "")
                )
            )
        axis = comparison_axis(meta_a, meta_b)
        label = comparison_label(axis, meta_a, meta_b)
        normalized.append(
            {
                "MAG_ID": row.get("genome", ""),
                "sample_a": meta_a["sample_id"],
                "sample_b": meta_b["sample_id"],
                "condition_a": meta_a["condition"],
                "condition_b": meta_b["condition"],
                "phase_a": meta_a["phase"],
                "phase_b": meta_b["phase"],
                "cycle_a": meta_a["cycle"],
                "cycle_b": meta_b["cycle"],
                "analysis_group_a": meta_a["analysis_group"],
                "analysis_group_b": meta_b["analysis_group"],
                "comparison_axis": axis,
                "comparison_label": label,
                "coverage_overlap": row.get("coverage_overlap", ""),
                "compared_bases_count": row.get("compared_bases_count", ""),
                "percent_compared": row.get("percent_compared", ""),
                "consensus_SNPs": row.get("consensus_SNPs", ""),
                "population_SNPs": row.get("population_SNPs", ""),
                "popANI": row.get("popANI", ""),
                "conANI": row.get("conANI", ""),
                "SNV_distance": row.get("consensus_SNPs", ""),
            }
        )

    write_tsv(args.compare_summary_output, normalized, COMPARE_COLUMNS)
    write_tsv(args.rmag_output, summarize(normalized), RMAG_COLUMNS)
    print("compare_rows={}".format(len(normalized)))
    print("rmag_summary_rows={}".format(len(summarize(normalized))))
    print("compare_summary_output={}".format(args.compare_summary_output))
    print("rmag_output={}".format(args.rmag_output))


if __name__ == "__main__":
    main()
