# Pre-submission reproducibility audit

Audit date: 2026-09-07

Status: complete for the repository and returned-16S descriptive integration.
The manuscript was intentionally not edited during this pass; final issues #30
and #31 remain open for author review, allocation, and scientific wording.

## Verified current state

- All 18 repository R tests pass, including the synthetic full-transcriptome
  edgeR run and checksum validation of the complete manuscript figure suite.
- `scripts/validate_manifests.sh` passes every metadata, 16S input and returned
  output contract, Quarto-entrypoint, citation, manuscript-structure,
  data-path, and HPC Conda policy check.
- All 24 canonical `scripts/*.qmd` notebooks structure-render to GFM with
  execution disabled under the RStudio-bundled Quarto 1.9.37. GFM is used for
  this structural gate because HTML rendering opens Quarto's macOS user-level
  Sass cache, which is intentionally unwritable in a restricted audit runtime.
- The manuscript builds to DOCX with Pandoc 3.10 and the canonical BibTeX file.
- The original 13 candidate PDFs remain byte-identical to the checksums recorded
  during the complete visual audit in `docs/figure_visual_qa_2026-08-29.md`.
  The visually inspected host-phage evidence-audit PDF is separately bound by
  SHA-256 and allocated as Supplementary Figure S8.
- The returned 16S integration adds two visually inspected, checksum-governed
  vector PDFs: a longitudinal community candidate and a complete-study workflow
  overview. Its sample contract, Bray-Curtis summaries, fixed family colours,
  workflow graph, and PDF signatures are tested.
- The repository has no source-adjacent or root-level generated artifacts. A
  pre-existing untracked `Rplots.pdf`, dated before this analysis pass, was
  preserved at
  `/private/tmp/phage_uv_preexisting_Rplots_2026-09-07_135131.pdf`; the complete
  test suite did not recreate it.
- An initial direct Quarto render created source-adjacent `*_files` directories
  and `scripts/.gitignore`. They were moved to
  `/private/tmp/phage-uv-quarto-source-artifacts-20260829`. The audit runner now
  renders temporary notebook copies and fails if those artifacts reappear.
- Only the three purposeful HPC launchers are tracked:
  `sbatch_mg_preprocessing.sh`, `sbatch_mt_preprocessing.sh`, and
  `snakemake9_common.sh`.

The complete repeatable command is:

```sh
bash scripts/run_pre_submission_audit.sh
```

## Verified analysis environment

| Component | Version |
| --- | --- |
| R | 4.5.1 |
| edgeR | 4.8.2 |
| limma | 3.66.0 |
| data.table | 1.18.2.1 |
| ggplot2 | 4.0.2 |
| matrixStats | 1.5.0 |
| knitr | 1.51 |
| Quarto | 1.9.37, bundled with RStudio |
| Pandoc used for manuscript build | 3.10 |
| inStrain used for the scoped population-genomic comparison | 1.10.0 |

The canonical full-DE and interpretation output directories contain their own
software-version tables. The inStrain version and exact compare command are
preserved in the staged run log. Upstream workflow provenance is recorded in
`manuscript/upstream_software_provenance.tsv`, with evidence paths and SHA-256
checksums. Verified entries are Bakta 1.12.0 with full database 6.0 dated
2025-02-24, CAT/BAT 6.0.1 with a GTDB-derived database build dated 2023-11-21,
CheckV 1.1.1 with database v1.5, and inStrain 1.10.0.

Exact upstream repository states are separately bound in
`manuscript/upstream_repository_provenance.tsv`. The host-phage workflow is
linked to the clean tracked execution commit
`604db81b73f2550bdea08e5eaa08f35186d21f53` and its completed Snakemake log.
The multiomics execution checkout had retained nine executed but uncommitted
files. That preserved state was reconstructed byte-for-byte on base commit
`46b62b4b1dc12a6251d4fb477d90deb39a4d53d9`, verified against the complete
tracked-diff and two untracked-file SHA-256 checksums, and versioned as commit
`5f7dfe4c42ba65a8188589f437667a61285a5bea`. No unverified branch tip is
substituted for either executed state.

The exact CoverM package version is not recoverable. Its archived Snakemake
metadata retains the exact command, inputs, nine reported metrics, 24 threads,
and software-stack hash, but its environment specification requested unpinned
`coverm` and the resolved runtime prefix was removed before package export. A
currently available CoverM 0.7.0 cache is not linked to that execution and is
therefore not reported as the run version. The CAT/BAT database files preserve
their 2023-11-21 build date but no exact GTDB release tag. These are documented
provenance gaps, not silently imputed versions.

## Quarantine and inference audit

- The manuscript and claim registry contain no result from the subset-first
  SOS, UV, RNA:DNA, temporal-module, or clustering quick checks.
- The population-genomic section remains limited to five coverage-qualified,
  preselected MAGs and makes no mutation, adaptation, accumulation, or causal
  treatment claim.
- The MAG and vOTU diagrams are labelled as taxonomy-derived context rather
  than sequence phylogenies.
- Host-phage links enter only as the Supplementary Figure S8 historical-exposure
  evidence audit. They are not interpreted as active infection, validated host
  range, treatment response, or causal linkage to transcription.
- The manuscript states that RNA counts were not normalized to matched DNA
  abundance and therefore do not isolate per-cell regulation.

## Open items before issue #31 can close

1. Ask the collaborator to confirm the stale checksum row for
   `16s_return_summary.md` and approve the scientific representation of her
   analysis.
2. Decide whether the workflow overview and longitudinal 16S candidate belong
   in the main text or supplement. The current pass does not alter the author's
   live Google Doc.
3. Review the author's tracked Google Docs changes, accept the author changes,
   then introduce the 16S Methods, Results, legends, citations, and claim
   registry updates through the agreed review workflow.
4. Decide whether to retain only descriptive R-squared values or implement a
   defensible repeated-observation sensitivity analysis. The collaborator's
   unrestricted PERMANOVA p-values remain excluded from manuscript inference.
5. Re-run visual inspection and this complete audit after final allocation and
   manuscript conformance.

These open items are provenance gates, not evidence for expanding the
scientific interpretation.
