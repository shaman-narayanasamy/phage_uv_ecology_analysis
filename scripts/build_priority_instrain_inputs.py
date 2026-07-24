#!/usr/bin/env python3
"""Build prioritized MAG scaffold lists and STB files for scoped inStrain runs."""

import argparse
import csv
from collections import Counter, defaultdict
from pathlib import Path


def read_host_links(path):
    link_counts = Counter()
    with path.open(newline="") as handle:
        for row in csv.DictReader(handle, delimiter="\t"):
            mag = row.get("MAG_ID") or row.get("host_id")
            if mag:
                link_counts[mag] += 1
    return link_counts


def read_uv_counts(path):
    uv_counts = defaultdict(int)
    with path.open(newline="") as handle:
        for row in csv.DictReader(handle, delimiter="\t"):
            mag = row.get("MAG_ID")
            if not mag:
                continue
            try:
                value = int(row.get("n_unique_signature_symbols") or 0)
            except ValueError:
                value = 0
            uv_counts[mag] += value
    return uv_counts


def choose_mags(link_counts, uv_counts, limit):
    rows = []
    for mag, n_links in link_counts.items():
        uv_count = uv_counts.get(mag, 0)
        if uv_count > 0:
            rows.append((mag, n_links, uv_count))
    rows.sort(key=lambda row: (-row[1], -row[2], row[0]))
    return rows[:limit]


def write_priority_files(scaffold_map, chosen, output_dir):
    chosen_mags = {row[0] for row in chosen}
    scaffold_rows = []
    with scaffold_map.open(newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            if row.get("entity_type") == "MAG" and row.get("entity_id") in chosen_mags:
                scaffold_rows.append((row["scaffold_id"], row["entity_id"]))

    output_dir.mkdir(parents=True, exist_ok=True)
    mag_list = output_dir / "priority_mags.tsv"
    scaffold_list = output_dir / "priority_mag_scaffolds.txt"
    stb = output_dir / "priority_mag_scaffolds.stb"

    with mag_list.open("w", newline="") as handle:
        writer = csv.writer(handle, delimiter="\t", lineterminator="\n")
        writer.writerow(["MAG_ID", "host_phage_link_rows", "uv_signature_symbols"])
        writer.writerows(chosen)

    with scaffold_list.open("w") as handle:
        for scaffold, _mag in scaffold_rows:
            handle.write(scaffold + "\n")

    with stb.open("w") as handle:
        for scaffold, mag in scaffold_rows:
            handle.write("{}\t{}\n".format(scaffold, mag))

    return mag_list, scaffold_list, stb, len(scaffold_rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host-phage-links", required=True, type=Path)
    parser.add_argument("--uv-mag-summary", required=True, type=Path)
    parser.add_argument("--scaffold-map", required=True, type=Path)
    parser.add_argument("--output-dir", required=True, type=Path)
    parser.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()

    chosen = choose_mags(
        read_host_links(args.host_phage_links),
        read_uv_counts(args.uv_mag_summary),
        args.limit,
    )
    if not chosen:
        raise SystemExit("No MAGs were both host-phage linked and UV-signature positive")
    mag_list, scaffold_list, stb, n_scaffolds = write_priority_files(args.scaffold_map, chosen, args.output_dir)
    print("priority_mags={}".format(len(chosen)))
    print("priority_scaffolds={}".format(n_scaffolds))
    print("mag_list={}".format(mag_list))
    print("scaffold_list={}".format(scaffold_list))
    print("stb={}".format(stb))


if __name__ == "__main__":
    main()
