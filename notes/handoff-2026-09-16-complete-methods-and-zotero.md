# Methods and Zotero checkpoint, 16 September 2026

## Scope and screen-lock decision

Compaction checkpoint confirmed by user on 16 September. Canonical code checkout: `/Users/shaman.narayanasamy/Work/repositories/phage_uv_ecology_analysis`. Data root: `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569`. Do not resume the historical code checkout under the data directory.

The user authorised completing Methods with Zotero citations. The computer locks automatically. Do not change lock settings or rely on an unlocked desktop for file/API work. Interactive citation insertion can wait; it must not block local drafting or verification.

## Completed

### Final Zotero checkpoint: all 43 Methods references present

After the user completed the pending import wizard, MinCED was verified through
the local API as `2ERHVA7J`, type `computerProgram`, Connor Skennerton and Florent
Angly, source `https://github.com/ctSkennerton/minced`, already in manuscript
collection `NMULZ6FZ`. No duplicate import or collection move was necessary.
Complete library inventory: 1,507 top-level items. New audit:
`PRJEB79569/derived/methods_citation_audit_2026-09-16-v6/`.
All 43 unique citation keys in the current Methods have Zotero matches; zero
missing. MinCED is already cited alongside PILER-CR in the local host-link Methods.
Live Google Docs citation insertion remains NOT done because of the recorded
security block. The previous pending-import statements below are historical.
The earlier UI interpretation was incorrect: the wizard was waiting for Continue,
not a failed import that had returned to the library.

### Follow-up checkpoint: catalogue-aligned Methods and BWA-MEM citation

The vOTU refit follow-up updated the Methods source to 634 eligible vOTUs and 578 retained for abundance testing. The revised local HTML and citation audit are in `PRJEB79569/derived/methods_citation_audit_2026-09-16-v5/`; see `INTEGRATION_STATUS.md` there for exact integration status. BWA-MEM is now imported and API-verified as Zotero key `9BHFAFCZ` in collection `NMULZ6FZ`, bringing Methods coverage to 42/43 cited works. MinCED alone remains missing. A new, separately named verified RIS was prepared at `methods_citation_audit_2026-09-16-v4/minced_verified_import.ris`; the existing audit files were not overwritten. A supported GUI import attempt did not create an item, confirmed by a complete library scan. No live Google Doc edits were attempted; the recorded security-policy block remains. The older checkpoint details below describe the earlier 41/43 state.

- `manuscript/methods_complete_2026-09-16.qmd`: full Methods draft, approximately 3,017 words, 43 citation keys. Covers original-data attribution, processing and coassembly, genome recovery, viral catalogue, mapping/counting, collaborator-returned 16S, community analyses, abundance and full-transcriptome models, the single combined biofilm definition, SOS, randomisation/dependence tests, population genomics, the frozen cleaning score, regression/suppression models, and host links.
- `manuscript/methods_additional.bib`: CheckM, metacoder and edgeR quasi-likelihood references, verified against primary metadata. All 43 keys resolve with this file and `references.bib`.
- `manuscript/methods_limitations_2026-09-16.md`: separate limitations text for later manuscript integration.
- Readable HTML rendered with Pandoc/citeproc at `/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/methods_citation_audit_2026-09-16-v4/methods_review.html`. No unresolved-citation warning. This is a local review copy, not live Zotero fields.
- Eleven missing references imported through Zotero's supported Add by Identifier UI into collection `NMULZ6FZ` (Phage UV ecology manuscript), user `5080709`. Imports verified through the read-only local API. Full library increased from 1,494 to 1,505 top-level items.
- Complete post-import audit: `PRJEB79569/derived/methods_citation_audit_2026-09-16-v4/methods_reference_audit.{json,tsv}`. Of 43 Methods citations, 41 now match existing Zotero items; BWA-MEM and MinCED remain missing from Zotero but have bibliography entries in the draft.
- `git diff --check` passed. Nothing committed or pushed; preserve all unrelated dirty changes.

## Audit caveats and remaining work

