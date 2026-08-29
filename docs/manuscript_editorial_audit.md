# Manuscript editorial audit

Audit date: 2026-08-29

## Editorial outcome

The venue-neutral manuscript now presents one continuous evidence-led argument:

1. repeated phage-UV cleaning retained engineering value while its performance
   changed over cycles;
2. MAG-mapped community composition varied across the longitudinal samples;
3. cleaning cycle, rather than membrane, dominated the global RNA geometry;
4. the adjusted membrane coefficient was broad but nearly balanced in
   direction;
5. functional support was narrow, whereas organism-level and recurrent-gene
   structure was widespread and bidirectional;
6. population-genomic variation was organism-specific and descriptive; and
7. the experimental design supports a system-specific longitudinal account,
   not causal treatment, DNA-damage, mutation, or adaptation claims.

All current main analyses have a defined narrative role. The vOTU and MAG
catalogue trees are taxonomic context, not sequence phylogenies. Host-phage
links remain deferred because they do not yet clarify a supported result. The
collaborator-owned 16S analysis retains one conditional insertion point rather
than holding the current narrative open.

## Section audit

| Section | Editorial function | Status |
| --- | --- | --- |
| Title | Names the longitudinal intervention, system, scale, and dominant result without asserting causality | Ready for author review |
| Abstract | Moves from engineering problem to community context, global geometry, quantitative transcriptome result, organism resolution, and design boundary | Ready for author review |
| Introduction | Establishes the ecological scale problem created by selected-gene interpretation and states the three connected questions | Ready for author review |
| Methods | Preserves exact experimental units, preprocessing, models, thresholds, provenance, and inferential limits | Ready for technical review |
| Results | Cites Figures 1-4 and Supplementary Figures S1-S7 in first-appearance order; reports positive and negative results | Ready for author review |
| Discussion | Interprets scale and heterogeneity, separates RNA structure from per-cell regulation, and states the experimental-unit limit | Ready for author review |
| Declarations | Explicit placeholders remain for author contributions, funding, and competing interests | Requires author input before submission |

## Quantitative and terminology controls

- The abstract is 222 words.
- The Introduction is 249 words, Results 924 words, and Discussion 548 words.
- Exact values remain synchronized with the claim registry and canonical result
  tables through `tests/test_manuscript_registry.R`.
- Bibliography and in-text citation synchronization are enforced by
  `tests/test_references.R`.
- Structural, length, figure-order, terminology, and overclaiming checks are
  enforced by `tests/test_manuscript_structure.R`.
- `phage-UV` is used for the membrane/intervention label, `UV-C` for the
  irradiation modality, and `membrane` rather than `treatment` for the fitted
  system-specific contrast in interpretive prose.
- The manuscript contains no em dashes, no claim of independent treatment
  replication, and no assertion of a treatment-induced DNA-damage, mutation,
  or adaptation mechanism.

## Remaining author-review decisions

- Confirm or revise the working title.
- Supply declarations and the final author list.
- Decide whether the returned 16S result materially improves the argument under
  issue #30. It should be omitted if it is redundant or uninformative.
- Approve the prose locally before any live Google Docs replacement. Once the
  user supplies revised or accepted prose, subsequent agent changes belong in
  Suggesting mode.
