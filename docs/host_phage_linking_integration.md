# Host-Phage Linking Integration

This analysis supplies a descriptive phage-host interaction layer for the
manuscript. It does not connect the UV, transcriptomic, or population-genomic
results causally.

## Source Repository

- GitHub: `https://github.com/shaman-narayanasamy/host_phage_linking`
- Local checkout:
  `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/repo_checkouts/host_phage_linking`
- Current local branch when this note was written: `dev`

## Required Role In This Study

The host-phage layer should provide:

- CRISPR spacer/protospacer links between host MAGs/rMAGs and vOTUs/phages.
- CRISPR-Cas host summaries.
- A manuscript-ready host-phage edge table that can join to:
  - rMAG quality/taxonomy and abundance.
  - vOTU quality/taxonomy and abundance.
  - UV/DNA-damage signature summaries.
  - later inStrain/SNV summaries.

## Expected Input Contract

For this study, the reusable pipeline should consume manifest-provided inputs,
not hard-coded project paths.

Required inputs:

- Host genomes: dereplicated rMAG FASTA or representative MAG FASTAs.
- Phage genomes: vOTU/phage FASTA from the PRJEB79569 viromics catalogue.
- Optional direct CRISPR inputs:
  - spacers FASTA
  - repeats FASTA
  - flanks FASTA
- Host metadata:
  - `MAG_ID`
  - rMAG representative ID if separate
  - condition/cycle provenance where applicable
  - taxonomy and quality metrics
- Phage/vOTU metadata:
  - vOTU/contig ID
  - quality
  - taxonomy
  - cluster representative/member mapping

## Expected Output Contract

Minimum outputs to stage into the analysis repo data manifest:

- `host_phage_links.tsv`
  - `MAG_ID`
  - `host_id`
  - `phage_id` or `vOTU_id`
  - `link_method`
  - `score`
  - `n_hits`
  - `spacer_id` if available
  - `protospacer_id` if available
  - `host_taxonomy`
  - `phage_taxonomy`
- `crispr_cas_summary.tsv`
  - `MAG_ID`
  - `crispr_count`
  - `cas_gene_count`
  - `system_type`
- `spacepharer_spacer_alignment_results.tsv`
  - direct SpacePHARER rows without comment headers.
- Optional BLAST tables:
  - `blast/results/spacers/*_final_blast.tsv`
  - `blast/results/repeats/final_blast.tsv`
  - `blast/results/flanks/final_blast.tsv`

## Existing Legacy Logic To Reuse

The previous local poster analysis used:

- `raw/membrane_cleaning_v2/link_hosts_and_phages.qmd`
- `host_phage_linking/scripts/phage_host_linking.qmd`

The useful logic is:

- Read SpacePHARER predictions.
- Summarise host-targeted phages.
- Summarise phage-targeting hosts.
- Produce host-phage network plots.
- Join link tables to MAG/vOTU taxonomy and biofilm/UV summaries.

Do not preserve old absolute paths. Move the logic into manifest-driven scripts
or Quarto sections.

## Current Verified State

- The consolidated local link table contains 148 raw rows, 121 exact unique
  rows, and 86 deduplicated MAG-phage pairs.
- The deduplicated network links 80 MAGs to 85 phage contigs.
- Forty-nine linked MAGs carry a supported current adjusted-membrane MAG
  coefficient, with mixed direction.
- Twelve linked phage representatives have a current catalogue annotation.
- No linked phage representative passes the manuscript's high-quality
  classified-vOTU filter.
- `scripts/build_host_phage_network_figure.qmd` produces the verified evidence
  audit allocated as Supplementary Figure S8.

These links are compatible with historical CRISPR exposure. They do not
demonstrate active infection, treatment response, validated host range,
adsorption through biofilm, or a causal connection to transcription.

## Acceptance Criteria

- The host-phage link table and evidence-audit output are staged and listed in
  `manifests/data_manifest.tsv`.
- Host identifiers map to current MAG taxonomy and complete-transcriptome
  context; phage identifiers map through the current vOTU clustering audit.
- The manuscript includes the complete deduplicated candidate-link network,
  host-signal summary, and viral-catalogue annotation audit as Supplementary
  Figure S8.