1. Audit v1 is invalid for library presence: local API text queries did not reliably constrain results. Use v4, which paginated the entire library and checked exact DOI, title or source URL. V2/v3 were pre-import snapshots. The broader audit contains 46 references, of which three are absent; Wu2012 is not cited by this Methods draft, so it is not a Methods gap.
2. Add BWA-MEM preprint (arXiv 1303.3997) and MinCED software source through a supported Zotero workflow. The batch `arXiv:1303.3997` input did not produce a matching item. Do not claim it imported. Do not write Zotero's database or forge citation fields.
3. Existing duplicate matches for Myshkevych2025 and Scarascia2021 were not merged/deleted. Prefer curated collection keys `5CHFZ3U4` and `WR8BS6SY` respectively. Other existing matches can reside elsewhere in the library.
4. Live Google Doc has NOT received this complete Methods draft. Earlier Browser Use explicitly blocked that page by security policy. Do not route around that block with another browser/API/computer-use surface. Screen unlocking does not clear it. Canonical review document ID: `1tl6VL6Z1bYcTDuG67CHY4mOdkWuEIvzWOhBMqKneQbQ`.
5. Final supported Zotero insertion/refresh and visual verification in the live manuscript remain pending. Preserve the user's tracked edits and assistant identity conventions.

## vOTU eligibility finding

Read-only audit code: `analysis/votu_catalogue_scope_audit.qmd`.
Outputs: `PRJEB79569/derived/votu_catalogue_scope_audit_2026-09-16-v1/`.

The current taxonomic catalogue has 634 high-quality viral-gene-containing representatives. Archived abundance modelling admitted 616 with Cenote-Taker records and retained 560 after count filtering. The 18 excluded catalogue members all lack Cenote-Taker records; they were not excluded by the abundance count filter. They account for 1.058528–6.113578% of viral mapped reads across samples. Methods records the actual analysed scope. A catalogue-aligned abundance-model refit is still pending; do not silently change reported counts or results.

## Frozen modelling decisions retained

Cleaning score is 0.5 times the pooled z-score of the mean Initial/(Initial+Backflush) ratios for cells, polysaccharides and proteins, plus 0.5 times the pooled z-score of exact reported TMP regrowth lag. The three removal readouts equally share the first half; individual ratios are not separately z-scored. Pool across six condition-cycle observations; do not restandardise by model or condition.

Retain condition-plus-predictor and cycle-adjusted models, separate DNA abundance and RNA activity predictors, full-transcriptome testing before gene-set subsetting, one combined biofilm list, and separate SOS/population-diversity analyses. Suppression is a model projection with other predictors fixed, not a re-estimated community composition.

## Restart order and wider manuscript context

1. Read this checkpoint, inspect the current worktree, and finish the two missing Zotero items if supported access is available. Avoid duplicate imports; local API is read-only. Use the KB Zotero SOP after its mandatory retrieval preflight.
2. Integrate the local Methods only when permitted document access is restored; preserve author edits and use the agreed assistant identity/suggestion protocol. Do not mistake a local HTML/bibliography for live linked Zotero citations.
3. Resolve the catalogue-aligned vOTU abundance-model refit and inspect any effects on figures, captions and text before replacing existing results.
4. Resume the manuscript review from the durable community and figure handoffs, not old conversation numbering. Relevant pointers: `notes/handoff-2026-09-15-community-cross-omics.md`, `notes/handoff-2026-09-15-figure7-table1.md`, and `notes/handoff-2026-09-15-figures-only-google-doc-v3.md`.

No new analysis launched for compaction. This checkpoint does not assert that the manuscript is submission-ready. User title remains: "Genome-resolved integrated-omics reveals biofilm-associated responses to hybrid, mechanical, phage and UV-C biocontrol". Keep Treatment/Control labels, the agreed colour mappings, and limitations in their dedicated section. Supplementary Figure 1 is reserved for the original experimental design; main workflow depicts this reanalysis, not ownership of the source experiment.

## Suggested skills

- `mattpocock-skills:edit-article` for manuscript prose, subordinate to the author's scientific voice and explicit writing decisions.
- `computer-use:computer-use` only for supported Zotero UI steps when accessible, not to bypass a blocked Google Doc.
- `browser:control-in-app-browser` for permitted document interaction only; read its instructions and respect the recorded page block.
- `mattpocock-skills:handoff` when updating this continuation checkpoint.
