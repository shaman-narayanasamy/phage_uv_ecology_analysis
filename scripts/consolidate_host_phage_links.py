#!/usr/bin/env python3
"""Consolidate per-host SpacePHARER predictions into downstream TSV tables."""

import argparse
import csv
from collections import Counter
from pathlib import Path
from typing import Dict, List, Tuple


LINK_COLUMNS = [
    "MAG_ID",
    "host_id",
    "phage_id_or_vOTU_id",
    "link_method",
    "score",
    "n_hits",
    "spacer_id",
    "protospacer_id",
    "host_taxonomy",
    "phage_taxonomy",
    "source_prediction_file",
    "phage_db_id",
]
SUMMARY_COLUMNS = ["metric", "value"]


def split_prediction_dir(path):
    name = path.parent.name
    if "-x-" not in name:
        return name, ""
    host_id, phage_db_id = name.rsplit("-x-", 1)
    return host_id, phage_db_id


def clean_host_id(host_id):
    for suffix in (".out", ".txt"):
        if host_id.endswith(suffix):
            return host_id[: -len(suffix)]
    return host_id


def split_fields(line):
    line = line.rstrip("\n")
    if "\t" in line:
        return line.split("\t")
    return line.split()


def read_predictions(prediction_files):
    # type: (List[Path]) -> Tuple[List[Dict[str, str]], List[Dict[str, str]], Counter]
    links = []  # type: List[Dict[str, str]]
    raw_alignments = []  # type: List[Dict[str, str]]
    metrics: Counter = Counter()
    max_alignment_fields = 0

    for prediction_file in prediction_files:
        host_id, phage_db_id = split_prediction_dir(prediction_file)
        host_id = clean_host_id(host_id)
        metrics["prediction_files_total"] += 1
        file_has_link = False

        with prediction_file.open() as handle:
            for line_number, line in enumerate(handle, start=1):
                stripped = line.strip()
                if not stripped:
                    continue
                if stripped.startswith("#"):
                    fields = split_fields(stripped.lstrip("#"))
                    if len(fields) < 4:
                        metrics["comment_rows_too_short"] += 1
                        continue
                    links.append(
                        {
                            "MAG_ID": clean_host_id(fields[0]),
                            "host_id": clean_host_id(fields[0]),
                            "phage_id_or_vOTU_id": fields[1],
                            "link_method": "crispr_spacepharer",
                            "score": fields[2],
                            "n_hits": fields[3],
                            "spacer_id": "",
                            "protospacer_id": "",
                            "host_taxonomy": "",
                            "phage_taxonomy": "",
                            "source_prediction_file": str(prediction_file),
                            "phage_db_id": phage_db_id,
                        }
                    )
                    file_has_link = True
                    metrics["host_phage_link_rows"] += 1
                else:
                    fields = split_fields(stripped)
                    max_alignment_fields = max(max_alignment_fields, len(fields))
                    row = {
                        "MAG_ID": host_id,
                        "host_id": host_id,
                        "phage_db_id": phage_db_id,
                        "source_prediction_file": str(prediction_file),
                        "source_line_number": str(line_number),
                    }
                    for index, value in enumerate(fields, start=1):
                        row[f"field_{index}"] = value
                    raw_alignments.append(row)
                    metrics["spacepharer_alignment_rows"] += 1

        if file_has_link:
            metrics["prediction_files_with_links"] += 1

    alignment_columns = [
        "MAG_ID",
        "host_id",
        "phage_db_id",
        "source_prediction_file",
        "source_line_number",
    ] + [f"field_{index}" for index in range(1, max_alignment_fields + 1)]
    for row in raw_alignments:
        for column in alignment_columns:
            row.setdefault(column, "")

    metrics["prediction_files_empty_or_without_links"] = (
        metrics["prediction_files_total"] - metrics["prediction_files_with_links"]
    )
    metrics["unique_hosts_with_links"] = len({row["host_id"] for row in links})
    metrics["unique_phages_linked"] = len({row["phage_id_or_vOTU_id"] for row in links})
    return links, raw_alignments, metrics


def write_tsv(path, rows, columns):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, columns, delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--predictions-root", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    args = parser.parse_args()

    prediction_files = sorted(args.predictions_root.glob("*-x-*/predictions.tsv"))
    if not prediction_files:
        raise SystemExit(f"No predictions.tsv files found under {args.predictions_root}")

    links, raw_alignments, metrics = read_predictions(prediction_files)
    alignment_columns = list(raw_alignments[0]) if raw_alignments else [
        "MAG_ID",
        "host_id",
        "phage_db_id",
        "source_prediction_file",
        "source_line_number",
    ]

    summary_rows = [{"metric": key, "value": str(value)} for key, value in sorted(metrics.items())]
    write_tsv(args.output_dir / "host_phage_links.tsv", links, LINK_COLUMNS)
    write_tsv(args.output_dir / "spacepharer_spacer_alignment_results.tsv", raw_alignments, alignment_columns)
    write_tsv(args.output_dir / "host_phage_link_summary.tsv", summary_rows, SUMMARY_COLUMNS)


if __name__ == "__main__":
    main()
