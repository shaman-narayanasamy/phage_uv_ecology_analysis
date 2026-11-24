# Manuscript figure plan

## Current live review update, 2026-09-15 afternoon

This supersedes the historical allocations below. The v3 Doc now contains author-written Abstract and Introduction, not figures only. Preserve concurrent edits.

- Figure 1: A-D community context, full-width radial host network. Source `analysis/figure1_fullwidth_network.qmd`; data output `figure1_fullwidth_network_2026-09-15-v3`. Former abundance trajectories are a separate supplementary candidate, not E-J in the current main figure.
- Figure 2: functional v8, `figure2_functional_2026-09-15-v8`.
- Figure 3: cleaning candidates v4, `figure3_cleaning_candidates_2026-09-15-v4`.
- Figure 4: population genomics v2, `figure4_population_2026-09-15-v2`, five MAGs and 139 pairs, not the historical recurrent-gene figure.
- S1 remains reserved for experimental design/workflow.

All four images are present in the accepted-suggestions preview of the live v3 Doc, verified in data `figures_v3_author_review_2026-09-15/figures1234_verified/`. Replacements/additions are Codex Assistant suggestions, not accepted on the author's behalf. The original Figure1 carried an author deletion suggestion: the new Figure1 is inserted independently before its caption so accepting that deletion does not remove the new artwork. Figure1 is fitted proportionally to 22.5cm height for the review page; full-resolution vector original remains in the data output.

Standing author rule: consolidate caveats in one Limitations section. Do not repeat defensive disclaimers in Results, captions, Abstract or Discussion. Keep Methods reproducible and claims accurate without repeatedly rebutting claims the author has not made. A dedicated Limitations draft is now suggested in the live Doc. Figures and captions remain review drafts; no claims of final journal layout or completed Zotero fields.

## Current review allocation, 2026-09-15

Figure1: community context plus selected abundance trajectories (print v4).
Figure2: biofilm/SOS expression and concentration (functional v6).
Figure3: phenotype components, locked cleaning score, MAG models and candidate
phage-link context (cleaning candidates v3). This renumbers the earlier proposed
Figure4; the older allocation below is historical. Figure3 is a review candidate.
S1 remains experimental design/workflow. New v3 Google Doc is figures and captions
ONLY, separately from existing manuscript; user explicitly authorized its creation.
Treatment/Control labels throughout, per terminology decision. No model refits.

Print-readability trial, 2026-09-15: `figure1_print_proof_2026-09-15-v3` is a
nominal180x250mm six-panel candidate with7pt text and selective main tree/network
labels. All nodes, edges and observations remain. Full taxonomic key moves to S3
candidate; full labels remain in frozen source figures/tables. No approval implied.
S1 is still reserved for design/workflow; S2 remains the full test overview.

## Current expansion, author-directed 2026-09-14

- Figure1 candidate A-D uses the frozen shared-taxonomy vector artwork unchanged;
  E adds two MAG trajectories and F adds four vOTU trajectories (all features
  passing archived main-condition OR joint-interaction BH q<0.05). No refits.
- Candidate package: `derived/figure1_expanded_2026-09-14-v2/`.
  Builder: `analysis/figure1_expanded_response.qmd`. Final layout awaits review.
- Supplementary Figure1 is RESERVED for experimental design AND workflow.
- Supplementary Figure2: full community differential-abundance overview, with
  complete archived result tables. This supersedes older numbering proposals.
- Standalone community-response Figure2 is absorbed into this allocation.
  Next main figure is biofilm/SOS context; remaining renumbering awaits review.
- Frozen four-panel baseline remains intact. No Google Doc edits made.

Figure 1 frozen by author on 2026-09-14: data package
`derived/figure1_shared_taxonomy_2026-09-14-v3/`. A-D layout and unified mixed-rank
taxonomy encoding accepted. Do not revise without author direction; earlier
provisional Figure1 wording below is superseded. Google Doc not changed.

## Author-approved reorganization, 2026-09-14

This allocation supersedes the older allocation text below; existing outputs
and live manuscript have NOT yet been replaced or renumbered.

