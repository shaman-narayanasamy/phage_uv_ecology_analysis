# Evidence behind standalone legend clarifications

Baseline live snapshot: `api_review_verification_20260909T185656Z`.
Exact before/after payload: `2026-09-09-legend-clarifications.json`.
No models, figures or selected features were changed by this caption pass.

## Source-dependent corrections

- **Figure 4:** recurrence requires at least five same-direction cells AND
  absolute median cell effect >=1; `R/full_de_interpretation_functions.R`
  defines both. Detection means a non-zero count (`y$counts > 0`) in at least
  six physical samples, not a new CPM threshold. The annotation field must
  be non-missing and non-empty. Candidate ordering is FDR ascending, absolute
  logFC descending, then feature ID, selecting 12 per direction. Counts remain
  361907 -> 7699 -> 7603 -> 7141 -> 6985. Cell effects use log CPM prior 0.5.
- **Figure 5/S5:** differences are divided by `compared_bases_count` and
  multiplied by one million. Pair QC is compared_bases_count >=1000000 and
  inStrain `percent_compared` >=0.50. MAG eligibility requires at least ten
  passing pairs across at least six samples. Missing cluster assignments are
  not automatically demonstrated coverage failures. White matrix diagonals
  are explicit display overlays, not measured zeros; off-diagonal missing
  comparisons are grey. C/P, I/BF and cycle suffixes are defined locally.
- **Clusters:** local archived comparison log confirms inStrain 1.10.0 and
  a completed compare call with database mode and skipped plots. It does not
  record a clustering-threshold override or resolved default values. The
  caption therefore labels the returned assignments without inventing an
  ANI/linkage threshold. Exact default reconstruction remains a Methods
  provenance task, not an excuse to rerun clustering.
- **S6:** inside-out ring order follows `ring_x`; balance equals
  (recurrent_treatment_higher_genes - recurrent_control_higher_genes) divided
  by n_tested_genes. Out-of-range colour values use `scales::squish`.
  The abundance axis uses I/B (not the population panels' I/BF convention).
  The ring's cell-level recurrence includes all tested genes, not only the
  more stringently filtered Figure 4 candidate set; the revised caption states
  this distinction explicitly.
- **Figures 2/S2:** deterministic unsupported-point selections are capped at
  20000 per panel; all supported features remain displayed. No point sampling
  was applied to the inference itself.
- **Figure 3:** MAG eligibility is at least 20 tested genes and median
  detection in at least six samples; 340 eligible sets. Gene-set tests use
  the complete tested background, not the repair/stress subset alone.

## Source hashes at review

| Source | SHA256 |
| --- | --- |
| R/full_de_interpretation_functions.R | a1d368be93fb3bf27e342bd13561c43414b76bca020f40ccce6485026d1095f4 |
| scripts/build_recurrent_gene_candidate.qmd | ffc53fb9430446ef31a81978c411c81a252ba1f10ef0beab55492664448d0c64 |
| scripts/run_full_transcriptome_edger.qmd | db991b0229e76a34928289b106c9fc073b8d781eb7544b072a296c0668928db8 |
| scripts/build_population_genomics_descriptive.qmd | d665a265f03ad5202d34be5a7944389ffbc03af78b24a7c157cfcb514140c7f1 |
| scripts/build_mag_genomic_variation_dossiers.qmd | 00d5bd84498139f2364e7ff41fb28ab0d26f6cbb412003ddf4578f239c37143d |
| scripts/build_taxonomic_context_figures.qmd | c704aebab14e3af7249c67a901289eaf9d3716cd9d51a827c844c8ee048fb67d |
| PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20/compare/all_samples/log/log.log | 3d6aa22d63380605e3688549ca8e67d92b98376f2611aad7b38fc862065ecd0d |

## Verification and remaining formatting scope

Use `tests/test_manuscript_legend_revision.py SNAPSHOT` to require both copies
of every revised caption, exact full-text equivalence to the authorised
replacement set, all 15 image objects/order and original Zotero metadata names.
The test ignores only refreshed signed image-download URLs. It checks Normal
paragraph style but not every character-level style or rendered page break.
The original Figure 5 genus italics were preserved by editing around the
formatted span. The original Figure 2 legend body was already entirely bold;
a native formatting suggestion removed bold from its body while preserving
the bold heading. Readback `20260909T191526Z` verifies that correction and all
156 current checks. The dedicated test verifies all 15 caption pairs and exact
preservation of every other accepted-preview character, 15 stable image objects
and their order, and ten original Zotero metadata names. There are now 262
suggested text runs. No suggestion/comment was accepted or rejected.

The earlier readback `191258Z` passed the dedicated test but failed the old
"unchanged text during S10 replacement" check because text edits were now
intentional. The verifier was updated to require exactly the approved
before/after caption substitutions against the immediate `185656Z` baseline;
it was not changed to ignore other prose differences.

No full-document rendered typography or line-numbering claim follows from
these checks. Companion v3 is preserved with earlier legends; build a new
version using the revised canonical legends. Public deposition, Zotero live
fields, complete Methods provenance and journal formatting remain open.
