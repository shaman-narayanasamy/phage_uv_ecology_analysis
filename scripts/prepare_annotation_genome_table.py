#!/usr/bin/env python3
"""Create an annotation genome table from dereplicated bin FASTA files."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--genomes-dir", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)

    genomes = []
    if args.genomes_dir.exists():
        for suffix in ("*.fasta", "*.fa", "*.fna"):
            genomes.extend(args.genomes_dir.glob(suffix))

    with args.output.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["fasta"], delimiter="\t")
        writer.writeheader()
        for genome in sorted(set(genomes)):
            writer.writerow({"fasta": str(genome)})


if __name__ == "__main__":
    main()
