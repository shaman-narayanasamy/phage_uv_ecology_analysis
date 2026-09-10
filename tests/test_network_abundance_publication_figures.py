"""Verify publication-only S8/S9 geometry and unchanged analytical inputs."""
import csv
import hashlib
from pathlib import Path
import subprocess
import sys
import pdfplumber

def rows(path):
    with path.open() as handle:
        return list(csv.DictReader(handle, delimiter="\t"))

specs = [
    (Path(sys.argv[1]).resolve(strict=True), "host_phage_network_review", "host-phage-network-evidence-audit.pdf", 260,
     ["deduplicated_host_phage_edges.tsv", "linked_host_context.tsv", "linked_phage_catalogue_audit.tsv", "host_phage_network_summary.tsv"]),
    (Path(sys.argv[2]).resolve(strict=True), "community_differential_abundance", "community-differential-abundance.pdf", 180,
     ["mag_deseq2_condition_only.tsv", "mag_deseq2_phase_cycle_adjusted.tsv", "mag_matched_clr.tsv",
      "votu_deseq2_condition_only.tsv", "votu_deseq2_phase_cycle_adjusted.tsv", "votu_matched_clr.tsv",
      "community_restricted_permanova.tsv", "community_pcoa.tsv", "analysis_summary.tsv"]),
]
for root, old, name, height, frozen in specs:
    for table in frozen:
        assert (root / "tables" / table).read_bytes() == (root.parent / old / "tables" / table).read_bytes(), table
    for row in rows(root / "tables/publication_input_provenance.tsv"):
        path = Path(row["path"])
        assert path.stat().st_size == int(row["bytes"])
        assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
    metadata = {r["metric"]: r["value"] for r in rows(root / "tables/publication_layout_metadata.tsv")}
    assert metadata["models_refitted"] == "false"
    archived = root / "source" / Path(metadata["source_notebook"]).name
    assert hashlib.md5(archived.read_bytes()).hexdigest() == metadata["source_notebook_md5"]
    path = root / "figures" / name
    with pdfplumber.open(path) as doc:
        assert len(doc.pages) == 1
        page = doc.pages[0]
        assert abs(page.width / 72 * 25.4 - 180) < .01
        assert abs(page.height / 72 * 25.4 - height) < .01
        assert not page.images, name
        chars = [c for c in page.chars if c["text"].strip()]
        sizes = [c["size"] if c["upright"] else c["width"] for c in chars]
        assert min(sizes) >= 6.4, (name, min(sizes))
        assert all(c["x0"] >= 0 and c["x1"] <= page.width and c["top"] >= 0 and c["bottom"] <= page.height for c in chars), name
        text = page.extract_text()
        if name.startswith("host"):
            summary = {r["metric"]: int(r["value"]) for r in rows(root / "tables/host_phage_network_summary.tsv")}
            assert summary["deduplicated_host_phage_pairs"] == 86
            assert summary["linked_hosts"] == 80 and summary["linked_phages"] == 85
            assert summary["linked_hosts_current_mag_supported"] == 49
            assert summary["linked_phages_passing_high_quality_classified_filter"] == 0
            labels = [r["host_label"] for r in rows(root / "tables/linked_host_context.tsv") if int(r["degree"]) > 1]
            labels += ["Shared candidate (2 hosts)", "SpacePHARER hits", "Linked host MAGs"]
        else:
            labels = ["MAG", "vOTU", "PCoA axis 1", "BH FDR", "Bacteriovoracaceae"]
        for label in labels:
            assert label in text or label in "".join(c["text"] for c in page.chars), (name, label)
    fonts = subprocess.run(["pdffonts", str(path)], capture_output=True, text=True, check=True).stdout.splitlines()[2:]
    assert fonts and all(line.split()[-5] == "yes" for line in fonts if line.strip()), fonts
    for row in rows(root / "output_checksums.md5.tsv"):
        path = root / row["path"]
        assert path.stat().st_size == int(row["bytes"])
        assert hashlib.md5(path.read_bytes()).hexdigest() == row["md5"]
print("PASS: S8/S9 final dimensions; >=6.5 pt within tolerance; vector-only and embedded fonts; thirteen frozen tables unchanged; provenance, labels and output checksums verified. Visual review is separate.")
