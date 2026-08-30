# Journal selection and conformance

Research checked: 2026-08-30

Status: provisional author decision recorded 2026-08-30. The target sequence
below is approved for preparation and author review, not for submission. Final
conformance remains blocked by issue #31 and requires a live instructions check
plus explicit author approval immediately before submission.

## Non-negotiable editorial boundary

The experiment has one control membrane and one phage-UV membrane. Repeated
cycles and initial/backflush fractions resolve change within the system, but do
not create independent treatment replicates. No journal scope statement makes
that design equivalent to biological replication.

The defensible submission is therefore an intensively sampled longitudinal
study of two membrane histories. It reports internally consistent,
organism-resolved RNA restructuring and descriptive community and
population-genomic context. It does not estimate a general causal treatment
effect. The title, abstract, statistical Methods, cover letter, and response to
reviewers must retain that boundary.

The manuscript also reuses the experimental system and public accession from
Myshkevych et al. (2025). The cover letter must cite that paper, disclose the
shared system and data, and state exactly what is new here: the complete-universe
transcriptome model, competitive gene-set tests, organism-level coherence,
six-cell recurrence analysis, and coverage-qualified descriptive population
genomics. This overlap requires an explicit novelty audit before submission.

## Current manuscript fit

- Working title: 12 words.
- Abstract: 222 words excluding keywords.
- Introduction: 249 words.
- Methods: 1,057 words.
- Results: 924 words.
- Discussion: 548 words.
- Abstract through Discussion: 3,015 words including headings and keywords;
  the body excluding the abstract is about 2,786 words.
- Current allocation: four main figures, one conditional 16S figure, and seven
  supplementary figures.
- Current evidence boundary: observational and system-specific, with no
  treatment-induced mutation, adaptation, or uniform DNA-damage claim.

The manuscript is already comfortably below the verified 5,000-word main-text
limit for an ISME Communications Research Article. Journal selection should be
driven by editorial fit and design tolerance, not by the need to shorten the
current scientific body.

## Defensible shortlist

| Rank | Journal | Scope and audience fit | One-membrane design assessment | Current format and cost evidence | Editorial risk | Recommendation |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | **ISME Communications** | Direct fit for microbial ecology, engineered microbiomes, spatial and temporal dynamics, and discovery- or methods-oriented work. The society describes the journal as emphasizing research quality and diversity. | Defensible only as a longitudinal two-system analysis. The broad transcriptome result and explicit negative DNA-damage conclusion are stronger than a treatment-efficacy pitch. Reviewers may still consider the lack of independent membranes limiting. | Research Articles have a 5,000-word main-body limit in the current indexed Oxford guidance. Fully OA. The current DOAJ record lists EUR 2,200; ISME states a 10% member discount and a case-by-case waiver route. Confirm the live OUP price and any institutional agreement at submission. | Moderate to high desk-review risk, but the best combination of audience, narrative, and quality-based scope. | **Recommended target**, subject to author approval and a clean novelty-overlap statement. |
| 2 | **FEMS Microbiology Ecology** | Strong fit for microbial ecology in managed or artificial systems, community dynamics, ecological interactions, and omics. The society asks for a significant original ecological contribution. | The design is acceptable only if the paper is framed around system-resolved ecological structure rather than generalized treatment response. The original-contribution test may be harder if the paper reads as an incremental reanalysis. | Fully OA and format-free at initial submission. The current DOAJ record lists GBP 2,500. FEMS states a 20% discount for members of affiliated societies and possible full coverage through OUP Read and Publish agreements. Confirm the live OUP price and institutional eligibility. | Moderate to high. Scope is excellent; novelty and replication will be the decisive editorial questions. | **Fallback 1**. |
| 3 | **Environmental Microbiome** | Direct fit for microbial communities in managed and engineered environments and for metagenomic, metatranscriptomic, and systems-level analyses. | Probably the most forgiving scope match if the system-specific boundary is explicit, but the journal does not waive the need for honest design reporting. The paper should follow STREAMS reporting guidance. | Fully OA. The official fee page lists GBP 1,890, USD 2,590, or EUR 2,190 plus applicable tax. The journal requires public data availability and points microbiome studies to STREAMS. | Moderate. Less audience prestige than the ISME route, but a realistic home for a rigorously bounded engineered-microbiome study. | **Fallback 2**. |

## Stretch targets not recommended for the first sequence

### The ISME Journal

The subject fit is excellent: the society explicitly includes engineered
microbiomes and spatial and temporal dynamics. It also describes the journal as
its flagship venue for work of the highest significance. The one-membrane design
and the absence of a uniform mechanistic response make the significance bar
difficult to defend. The delegated 16S analysis samples the same experimental
units and cannot repair that limitation. The current DOAJ record lists an APC
of EUR 3,675, before any ISME member discount or agreement.

Recommendation: do not lead with The ISME Journal unless the authors knowingly
choose a high-probability desk-rejection strategy. A positive 16S result alone
would not change this assessment.

### npj Biofilms and Microbiomes

