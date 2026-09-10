# Standalone legend audit after the publication-size rebuild

Status: source-based editorial audit implemented as native suggestions in the
live manuscript, verified at `20260909T191526Z`. Exact revisions and remaining
formatting/provenance scope are recorded in `2026-09-09-legend-clarifications.json`
and `2026-09-09-legend-source-evidence.md`. The checklist below preserves the
pre-revision findings, not a claim that those edits remain unimplemented.
Baseline: `manuscript/figure_legends.md` archived in supplementary report v3;
live readback `20260909T184447Z`. Keep the verified v3 snapshot unchanged.

## Required revisions

The legends mostly describe the panels correctly, but several depend on
abbreviations or rules defined elsewhere. The scientific design remains one
membrane per condition; repeated observations must not be called replicates.
Expand shared abbreviations at first use within each independently viewed
legend where practical, not only in the main text.

| Figure | Remaining standalone-reader requirement |
| --- | --- |
| 1 | Expand MAG, vOTU and BH FDR; state the microbial/viral catalogue denominators and the six-cell label-swap boundary explicitly. Retain distinction between 607 classified composition features and 616 abundance candidates. |
| 2 | Expand TMM, BH FDR and counts per million; state the context-point selection size from the frozen display table. Keep full-universe counts distinct from displayed context points. |
| 3 | Expand MAG, GTDB and FDR; identify eligible set size or direct source-table destination. Retain directional competitive-rank interpretation, not pathway activation. |
| 4 | Give the exact detection and annotation criteria behind panel A, rather than only naming the filters. Define initial/backflush labels and whether selection is conditional on recurrence. |
| 5 | Define C/P, I/BF, cycle suffixes and S-number labels. Explain grey off-diagonal cells and white diagonal separately. Verify cluster generation thresholds from archived execution evidence before stating them. |
| S1 | Expand TMM and quasi-likelihood; specify physical-sample count and membrane/phase symbols locally. |
| S2 | Define BH FDR and counts per million; preserve cycle-1 reference and non-directional two-degree-of-freedom omnibus. State deterministic context-point selection size. |
| S3 | Define signed scale for directional coefficients and non-directional omnibus scale locally; link the eight set definitions to their source table. |
| S4 | Expand MAG and BH FDR; clarify that interaction direction describes a change in the membrane contrast, not simply higher expression in one membrane. |
| S5 | Define sample-label abbreviations and white diagonal separately from grey unavailable comparisons. Name the organism-level selection rule locally. |
| S6 | Define MAG/GTDB, inside-to-outside ring order and recurrent-gene balance; retain taxonomic dendrogram rather than sequence phylogeny wording. |
| S7 | Expand vOTU and state the viral-gene and taxonomy eligibility rules behind the 607-catalogue denominator. Retain taxonomy-only tree interpretation. |
| S8 | Expand MAG/GTDB; preserve candidate-link status and zero overlap with the high-quality classified set. Check that node/edge legend wording matches the final display; do not turn evidence links into infection claims. |
| S9 | Expand MAG/vOTU, BH FDR and CLR; distinguish 616 input vOTUs from 560 tested features after filtering. Keep model sensitivity and lack of membrane replication explicit. |
| S10 | Expand ASV, GTDB and cDNA for standalone use; preserve pre-denoising subsampling versus post-denoising unrarefied counts. Do not imply equal final read depth. |

## Verified Figure 5 encoding facts

`scripts/build_remaining_manuscript_figures.qmd` explicitly orders labels as
`C I1` through `C BF3`, then `P I1` through `P BF3`. C is the control membrane,
P the phage-UV membrane, I initial and BF backflush; 1-3 are cleaning cycles.
Panel A tile fill represents membrane, not cluster identity. Cluster text is
copied from the returned cluster table and renamed to an S-prefixed label in
`scripts/build_mag_genomic_variation_dossiers.qmd`. The numeric suffix is not
an evolutionary distance or a cross-MAG strain identifier.

Panel A missing entries are explicitly drawn light grey (`#EFEFEF`). The
plot builder alone proves absence from the joined cluster table, not the
specific reason for each absence. Therefore the current blanket phrase
"absent or coverage-failing sample profiles" needs upstream verification or
more precise wording, e.g. "grey cells lack a reported cluster assignment".

Panel C retains only `pair_passes_qc == TRUE` comparisons and fills missing
off-diagonal entries grey (`#EAEAEA`). Diagonal cells are separately overlaid
white. They are not observed zero-difference estimates. The colour scale is
log10-transformed; the legend should say so. The current scale does not encode
DNA damage or UV-specific mutagenesis.

## Implementation sequence

1. Resolve source-dependent details (recurrence filters and cluster provenance)
   using existing code/output and archived commands, without rerunning models.
2. Prepare exact before/after caption payloads against a fresh read-only live
   snapshot so author changes are preserved.
3. Apply native suggestions only; verify both caption locations, all figures,
   remaining text and citation metadata. Do not accept the agent's suggestions.
4. Rebuild the companion into a new version after the complete legend pass,
   then render, inspect and verify its source archive and scoped uploads.

The audit itself changed no numeric result or released report. Its subsequent
implementation updated the canonical and live legends while preserving all
other text, image objects and original Zotero metadata. Report v3 remains
unchanged; its successor must incorporate these revisions.
