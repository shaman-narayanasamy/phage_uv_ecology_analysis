# Pre-submission reproducibility audit

Audit date: 2026-08-30

Status: complete for the current pre-16S manuscript; final issue #31 remains
open until the collaborator-owned 16S decision in issue #30 is resolved.

## Verified current state

- All 10 repository R tests pass, including the synthetic full-transcriptome
  edgeR run and checksum validation of the complete manuscript figure suite.
- `scripts/validate_manifests.sh` passes every metadata, 16S input-contract,
  Quarto-entrypoint, citation, manuscript-structure, data-path, and HPC Conda
  policy check.
- All 20 canonical `scripts/*.qmd` notebooks structure-render to HTML with
  execution disabled under the RStudio-bundled Quarto 1.9.37.
- The manuscript builds to DOCX with Pandoc 3.10 and the canonical BibTeX file.
- The 13 candidate PDFs remain byte-identical to the checksums recorded during
  the complete visual audit in `docs/figure_visual_qa_2026-08-29.md`. The later
  manuscript edit did not modify the figure files.
- The repository has no uncommitted, untracked, or ignored generated artifacts.
  One ignored root-level `Rplots.pdf` found at audit start was moved to
  `/private/tmp/phage_uv_Rplots_pre_issue31.pdf`; the complete test suite did not
  recreate it.
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
preserved in the staged run log.

## Quarantine and inference audit

- The manuscript and claim registry contain no result from the subset-first
  SOS, UV, RNA:DNA, temporal-module, or clustering quick checks.
- The population-genomic section remains limited to five coverage-qualified,
  preselected MAGs and makes no mutation, adaptation, accumulation, or causal
  treatment claim.
- The MAG and vOTU diagrams are labelled as taxonomy-derived context rather
  than sequence phylogenies.
- Host-phage links remain excluded because they do not currently clarify a
  supported global result.
- The manuscript states that RNA counts were not normalized to matched DNA
  abundance and therefore do not isolate per-cell regulation.

## Open items before issue #31 can close

1. Receive and decide on the collaborator-owned 16S package under issue #30.
   If included, register its exact software, database, classifier, parameters,
   source tables, checksums, figure, and claims, then rerun this full audit.
2. Recover or explicitly mark as unavailable the exact upstream versions for
   CoverM, Bakta, CAT/BAT, GTDB release, and CheckV. Their source artifacts and
   authoritative citations are verified, but the locally staged files do not
   currently expose every executed upstream version. The manuscript must not
   claim that all upstream versions are versioned until this is resolved.
3. Re-run visual inspection only if any figure changes after 16S integration or
   journal conformance.

These open items are provenance gates, not evidence for expanding the
scientific interpretation.
