# Upstream method attribution for live v2 review

This payload extends the executed-workflow prose, not its analytical scope.
Apply as native Google Docs suggestions and verify against the live readback.
Do not infer software versions from publication dates or current installations.
The separate v11 SVG remains unchanged, including its historical tool labels.

## Coassembly and mapping Methods

Quality-controlled metagenomic and metatranscriptomic reads were coassembled separately for each physical sample with MEGAHIT (Li et al., 2015), including unpaired reads and metatranscriptomic contigs as additional inputs. Recovered bins were refined with MAGScoT (Rühlemann et al., 2022) and dereplicated across samples with dRep (Olm et al., 2017), using primary and secondary average-nucleotide-identity thresholds of 0.90 and 0.95, respectively. The resulting MAG representatives were combined with the representative vOTUs in a common sequence catalogue. Metagenomic and metatranscriptomic reads were mapped separately to this unified catalogue with BWA-MEM (Li, 2013). CoverM supplied metagenomic coverage and abundance summaries (Aroney et al., 2025), while the common gene-coordinate reference supplied the metatranscriptomic count tables. This read-mapping catalogue was distinct from the MAG-only alignment inputs used for population-genomic comparisons.

## Viral discovery Methods

Viral discovery included the sample coassemblies and additional single-omics assemblies. Candidates from geNomad (Camargo et al., 2024), VirSorter2 (Guo et al., 2021) and ViraLM (Peng et al., 2024) were consolidated, with DeepMicroClass candidates additionally included for coassemblies (Hou et al., 2024). Consolidated sequences were pooled across samples and clustered with Vclust (Zielezinski et al., 2025) using Leiden clustering at 0.95 average nucleotide identity and 0.85 query coverage. Representative sequences defined the vOTUs. The taxonomic community panels used the high-quality classified subset; CRISPR-derived host-link candidates were audited separately rather than assumed to belong to that subset.

## Community count universe Methods

Metagenomic read counts from the unified MAG/vOTU catalogue were summed across contigs within each of the 348 dereplicated MAGs. The viral abundance analysis retained 616 vOTUs classified as high-quality by CheckV 1.1.1 with database 1.5 (Nayfach et al., 2021) and containing at least one viral gene. This set included nine vOTUs without a taxonomic assignment and therefore differed from the 607-vOTU set used for the taxonomic composition panels. Counts were matched to the 12 physical samples; MAGs and vOTUs were analysed separately.

## References

Li D, Liu C-M, Luo R, Sadakane K, Lam T-W. 2015. MEGAHIT: an ultra-fast single-node solution for large and complex metagenomics assembly via succinct de Bruijn graph. Bioinformatics 31:1674-1676. https://doi.org/10.1093/bioinformatics/btv033

Rühlemann MC, Wacker EM, Ellinghaus D, Franke A. 2022. MAGScoT: a fast, lightweight and accurate bin-refinement tool. Bioinformatics 38:5430-5433. https://doi.org/10.1093/bioinformatics/btac694

Olm MR, Brown CT, Brooks B, Banfield JF. 2017. dRep: a tool for fast and accurate genomic comparisons that enables improved genome recovery from metagenomes through de-replication. The ISME Journal 11:2864-2868. https://doi.org/10.1038/ismej.2017.126

Li H. 2013. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv:1303.3997v2 [preprint]. https://doi.org/10.48550/arXiv.1303.3997

Aroney STN, Newell RJP, Nissen JN, Camargo AP, Tyson GW, Woodcroft BJ. 2025. CoverM: read alignment statistics for metagenomics. Bioinformatics 41:btaf147. https://doi.org/10.1093/bioinformatics/btaf147

Camargo AP, Roux S, Schulz F, Babinski M, Xu Y, Hu B, Chain PSG, Nayfach S, Kyrpides NC. 2024. Identification of mobile genetic elements with geNomad. Nature Biotechnology 42:1303-1312. https://doi.org/10.1038/s41587-023-01953-y

Guo J, Bolduc B, Zayed AA, Varsani A, Dominguez-Huerta G, Delmont TO, Pratama AA, Gazitúa MC, Vik D, Sullivan MB, Roux S. 2021. VirSorter2: a multi-classifier, expert-guided approach to detect diverse DNA and RNA viruses. Microbiome 9:37. https://doi.org/10.1186/s40168-020-00990-y

Peng C, Shang J, Guan J, Wang D, Sun Y. 2024. ViraLM: empowering virus discovery through the genome foundation model. Bioinformatics 40:btae704. https://doi.org/10.1093/bioinformatics/btae704

Hou S, Tang T, Cheng S, Liu Y, Xia T, Chen T, Fuhrman JA, Sun F. 2024. DeepMicroClass sorts metagenomic contigs into prokaryotes, eukaryotes and viruses. NAR Genomics and Bioinformatics 6:lqae044. https://doi.org/10.1093/nargab/lqae044

Zielezinski A, Gudyś A, Barylski J, Siminski K, Rozwalak P, Dutilh BE, Deorowicz S. 2025. Ultrafast and accurate sequence alignment and clustering of viral genomes. Nature Methods 22:1191-1194. https://doi.org/10.1038/s41592-025-02701-7

Nayfach S, Camargo AP, Schulz F, Eloe-Fadrosh E, Roux S, Kyrpides NC. 2021. CheckV assesses the quality and completeness of metagenome-assembled viral genomes. Nature Biotechnology 39:578-585. https://doi.org/10.1038/s41587-020-00774-7

Dahl EM, Neer E, Bowie KR, Leung ET, Karstens L. 2022. microshades: An R Package for Improving Color Accessibility and Organization of Microbiome Data. Microbiology Resource Announcements 11:e00795-22. https://doi.org/10.1128/mra.00795-22

## Evidence and remaining scope

- Executed workflow topology and thresholds: `docs/workflow_repository_audit.md`.
- CheckV version/database: `manuscript/upstream_software_provenance.tsv`.
- Source papers: DOI links above, checked against publisher/author records on
  2026-09-09. BWA-MEM is a preprint, not a journal article. geNomad uses the final
  2024 volume citation, not its 2023 online-publication year.
- ViraLM's official source confirms the published name and authors:
  https://github.com/ChengPENG-wolf/ViraLM . The older project label `VirALM`
  refers to this tool; preserve source paths, use the published spelling in prose.
- This pass attributes the upstream tools already named in the reviewed Methods.
  It does not establish complete low-level QC/binning software provenance or
  add unverified execution details. The viromics dirty-state archival gap remains.
- All references remain static until converted with supported Zotero integration.
  Existing exact DOI matches must be reused, not duplicated.