- Figure 1: community context. Preserve the approved circular MAG heat tree/QC
  rings, original non-circular phage heat tree, and prokaryotic stacked relative
  abundance panel. ADD a compact community-wide phage-host link network panel.
  Current tree/layout source is analysis/figure1_community_preview.qmd, not the
  older scripts/build_community_figure_one.qmd. Use existing verified exact-ID
  CRISPR/SpacePHARER edges, not genus-inferred or therapeutic interaction claims.
  Keep the complete network audit and quality detail supplementary. Do not
  replace the community network with the seven shortlisted candidate links.
  Provisional four-panel allocation A MAG tree, B phage tree, C prokaryotic
  stacks, D host-link network; lettering/layout can change after preview.
- Figure 2: PROVISIONAL, author unconvinced but authorized a visual trial.
  Community response across repeated cleaning: microbial/phage trajectories
  and differential abundance, distinguishing condition and cycle effects.
  Avoid repeating Figure 1 composition bars or filling space with ordinations.
  Evaluate its narrative value from the preview before locking allocation.
- Figure 3: biofilm/SOS responses in MAG context, including up/down contributors
  and concentration evidence. Combined3905 is the sole active biofilm list.
- Figure 4: cleaning readouts and standardized composite, condition-adjusted
  versus cycle-adjusted associations, and ecological candidate shortlist.
  End at iterative treatment optimization; isolation/validation is future work.
  Retain negative model slopes as suppression-direction evidence, uncertainty
  and raw/adjusted p-values. No BH-significant associations claimed.
- Supplement: complete models/gene provenance, full host network evidence audit,
  separate genomic heterogeneity dataset, additional composition/ordination/16S
  detail. Workflow subway diagram placement remains provisional.

Preserve all current figure versions. No live Google Doc edits authorized by
this allocation decision. Main Figure 1 moves a network view out of the purely
supplementary allocation, not all network QC panels. Captions must call edges
predicted CRISPR-based host associations rather than demonstrated infections.

## Historical allocation and delivery records

Status: author-directed allocation revised on 2026-09-01. Figure 1 describes
the microbial and phage communities. Supplementary Figure S8 contains the
host-phage evidence audit and S9 contains detailed community-abundance tests.
Artifact filenames remain unnumbered so the allocation can be revised without
breaking provenance.

The current main-text and supplementary candidates have been reviewed together.
Every candidate and supplementary figure must use
`R/figure_style.R` and the fixed visual mappings in `docs/figure_visual_grammar.md`.

## Current author-directed manuscript allocation

### Author's delivery checklist (queued 2026-09-09)

- [ ] Zotero-managed citations and bibliography: verify library metadata,
  de-duplicate by DOI, and verify live fields and bibliography after refresh.
  A static bibliography or import payload alone does not complete this task.
- [ ] Review line numbers: verify visible numbering in the review export,
  including page transitions. A checked control alone is not verification.
- [ ] Publication-quality figures: retain vector masters, embedded fonts,
  readable labels at final dimensions and high-resolution document previews;
  render and inspect every main and supplementary figure. Figures 1-5 and
  supplementary S1-S10 pass the current provisional 180 mm size screen and
  have verified live previews (latest readback 184447Z, 156 checks).
  All 15 caption pairs received source-checked standalone clarifications;
  live readback 191526Z and exact text/image-preservation test pass.
  Journal-specific dimensions and full rendered typography remain open.
- [ ] Separate supplementary/extended report: maintain a versioned companion
  with its own legends, source-data inventory and cross-references. The existing
  v2/v3 companions are preserved; v4 includes all current supplementary masters
  and the revised canonical legends. Its 14 pages and six uploaded files are
  verified in Drive folder `1hTwcD70qWQG18oDYQLzmTMljsXhb5HlT`. Adapt naming/
  format after journal choice; do not call it a final journal-compliant
  submission yet. Package the two new denominator-audit TSVs with the next
  planned companion update, not by overwriting the verified v4 archive.

These are delivery requirements, not grounds to pause other manuscript work.

The working draft uses the following labels so that every quantitative claim has
an explicit destination. These labels can change during author review without
renaming the canonical artifacts.

