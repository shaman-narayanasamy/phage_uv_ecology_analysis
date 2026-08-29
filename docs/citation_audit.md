# Citation audit

Audit date: 2026-08-29

## Canonical source and scope

`manuscript/references.bib` is the canonical Zotero import file. It contains 14
unique journal-article records, each with a DOI. The manuscript's temporary
author-year citations and manually rendered reference list are synchronized to
that file by `tests/test_references.R`.

This audit covers the current metagenomic, metatranscriptomic, population-
genomic, and taxonomic-context manuscript. The collaborator-owned 16S workflow
is deliberately excluded until its exact tools, databases, versions, and primer
method are returned. Those references must describe the analysis actually run,
not the repository supplied only as a guide.

## Verified records

| Citation key | Manuscript role | Stable identifier | Verification basis |
| --- | --- | --- | --- |
| `Aroney2025` | CoverM read-count method | `10.1093/bioinformatics/btaf147` | Publisher DOI metadata and official CoverM repository citation |
| `Benjamini1995` | False-discovery-rate control | `10.1111/j.2517-6161.1995.tb02031.x` | Publisher DOI record |
| `Dahl2022` | Accessible, hierarchy-aware microbiome colours | `10.1128/mra.00795-22` | ASM article record |
| `Maslowska2019` | SOS biological interpretation boundary | `10.1002/em.22267` | Publisher and PubMed Central article records |
| `Myshkevych2025` | Repeated-cycle experiment and dataset provenance | `10.1016/j.ceja.2025.100796` | Publisher DOI record |
| `Nayfach2021` | CheckV viral-genome quality assessment | `10.1038/s41587-020-00774-7` | Nature Biotechnology article record |
| `Olm2021` | inStrain population microdiversity | `10.1038/s41587-020-00797-0` | Nature Biotechnology article record |
| `Parks2022` | GTDB taxonomy | `10.1093/nar/gkab776` | Nucleic Acids Research DOI record |
| `Robinson2010edgeR` | edgeR differential-expression framework | `10.1093/bioinformatics/btp616` | Bioinformatics DOI record |
| `Robinson2010TMM` | TMM normalization | `10.1186/gb-2010-11-3-r25` | Genome Biology DOI record |
| `Scarascia2021` | Original UV-phage membrane-cleaning study | `10.1073/pnas.2016529118` | PNAS DOI record |
| `Schwengers2021` | Bakta annotation | `10.1099/mgen.0.000685` | Microbial Genomics DOI record |
| `vonMeijenfeldt2019` | CAT/BAT classification | `10.1186/s13059-019-1817-x` | Genome Biology DOI record |
| `Wu2012` | camera competitive gene-set testing | `10.1093/nar/gks461` | Nucleic Acids Research DOI record |

## Gaps resolved in this issue

- The MAG-mapped community-profile method now cites CoverM and states its
  denominator explicitly.
- The family-profile colour hierarchy now cites microshades.
- The vOTU catalogue legend now cites CheckV.
- The Discussion now supports the narrow claim that SOS-associated
  transcription is a regulated response and is not itself a direct measurement
  of DNA lesions.
- Named methods and databases in the current Methods have authoritative
  citations: edgeR, TMM, Benjamini-Hochberg, Bakta, CAT/BAT, GTDB, camera, and
  inStrain.

The current manuscript does not name Cenote-Taker3, so no software citation was
added without a version-backed provenance need. If it is named later, its exact
version and official citation must be recovered from the viral-analysis
provenance before adding a record.

## Zotero and Google Docs contract

1. Import `manuscript/references.bib` into the manuscript's Zotero collection.
2. Let Zotero deduplicate against any records already in that collection using
   DOI as the primary match.
3. In Google Docs, replace temporary plain-text author-year citations with
   Zotero plugin citations and generate the bibliography with the selected
   journal style.
4. Do not describe the current plain text as Zotero field codes. That live
   Google Docs conversion remains required before submission.
5. When the 16S report arrives, add only the references matching its executed
   workflow, then rerun `Rscript tests/test_references.R`.

The repository test checks uniqueness and structural completeness of the BibTeX
records. Final Zotero import and live field-code conversion require the Zotero
desktop/plugin environment and therefore remain an explicit submission-stage
action rather than a completed repository action.
