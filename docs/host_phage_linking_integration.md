# Host-Phage Linking Integration

This analysis is required for the manuscript story. vOTU ecology and MAG/rMAG
ecology are not enough by themselves; the project needs an explicit
phage-host interaction layer before the UV and SNV results can be interpreted
as a connected system.

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

## Current Blockers

- The current local PRJEB79569 table cache does not contain the host-phage link
  outputs.
- Iris was under maintenance on 2026-07-21, so live path discovery and fetch
  were blocked.
- Once Iris returns, search both:
  - `/scratch/users/snarayanasamy/phage_uv_treatment`
  - the actual host-phage pipeline output root, if different.

## Acceptance Criteria

- A host-phage link table is staged and listed in
  `manifests/data_manifest.tsv`.
- Every `MAG_ID` and `vOTU_id` in the link table can be mapped to staged
  quality/taxonomy tables.
- The manuscript analysis can produce at least:
  - count of host-linked vOTUs by condition/cycle,
  - count of phage-linked MAGs by condition/cycle,
  - prioritized MAG-vOTU pairs with UV signature context.