1. Figure 1: `community-structure-figure-one.pdf`.
2. Figure 2: `global-transcriptome-structure.pdf`.
3. Figure 3: `functional-organism-restructuring.pdf`.
4. Figure 4: `recurrent-gene-structure.pdf`.
5. Figure 5: `population-genomic-heterogeneity.pdf`.
6. Supplementary Figures S1-S5: model diagnostics, cycle interactions, all
   functional coefficients, all MAG coefficients, and all five population-genomic
   pairwise landscapes, respectively.
7. Supplementary Figure S6: `mag-taxonomic-context.pdf`.
8. Supplementary Figure S7: `votu-taxonomic-context.pdf`.
9. Supplementary Figure S8: `host-phage-network-evidence-audit.pdf`.
10. Supplementary Figure S9: `community-differential-abundance.pdf`.
11. Supplementary Figure S10: `16s-longitudinal-community-context.pdf`.

The 2026-09-09 figure-consistency revisions are listed below. Earlier pending
companion notes in this chronological record are superseded by the verified
v3 release. S10's current master is now in
`derived/16s_figure_publication_2026-09-09-v2/`, 180 x 265 mm; its eight source
tables are unchanged and the live replacement is verified at 184447Z.

- Figure 1: `derived/community_figure_publication_2026-09-09-v4/figures/community-structure-figure-one.pdf`.
  Native 180 x 200 mm, embedded fonts and minimum 6.5 pt text; same source
  values and statistics, no baked title/caption. Its preview and both updated
  captions are verified native suggestions in live v2 at `20260909T161333Z`.
  Other 14 images remain unchanged. See `docs/figure_publication_size_audit.md`
  for remaining final-size revisions; previous native-size QA is insufficient.
- Figures 2 and 3: `derived/manuscript_figures_publication_2026-09-09-v2/figures/`.
  Native 180 x 100 mm and 180 x 195 mm; embedded fonts, minimum 6.5 pt text,
  dark MDS cycle labels and an unclipped SOS FDR label. Four source panels are
  byte-identical; MDS was reused without recomputation. Both previews are
  verified native suggestions at `20260909T162818Z`; captions and complete
  manuscript prose are unchanged. Other 13 images remain unchanged.
- Figure 4: `derived/recurrence_figure_publication_2026-09-09-v2/figures/recurrent-gene-structure.pdf`.
  Native 180 x 200 mm, embedded fonts, minimum 6.5 pt text and a vector colour
  scale. Upper panels are isolated from the heatmap's long label column to
  prevent misalignment. All four frozen tables match byte-for-byte; selections
  and values are unchanged. Native suggested replacement verified at
  `20260909T164651Z`; all manuscript text and the other 14 images are unchanged.
- Figure 5: `derived/population_figure_publication_2026-09-09-v2/figures/population-genomic-heterogeneity.pdf`.
  Native 180 x 225 mm, embedded fonts and minimum 6.5 pt text. Three vertically
  arranged panels retain the five-MAG cluster grid, distance ranges and focal
  pairwise matrix. All three frozen source tables are byte-identical. Native
  suggested replacement verified at `20260909T171509Z`; complete prose,
  captions and all other 14 images remain unchanged. The next legend audit
  should explicitly define C/P, I/BF, cluster identifiers and grey matrix cells.
- S1-S5: `derived/supplementary_figures_publication_2026-09-09-v2/figures/`.
  New native 180 mm vector masters with minimum 6.5 pt text and embedded fonts.
  Heights are 165, 175, 240, 170 and 245 mm. All five frozen source tables are
  copied byte-for-byte; nine inputs are hash-recorded. Every displayed
  interaction point's ID and values match deterministic selection from the
  original result tables. All five rendered layouts have been inspected.
  Native suggested replacements are verified at `20260909T180753Z`: correct
  sources/crops/aspects, unchanged text/captions, all 15 image IDs/order and ten
  non-target images preserved. These masters are now included in the verified
  companion v4 with complete revised captions. Preserve earlier versions.
  S5's colour-key wording still needs alignment from "callable" to "compared"
  Mbp; its values and selected set are independently denominator-verified.
