# Subway diagram update: complete vOTU catalogue and CRISPR host links

## Purpose

Update the analytical subway diagram with the final catalogue-aligned vOTU
analysis and make the CRISPR host-link branch explicit. This is a content handoff
for the diagram owner; it does not approve a new visual version or overwrite the
existing SVG.

Current visual sources and history remain documented in
`notes/handoff-2026-09-09-metro-v11-svg-draft.md`. Workflow provenance remains in
`docs/workflow_repository_audit.md`. Use those rather than reconstructing the
pipeline from manuscript prose.

## Author decisions that remain binding

- Main Figure 1 shows the integrated-omics **analytical journey only**.
- Supplementary Figure 1 contains the original experimental design and wet-lab
  setup, so the reanalysis does not visually claim the original authors' work.
- Keep one connected Nextflow-style subway journey. Do not split the omics into
  disconnected mini-workflows.
- Use `Treatment` and `Control`, never `Phage-UV`, in new labels.
- Preserve the established omics colours and the editable SVG/versioning model.

## Required semantic changes

### Viral catalogue branch

Depict viral discovery and catalogue construction as:

`assemblies -> viral discovery -> Vclust clustering/representatives -> CheckV quality -> 634 vOTUs`

- The catalogue denominator is **634 CheckV high-quality representatives with at
  least one viral gene**.
- Cenote-Taker supplies viral gene/taxonomic annotation. It is **not an eligibility
  gate** and must not sit in series between CheckV and the 634-vOTU catalogue.
  Draw it as an annotation branch or parallel station returning metadata.
- Metagenomic reads map back to the unified MAG/vOTU reference. The unchanged
  abundance filter, at least 10 counts in at least 3 samples, retains **578/634
  vOTUs** for modelling.
- Statistical output may be a compact terminal annotation: **0 overall treatment
  effects; 4 treatment-by-cycle interactions (FDR < 0.05)**. Do not add all vOTU
  identifiers to the subway figure.

Validated evidence: `notes/handoff-2026-09-16-votu-catalogue-refit.md` and data-root
outputs `derived/community_cycle_models_catalogue_aligned_2026-09-16-v1/` plus
`derived/votu_catalogue_refit_comparison_2026-09-16-v1/`. All 18 vOTUs omitted by
the archived Cenote-linked eligibility pass the count filter; the same four
interaction hits remain. The archived 616/560 run is historical, not the figure's
current count.

### Host-link branch

Depict the executed host-link route as:

`dereplicated MAG FASTAs -> PILER-CR + MinCED -> SpacePHARER against vOTU database -> candidate MAG-vOTU links`

- PILER-CR and MinCED identify CRISPR arrays/spacers in host MAGs.
- Both outputs are supplied jointly to SpacePHARER. MinCED is not part of viral
  abundance estimation, differential abundance or gene-expression analysis.
- Label the output as **candidate CRISPR-supported host links**, not validated
  host range or therapeutic phages.
- Current integrated network scope is 86 deduplicated MAG-vOTU pairs; retain only
  if the count fits without crowding. The route itself is more important.

Executed-rule provenance is in the separate `host_phage_linking` code repository:
`rules/minced.smk`, `rules/pilercr.smk`, and `rules/spacepharer_genomes.smk`.

## Topology that must not regress

- MG and MT were coassembled per physical sample; do not draw independent assembly
  journeys.
- MAGs were recovered per sample through multiple binners/MAGScoT, then
  dereplicated across samples to the unified **348-MAG** catalogue.
- Reads map back to unified MAG/vOTU catalogues.
- The collaborator-returned cDNA 16S/DADA2 branch remains separate from assembly,
  joining only at cross-assay community interpretation.
- Downstream full-transcriptome, biofilm/SOS, population-genomic and candidate
  modelling routes remain part of the same analytical journey. Do not invent a
  joint SOS-genomic score.

## Delivery boundary

Create a new versioned preview; do not overwrite accepted or review artifacts.
Do not commit rendered PNG/PDF/SVG figure outputs to Git. Code and handoff belong
in Git; rendered figures remain under the project data root. No Google Doc change
is authorised by this handoff.

## Suggested skills

- `pdf:pdf` for vector/render QA of the revised diagram.
- `handoff` when the new subway version is ready for author review.
