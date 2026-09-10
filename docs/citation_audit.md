# Citation audit

## Current extension, 2026-09-09

The historical audit below does not cover the returned 16S or newly audited
upstream Methods. The canonical bibliography now contains **41 DOI-addressed
journal articles, one DOI-addressed preprint and one software record**.
`tests/test_references.R` verifies unique
keys/DOIs, article and software metadata, the preserved 16-record scaffold and
the new citations in versioned revision payloads. It explicitly
does not verify live Zotero fields or claim full manuscript citation coverage.

New primary-source-verified records are Love2014 (DESeq2), Zhang2021SpacePHARER,
Edgar2007 (PILER-CR), MinCED, Callahan2016 (DADA2), Martin2011 (cutadapt),
Quast2013 (SILVA) and McMurdie2013 (phyloseq). Their DOI/primary URLs and exact
insertion payloads are in `manuscript/revisions/2026-09-09-community-and-host-methods.md`
and `manuscript/revisions/2026-09-09-16s-method-citations.md`. All eight references
are present as suggested static reference entries in live v2; the latter four
and the cited 16S Methods were verified at `20260909T115205Z`.

Readback `20260909T123927Z` verifies three cited upstream Methods paragraphs
and 12 additional reference entries, each exactly once. Payload:
`manuscript/revisions/2026-09-09-upstream-method-citations.md`. The tools already
named in those paragraphs now cite MEGAHIT, MAGScoT, dRep, BWA-MEM, CoverM,
geNomad, VirSorter2, ViraLM, DeepMicroClass, Vclust and CheckV. The missing
Dahl2022 entry cited by Figure 1/S6 is now present. All remain static suggestions.
CheckV's executed version/database are included from archived provenance;
BWA-MEM is explicitly cited as a preprint; geNomad uses its final 2024 volume
citation. Published spelling ViraLM replaces the prose label VirALM, without
editing historical code paths or the separate workflow SVG.

Readback `20260909T140403Z` confirms the three-paragraph read-processing,
coassembly and count-construction extension plus four references, each once:
Chen2018fastp, Kopylova2012SortMeRNA, Li2009SAMtools and Quinlan2010BEDTools.
The payload is `manuscript/revisions/2026-09-09-read-processing-and-counting.md`.
These are static native suggestions, not live Zotero fields. Exact execution
evidence now covers 35 preprocessing reports and 260 archived run records.

Readback `20260909T143027Z` verifies the expanded genome-recovery Methods:
two coassembly/binning/dereplication paragraphs and one gene-coordinate
paragraph, plus six reference entries, once each in Normal text. New primary
references are Alneberg2014CONCOCT, Wu2016MaxBin, Kang2019MetaBAT,
Nissen2021Vamb, Pan2023SemiBin2 and Tisza2026CenoteTaker3. Cenote-Taker cites
its published Peer Community Journal article (2026), not the former preprint.
MaxBin uses its 2016 volume year rather than 2015 online publication.
Payload: `manuscript/revisions/2026-09-09-genome-recovery.md`. All 128 targeted
live checks pass; these remain native suggestions, not accepted text or fields.

Still open: full per-MAG GFF provenance, MAG-quality and quantification
sensitivity; broader biological literature coverage and bibliography
ordering; supported Zotero library writes and conversion to live citation fields.
Do not infer exact execution versions from current installed environments.

Ten original Zotero metadata names remain preserved in v2. Refreshed read-only
audit `zotero_library_match_audit_20260909T143219Z.json` finds 29 unique exact
matches among 42 DOI records. Newly resolved existing binning items are CONCOCT
`VFGQVCUV`, MaxBin2 `VG4YBVVJ`, MetaBAT2 `G2FTDFID`, Vamb `TUH4BF9S` and
SemiBin2 `6NQ6XR5D`. Prior matches include SortMeRNA `VWANIQK4`, SAMtools
`CPRMTJYC` and BEDTools `PTUPGCA6`; reuse these items. Fastp and the published
Cenote-Taker 3 paper have no exact DOI match. Thirteen DOI records remain unmatched. BWA-MEM has
no DOI or title-query match. MinCED has no DOI and is outside this audit.
Reuse matched item keys recorded in the audit/handoff; do not duplicate them.
This DOI-match count does not establish which citations are live fields.
No Zotero library writes have occurred.
The pending write-key question must not interrupt other manuscript work.

## Historical audit (scope frozen before collaborator return)

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