- S6/S7: `derived/taxonomic_figures_publication_2026-09-09-v3/figures/`.
  Native 180 x 250/230 mm, embedded fonts and minimum 6.5 pt ordinary text.
  S6 retains the stacked tree/profile with Figure 1's identical top-25 values
  and microshades key. S7 keeps all 45 groups and the same 18 selected labels,
  now horizontal. Eight source tables and two Newick trees are byte-identical.
  Native suggested replacements verified at `20260909T182253Z`: all prose,
  captions, image IDs/order and 13 non-target images preserved. No new allocation.
- S10: `derived/16s_figure_top25_revision_2026-09-09/figures/16s-longitudinal-community-context.pdf`.
  Top25 families recomputed from all ASV counts and SILVA taxonomy, with complete
  denominator, separate classified/unclassified remainders, and shared named-family
  colours matching Figure 1/S6. The full-depth collaborator rerun remains optional
  future work, not a reason to withhold this explicitly subsampled descriptive view.
- S8: `derived/network_figure_publication_2026-09-09-v2/figures/host-phage-network-evidence-audit.pdf`.
  Native 180 x 260 mm with the network above stacked host/viral summaries;
  four frozen tables unchanged. Embedded fonts, minimum 6.5 pt ordinary text.
- S9: `derived/abundance_figure_publication_2026-09-09-v2/figures/community-differential-abundance.pdf`.
  Native 180 x 180 mm, dark repelled cycle labels and readable keys. Nine frozen
  tables unchanged; no model/ordination refit. S8/S9 native replacements are
  verified at `20260909T183356Z`, preserving text/captions and 13 other images.
- Family colours: `metadata/manuscript_family_colours.tsv`; no taxonomic synonym
  merging or MAG/ASV equivalence is implied by the shared display colours.

The former 15-family S6 and 12-family 16S PDFs are preserved as superseded
versions, not current manuscript previews. Live insertion status is recorded in
the Google Docs handoff and data manifest.

S9 revision on 2026-09-09 is in
`derived/community_differential_abundance_figure_revision_2026-09-09-v2/`.
Use this direction-coloured version: the isolated control-higher MAG is green,
not a purple generic significance highlight. The nine source tables are copied
byte-for-byte from the canonical analysis; `--figure-only` verifies their
checksums and does not refit models. V2 removes the baked-in overall title and
internal caption; the full external legend carries their context. Both earlier
PDFs remain preserved. The live Google Doc now contains the title-free
direction-coloured preview: readback `20260909T134519Z` verifies its source,
uncropped aspect ratio and caption pairing. The companion report uses the same
v2 vector master.

The independently delegated 16S result has returned and passed the canonical
12-sample contract. Its longitudinal and workflow candidates are now available
for review; the descriptive 16S panel is provisionally allocated as S10 while
the author's Figure 1 community-first decision is retained.

## Current candidate set

1. Experimental system and microbial and phage community structure:
   - one membrane per condition across three cycles and two phases;
   - aligned top-25 family profiles from MAG-mapped metagenomic reads;
   - high-level vOTU realm profiles across the same observations;
   - microbial and vOTU Bray-Curtis ordinations with exhaustive paired-label
     tests and explicit exploratory-design boundaries.
2. Global transcriptome structure:
   - filtered-expression geometry across all 12 physical samples;
   - complete-universe adjusted-condition effect landscape.
3. Functional and organism-resolved restructuring:
   - competitive tests for all eight frozen functional categories;
   - supported MAGs in both expression directions;
   - the strongest organism-level effects with taxonomic context.

   Revision on 2026-09-09: use the three-panel functional/organism artifact,
   not the four-panel `transcriptome-response-architecture.pdf` candidate.
   The latter repeats the adjusted-condition landscape already in Figure 2.
   Both artifacts remain preserved; this is an editorial allocation change.
4. Six-cell recurrent gene differences:
   - built as `recurrent-gene-structure.pdf` and visually checked;
   - sequential provenance from 361,907 tested features to 6,985 recurrent
     predeclared candidates;
   - balanced phage-UV-higher and control-higher recurrence with five-of-six
     versus six-of-six cell concordance visible;
   - 12 genes per direction selected deterministically by condition FDR, then
     absolute condition log2 fold-change, for a legible six-cell heatmap.
