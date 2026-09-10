# Workflow schematic redesign

## Author acceptance and incorporation

On 2026-09-07 the author said "Ok close enough. Incorporate it for now".
Version `workflow_metro_v10` is therefore accepted provisionally, not an
unreviewed candidate. It is included in
`manuscript/accepted_figure_inventory.tsv`, with its full legend in
`manuscript/figure_legends.md` and its status reflected in the figure plan.
No new figure number was imposed. The Google Doc remains unchanged pending
review of the author's tracked edits; this incorporation is local.

## Current: one continuous subway map (v10)

The author rejected the separated panels in v6 and explicitly requested the
nf-core/Nextflow subway convention: everything is the same journey. Current
review candidate: `PRJEB79569/derived/workflow_metro_v10/`. All older versions
are preserved but superseded for review. The drawing is original, with
continuous tracks, shared stations and subtle stage columns inspired by
https://nf-co.re/docs/community/brand/workflow-schematics (RNA-seq and MAG
examples); no nf-core artwork or branding was incorporated.

The physical experiment is the common origin of all streams. MG/MT routes
retain continuous read paths to the shared mapping station as well as inputs
to coassembly. Reference branches meet at the unified catalogue. Host links
and MAG-only population analysis connect to their reference/read sources.
16S and shotgun community evidence meet at the community interpretation
endpoint; this is not a claim of pooled counts or a joint statistical model.

`workflow_nodes.tsv` and `workflow_edges.tsv` record the semantic graph.
The notebook asserts that every stage is reachable from the experimental
origin. No station at a route crossing means no join. PDF/SVG/PNG and the two
graph tables are checksum-indexed. PDF visually inspected after label and
crossing corrections; manuscript prose and Google Doc remain untouched.

## Superseding correction after repository audit

The author identified material errors in metro v3. It is superseded by
`PRJEB79569/derived/workflow_metro_v6/`. Versions 1-5 are historical review
artifacts and must not be used as current workflow evidence.

Version 6 explicitly shows per-sample MG/MT coassembly, MT-contig input,
additional single-omics viral discovery, cross-sample MAG dereplication and
vOTU clustering, and remapping of both omics to the unified MAG/vOTU catalogue.
MAG-only population-genomic alignments have a separate input contract.
See `docs/workflow_repository_audit.md` for the inspected repositories,
executed commits, archive evidence and remaining viromics provenance gap.

The author also selected his 2020 Nature Microbiology paper as the benchmark
for writing, outline, formatting and figures. The local revision guide is
`docs/nature_microbiology_manuscript_benchmark.md`. Live Google Doc edits
remain pending author-edit review. No live manuscript changes were made.

Validation: current PDF visually inspected after spacing corrections; all
three exported artifact checksums verified; 25 Quarto entrypoints validated.

## Historical v3 receipt (superseded)

The author rejected the original box-based diagram and supplied
`pipeline_schematic_draft_v3.pdf` as a visual reference. The replacement adopts
continuous coloured routes and stations, retaining project-specific provenance.

Current review candidate: `PRJEB79569/derived/workflow_metro_v3/`, with vector
PDF and SVG, PNG preview, and MD5 inventory. Reproducible source:
`scripts/build_workflow_metro.qmd`. Earlier `workflow_metro_v1/`,
`workflow_metro_v2/`, and the box-based workflow in `16s_manuscript_integration/`
are retained as prior versions. The metro v3 figure supersedes the box diagram
for review; existing 16S output bundles remain intact.

Routes show 16S cDNA amplicons, metagenomes, the assembly-derived viral branch,
and metatranscriptomes. Dashed connections show the MAG-derived reference for
RNA mapping and MAG input to CRISPR host-phage analysis. Mapping precedes
aggregation of run counts into physical samples. The 86 candidate host-phage
pairs are from the broader viral collection, not the 607 classified high-quality
vOTUs: none of the linked representatives passed that restricted filter.

The compact drawing groups binning and dereplication as MAG recovery; detailed
software provenance remains in the methods and analysis registries. Endpoints
describe current outputs, not positive results or causal treatment effects.
No Google Doc or manuscript prose was changed. The author's tracked edits
still need review before manuscript revision.

QA: inspected the PDF raster at 1800 pixels wide after three layout passes;
checked one-page PDF, SVG export, and checksums. Source and manifest consistency
are checked with the existing Quarto-entrypoint test.
