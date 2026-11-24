# Introduction revision for author review

Status: five-paragraph prose revision inserted into the current v3 Google Doc as three Codex Assistant replacement suggestions on 2026-09-15. Original text and author comments remain reviewable. Author-year references are citation placeholders pending live Zotero insertion. Do not report these as live Zotero fields.

Document: https://docs.google.com/document/d/1tl6VL6Z1bYcTDuG67CHY4mOdkWuEIvzWOhBMqKneQbQ/edit

Zotero checkpoint updated 2026-09-15: desktop access succeeded after the user moved Zotero to the current Space. Created collection `NMULZ6FZ`, **Phage UV ecology manuscript**, and imported all seven missing DOI records with Zotero's Add Item(s) by Identifier. Verified titles and DOIs through the read-only local API. Keys: Lu2016 `KJDEVHTA`; Cheng2019 `UX2Z9TVB`; LuCollins2007 `9ZTHP5VD`; Chaudhry2017 `7DDD65XN`; Scarascia2021 `WR8BS6SY`; Myshkevych2025 `5CHFZ3U4`; Vidakovic2018 `ZYNB678K`. Existing own-paper item `MXBBDY87` remains in the library, not yet added to the new collection. Optional ScienceDirect PDF download raised a CAPTCHA; no CAPTCHA was solved. Subsequent API verification confirmed all seven citation records despite desktop-control timeouts.

Live citation fields remain pending. Chrome has a Zotero menu but the connected Shaman profile has only the user's Google account signed in. Codex Assistant is signed into the in-app browser, which has no Zotero menu. Asked user whether an assistant Chrome profile/window already exists; do not assume it does not. No manuscript edits under the user's identity. Do not forge fields or describe the references as linked in Google Docs before verification.

## Paragraph 1

Membrane biofouling constrains the operation of anaerobic membrane bioreactors (AnMBRs) and creates a recurring need for membrane cleaning. Backwashing and chemical cleaning restore performance, but do not address which members of the biofilm community should be targeted. Membrane biofilms undergo microbial succession, while their constituent populations differ in their association with the membrane and surrounding sludge (Lu et al., 2016; Cheng et al., 2019). Understanding these ecological differences provides a basis for developing more targeted biocontrol strategies.

## Paragraph 2

Ultraviolet-C (UV-C) irradiation and bacteriophages offer complementary approaches to microbial control. UV-C damages nucleic acids, whereas lytic phages infect and lyse susceptible host cells. Phages can also be engineered to disrupt the extracellular matrix, as demonstrated by enzymatic phages that simultaneously attack bacterial cells and biofilm polymers (Lu and Collins, 2007). Combining phages with other interventions therefore provides several routes to biofilm control. In Pseudomonas aeruginosa biofilms, for example, the efficacy of phage-antibiotic combinations depended on the antibiotic and order of administration (Chaudhry et al., 2017). The biological context of an intervention is consequently relevant to its design.

## Paragraph 3

In anaerobic membrane bioreactors, a combined backwashing, phage and UV-C procedure was developed as a chemical-free cleaning approach (Scarascia et al., 2021). The treatment reduced membrane-associated cells and extracellular polymeric substances and sustained membrane operation. A subsequent study followed repeated cleaning cycles and reported delayed transmembrane-pressure regrowth alongside changes in cell and protein removal and transcription in selected biofilm-associated organisms (Myshkevych et al., 2025). These studies establish the engineering context for examining how the community responds during repeated treatment.

## Paragraph 4

The response of a biofilm cannot be inferred from the susceptibility of individual isolates alone. Experimental work has shown that matrix architecture can restrict phage transport and protect resident cells (Vidakovic et al., 2018). Within a complex community, treatment can therefore coincide with changes in population abundance, transcriptional activity and interactions between hosts and phages. Genome-resolved integrated-omics provides a means to examine these processes together. In wastewater microbial communities, time-resolved meta-omics has linked specific populations to mobile genetic elements through CRISPR spacer information and related their dynamics using statistical models (Martinez Arbas et al., 2021). Applying this ecological framework to repeated cleaning can connect community responses with the next targets for intervention.

## Paragraph 5

Here, we reanalyse the published treatment dataset to examine community responses across three cleaning cycles and the initial and backflush sampling phases. We integrate 16S rRNA cDNA profiles, metagenomes and metatranscriptomes to resolve i) microbial and viral community dynamics, ii) genome-resolved biofilm-associated and SOS transcriptional responses, iii) population-genomic variation, and iv) CRISPR-supported host-phage associations. We then relate the abundance of MAGs carrying treatment-upregulated biofilm-associated genes to a composite cleaning-performance score derived from the reported phenotype measurements. Modelled suppression of these populations, considered alongside existing phage links, provides a proof of concept for using community ecology to prioritise candidates for subsequent treatment optimisation.

## Citation map

- Lu2016: 10.1016/j.watres.2015.10.013
- Cheng2019: 10.1016/j.envint.2019.105165
- LuCollins2007: 10.1073/pnas.0704624104
- Chaudhry2017: 10.1371/journal.pone.0168615
- Scarascia2021: 10.1073/pnas.2016529118
- Myshkevych2025: 10.1016/j.ceja.2025.100796
- Vidakovic2018: 10.1038/s41564-017-0050-1
- MartinezArbas2021: 10.1038/s41564-020-00794-8; existing Zotero item MXBBDY87, user5080709. Use issue year2021 consistently (online2020).

## Editorial decisions

### Comment-driven expansion, later on 2026-09-15

User rejected the sparse citation coverage. Added seven further primary studies to specific claims in the live Introduction as Codex Assistant suggestions, bringing the cited set to 15 distinct studies. Replied directly to the author's three Introduction comments (15:07 sparse coverage, 15:01 broader literature, 14:56 Zotero). Left comments open for review and pending citation integration. Did not modify the 15:03 Results citation comment.

Additional source map, library matching/import still pending:

- Goldman2009: 10.1016/j.memsci.2009.06.036; membrane-specific phage biofouling control.
- Simmons2018: 10.1038/ismej.2017.190; spatial model of phage mobility and coexistence.
- Testa2019: 10.1038/s42003-019-0633-x; experimental growth/competition effects in dual-strain biofilms.
- Lawson2017: 10.1038/ncomms15416; genome/transcript/metabolic modelling of anammox populations.
- Herold2020: 10.1038/s41467-020-19006-2; time-series multi-omics and disturbance. First author verified as Malte Herold through Crossref, NOT Muller.
- Kim2024: 10.1038/s41467-024-53994-9; receptor-complementary phage-antibiotic cocktails.
- Kunisch2024: 10.1038/s41467-024-52595-w; biofilm-directed evolutionary phage training.

New prose is present in Google Docs but the original five-paragraph snapshot above predates these additions. No live Zotero fields created. During the additional import preflight, local API requests timed out and desktop control reported the Mac locked. Do not conflate that with Zotero being closed. Future duplicate matching must use `qmode=everything` or enumerate items and compare DOI, not the default title/creator/year query. Initial seven imports are real and verified, but the earlier default-query duplicate preflight was insufficient to exclude pre-existing copies; audit before further imports and do not delete automatically.

Preserve the author's problem-to-hybrid-biocontrol-to-community framing. Remove the unsupported broad restriction of UV-C to medical use, and distinguish membrane lifespan from biofilm lifespan. Attribute the original experiment; this study reanalyses its data. Include the modelling objective that was missing from the old final paragraph. Do not duplicate study Limitations here. See the checkpoints above for current Zotero library versus live-field status.