5. Descriptive population-genomic heterogeneity:
   - built as `population-genomic-heterogeneity.pdf` and visually checked;
   - strain membership across five coverage-qualified MAGs;
   - median and range of pairwise consensus differences per callable Mbp;
   - a focused *Propionicimonas* pairwise landscape;
   - coverage-qualified structure for the five scoped MAGs;
   - no damage, mutagenesis, adaptation, accumulation, or treatment-effect inference.
6. Delegated 16S community structure:
   - 12 samples and 2,700 ASVs assigned with SILVA 138.2;
   - aligned family composition, Bray-Curtis trajectories, alpha diversity,
     and consecutive-cycle turnover are available as a visually verified
     vector candidate;
   - all four membrane-by-phase trajectories show lower C2-to-C3 than C1-to-C2
     Bray-Curtis turnover, a descriptive recurrence with no formal time-series
     or treatment-effect inference;
   - the collaborator's unrestricted PERMANOVA p-values are not
     manuscript-ready for the repeated two-membrane design.

## Returned 16S and complete-study overview candidates

1. `16s-longitudinal-community-context.pdf`:
   - top-25 family composition in aligned stacked bars (2026-09-09 version);
   - directed Bray-Curtis PCoA trajectories across cycles;
   - observed-ASV and Shannon-diversity trajectories;
   - exact consecutive-cycle Bray-Curtis turnover derived from the unrarefied
     ASV table;
   - shared family labels retain the fixed manuscript colour mapping.
2. `study-analysis-workflow.pdf`:
   - connects the two-membrane, three-cycle sampling design to 16S,
     metagenomic, and metatranscriptomic data layers;
   - records the DADA2/SILVA, MAG/vOTU, full-universe edgeR,
     population-genomic, and CRISPR-link branches;
   - displays the one-membrane-per-condition inference boundary directly.

The 16S candidate remains under `PRJEB79569/derived/16s_manuscript_integration/`.
The author provisionally accepted the connected subway workflow on 2026-09-07:
`PRJEB79569/derived/workflow_metro_v10/study-analysis-workflow.pdf` supersedes
the earlier overview. It is incorporated into the local accepted-figure
inventory with a complete legend in `manuscript/figure_legends.md`.
Its final number and placement remain unassigned; the author's decision that
Figure 1 describes the community is unchanged. Google Doc insertion remains
pending review of the author's tracked edits. The 16S longitudinal figure can
refine the community opening or become supplementary after author review.

## Preserved earlier layouts

Author-review update, 2026-09-09: the transcriptome figure's redundant
sample-design panel has been removed in the canonical Quarto source. The new
`PRJEB79569/derived/manuscript_figure_revision_2026-09-09/figures/global-transcriptome-structure.pdf`
contains MDS (A) and the adjusted-condition landscape (B) side by side. It was
visually checked; MDS coordinates and the numerical summary are byte-identical
to the prior build. Old outputs remain untouched. This is the Figure 2
replacement awaiting insertion into the live Google Doc, not an additional
figure. The legacy figure registry below describes preserved versions.

The v11 subway restyle remains a separate agent's live SVG draft, not an
accepted replacement for v10. Follow
`notes/handoff-2026-09-09-metro-v11-svg-draft.md` before editing that figure.

1. `global-transcriptome-structure.pdf` and
   `functional-organism-restructuring.pdf` remain checksum-governed as the
   analysis-led v1 layouts. Their panels have been recomposed into Figures 1
   and 2 above; they are retained for provenance, not proposed as additional
   manuscript figures.

## Supplementary taxonomic context

1. `mag-taxonomic-context.pdf`:
   - taxonomy-derived circular dendrogram for all 348 dereplicated MAGs;
   - concentric rings ordered from the tree outwards as completeness,
     contamination, current adjusted-membrane coherence, and recurrent-gene
     balance;
   - accompanying legacy 12-sample family-level relative-abundance profile from
     MAG-mapped metagenomic reads; the clearer top-25 microshades version is now
     displayed prominently in Figure 1;
   - control above phage-UV with the six cycle-phase positions aligned on a
     shared horizontal axis;
   - descriptive taxonomic context, not a marker-gene or genome sequence
     phylogeny.
