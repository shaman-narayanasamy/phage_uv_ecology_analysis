#!/usr/bin/env python3
"""Create the PRJEB79569 binning input table from staged metadata."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata", required=True, type=Path)
    parser.add_argument("--mg-preprocessing-dir", required=True, type=Path)
    parser.add_argument("--coassembly-dir", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)

    rows = []
    with args.metadata.open(newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            if row.get("omics") != "MG":
                continue
            biological_sample = row["biological_sample_alias"]
            mg_sample = row["sample_alias"]
            sample_dir = args.mg_preprocessing_dir / mg_sample
            rows.append(
                {
                    "sample_alias": biological_sample,
                    "R1": sample_dir / f"{mg_sample}_R1.processed.fastq.gz",
                    "R2": sample_dir / f"{mg_sample}_R2.processed.fastq.gz",
                    "SE": sample_dir / f"{mg_sample}_SE.processed.fastq.gz",
                    "fasta": args.coassembly_dir
                    / biological_sample
                    / f"{biological_sample}.coassembly_contigs.fa",
                }
            )

    rows.sort(key=lambda row: row["sample_alias"])
    with args.output.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["sample_alias", "R1", "R2", "SE", "fasta"], delimiter="\t")
        writer.writeheader()
        for row in rows:
            writer.writerow({key: str(value) for key, value in row.items()})


if __name__ == "__main__":
    main()