The journal explicitly covers biofilm and microbiome ecology, environmental and
engineering applications, biofilm removal, and internal and external community
dynamics. The scope fit is therefore strong. However, it offers no obvious
design advantage over ISME Communications and its official Original Research
APC is currently GBP 3,190, USD 4,390, or EUR 3,890 plus applicable tax.

Recommendation: retain as a later alternative only if the authors prioritize a
Nature Portfolio biofilm audience and have confirmed APC coverage.

## Author decision record

Target journal: **ISME Communications**

Fallback 1: **FEMS Microbiology Ecology**

Fallback 2: **Environmental Microbiome**

Agent recommendation: **ISME Communications -> FEMS Microbiology Ecology ->
Environmental Microbiome**.

Decision status: **provisional author decision for package preparation**, made
2026-08-30. The author explicitly retained review authority. This decision does
not authorize a live Google Docs edit, journal-system upload, pre-submission
enquiry, or submission.

The author decision must also record:

- corresponding author and institution used for OA-agreement checking;
- available APC ceiling and whether ISME/FEMS membership applies;
- whether a pre-submission enquiry is preferred;
- whether the author accepts the desk-rejection risk of a stretch submission.

## Conformance checklist after selection

Do not mark these complete from a generic manuscript build. Re-check the live
instructions on the day of conformance because prices and submission rules can
change.

- [ ] Record the selected article type and the retrieval date of the live
  author instructions.
- [ ] Re-check title, abstract, main-text, reference, display-item, and
  supplementary limits.
- [ ] Add a complete title page: authors, affiliations, corresponding author,
  ORCIDs, running title if required, word counts, and display-item counts.
- [ ] Complete author contributions using CRediT roles.
- [ ] Complete funding, competing-interests, acknowledgements, ethics, consent,
  and permissions statements as applicable.
- [ ] Convert temporary author-year citations to the selected journal style
  using Zotero fields in Google Docs.
- [ ] Deposit a versioned code release in a persistent archive and cite its DOI
  if the selected journal requires a persistent software identifier.
- [ ] Confirm that ENA accessions, repository URL, code release, data checksums,
  software provenance, and explicit provenance gaps agree across the manuscript
  and submission form.
- [ ] Re-check every main and supplementary figure against file-format,
  resolution, dimension, font, colour, accessibility, and file-size rules.
- [ ] Re-run `bash scripts/run_pre_submission_audit.sh` after journal-specific
  edits and after any included 16S integration.
- [ ] Visually inspect every changed PDF and the final compiled manuscript.
- [ ] Prepare a journal-specific cover letter that discloses the shared
  experimental system, states the new contribution, and foregrounds the
  experimental-unit limitation.
- [ ] Prepare a submission inventory and confirm that no quarantined analysis,
  local path, temporary launcher, or untracked artifact is present.
- [ ] Obtain explicit author approval immediately before submission.

## Source record

Primary journal and society sources:

- ISME Communications scope and publishing model:
  <https://www.isme-microbes.org/public/isme-communications/>
- ISME membership discount and journal mission:
  <https://www.isme-microbes.org/public/publish-with-isme/>
- ISME APC waiver route:
  <https://www.isme-microbes.org/public/apc-waivers/>
- Oxford instructions for ISME Communications:
  <https://academic.oup.com/ismecommun/pages/general-instructions>
- The ISME Journal scope and significance language:
  <https://www.isme-microbes.org/public/isme-journal/>
- FEMS Microbiology Ecology scope, article types, format-free submission, and
  peer-review model:
  <https://fems-microbiology.org/about_fems/network-and-activities/journals/fems-microbiology-ecology/>
- FEMS portfolio OA discounts and agreements:
  <https://fems-microbiology.org/about_fems/network-and-activities/journals/>
- Oxford instructions for FEMS Microbiology Ecology:
  <https://academic.oup.com/femsec/pages/instructions_for_authors>
- Environmental Microbiome aims and scope:
  <https://environmentalmicrobiome.biomedcentral.com/about>
- Environmental Microbiome fees and funding:
  <https://environmentalmicrobiome.biomedcentral.com/submission-guidelines/fees-and-funding>
- Environmental Microbiome submission guidance:
  <https://environmentalmicrobiome.biomedcentral.com/submission-guidelines>
- npj Biofilms and Microbiomes aims and scope:
  <https://www.nature.com/npjbiofilms/aims>
- npj Biofilms and Microbiomes APCs:
  <https://www.nature.com/npjbiofilms/apc>

Current secondary fee records used where Oxford's live pages presented an
automated-access challenge:

- DOAJ ISME Communications record, updated 2026-01-15:
  <https://doaj.org/api/search/journals/bibjson.title.exact:%22ISME%20Communications%22?pageSize=10>
- DOAJ FEMS Microbiology Ecology record, updated 2026-01-15:
  <https://doaj.org/api/search/journals/issn:1574-6941?pageSize=10>
- DOAJ The ISME Journal record, updated 2026-01-15:
  <https://doaj.org/api/search/journals/bibjson.title.exact:%22The%20ISME%20Journal%22?pageSize=10>

The Oxford pages remain the submission-day authority. Search-index and DOAJ
records are evidence for this shortlist, not a substitute for the final live
conformance check.