2. `votu-taxonomic-context.pdf`:
   - taxonomy-derived cladogram of 607 deduplicated high-quality vOTUs grouped
     into 45 current taxonomy paths;
   - accompanying realm-level catalogue composition;
   - descriptive catalogue context only, with no treatment-response or
     host-phage inference.

These supplementary candidates restore the useful descriptive tree concepts from the
original poster without importing its superseded expression overlays. Their
descriptive status is explicit: neither tree is a sequence phylogeny, and the
viral panel carries no treatment-response or host-phage inference.

## Integrated taxonomic layout comparison

Four review candidates combine catalogue structure with longitudinal
composition without replacing the working manuscript figures:

1. `mag-taxonomy-family-bars.pdf` and `mag-taxonomy-family-area.pdf` pair the
   348-MAG taxonomy-derived dendrogram and quality/interpretation rings with the
   aligned top-25 family profile.
2. `votu-taxonomy-realm-bars.pdf` and `votu-taxonomy-realm-area.pdf` pair the
   607-vOTU taxonomy-derived cladogram with a genuine 12-sample metagenomic
   read profile summarized at realm level.

The stacked-bar versions are recommended. The six cycle-phase positions are
discrete observations, and bars preserve that sampling structure. Stacked areas
connect the observations with straight segments, which makes trajectories look
continuous and turns the 25-family MAG profile into difficult-to-follow ribbons.
At viral realm level, Duplodnaviria contributes 93.3-97.1% of mapped reads in
every sample. That dominance is an informative high-level catalogue result, but
it leaves little longitudinal taxonomic restructuring to display. The viral
panel is therefore supplementary context unless a more resolved, prespecified
viral question earns a main-text role.

## Host-phage network allocation

`host-phage-network-evidence-audit.pdf` restores the interaction layer visible
in the original poster without reusing its quarantined subset-first expression
filter. It contains 86 deduplicated SpacePHARER host-phage candidate pairs
linking 80 MAGs to 85 phage contigs. The host overlay uses only the current
complete-transcriptome adjusted membrane coefficient. The accompanying audit
shows that 12 linked phage representatives have current catalogue annotation
and none passes the manuscript's high-quality classified-vOTU filter.

This is allocated as Supplementary Figure S8. The links are compatible with
historical CRISPR exposure, but do not demonstrate active infection, treatment
response, host range, adsorption through biofilm, or causal connection to the
MAG transcriptional coefficient.

## Current supplementary set

1. `supplementary-model-diagnostics.pdf`:
   - feature filtering, retained and effective library sizes, and model-dispersion
     summaries.
2. `supplementary-cycle-interaction-landscape.pdf`:
   - complete-universe cycle-2, cycle-3, and interaction-omnibus feature landscapes;
   - interaction coefficients are departures from cycle 1, not standalone cycle
     treatment effects.
3. `supplementary-functional-coefficients.pdf`:
   - all eight frozen repair and stress categories across all four predeclared
     coefficient families.
4. `supplementary-mag-coherence.pdf`:
   - supported MAG counts and MAG-level coherence across the three directional
     coefficients.
5. `supplementary-population-genomics.pdf`:
   - complete coverage-qualified pairwise landscapes for all five scoped MAGs.
6. `community-differential-abundance.pdf`:
   - poster-style and design-aware MAG and vOTU abundance comparisons;
   - matched CLR and exhaustive paired-label sensitivity tests;
   - allocated as Supplementary Figure S9 because no robust community-wide or
     feature-level pattern survives the full sensitivity analysis.

The six-cell recurrence figure already contains its selection provenance,
direction-concordance counts, and a balanced gene catalogue, so no redundant
supplementary recurrence panel is created.

## Excluded figure sources

Subset-first SOS, UV-response, DNA-repair, RNA:DNA, temporal-module, and
module-clustering figures remain quarantined. The retired broad inStrain comparison
cannot be revived as manuscript evidence. Inferential candidates may use only
full-universe expression outputs and the separately governed descriptive
population-genomics outputs. Current quality and taxonomy catalogues may feed
clearly labelled descriptive context figures without becoming treatment evidence.
