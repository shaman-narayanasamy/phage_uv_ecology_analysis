# Genome recovery Methods extension

Replace only the coassembly/dereplication paragraph in the read-processing
revision, as native suggestions. Preserve the preprocessing/counting paragraphs,
author text, images and existing bibliography entries.

## Revised paragraphs

Processed metagenomic and metatranscriptomic reads were coassembled separately for each physical sample with MEGAHIT (Li et al., 2015), including unpaired reads and metatranscriptomic contigs as additional inputs. Contigs classified by DeepMicroClass as prokaryotic, prokaryotic viral or plasmid sequences were combined as binning inputs (Hou et al., 2024). Candidate bins were generated with CONCOCT (Alneberg et al., 2014), MaxBin2 (Wu et al., 2016), MetaBAT2 (Kang et al., 2019), Vamb (Nissen et al., 2021), and the single-sample and multisample workflows of SemiBin2 (Pan et al., 2023). These six assignment streams were combined for each sample and refined with MAGScoT (Rühlemann et al., 2022).

The minimum contig setting was 1,500 bases for MaxBin2, MetaBAT2, Vamb and SemiBin2. Vamb additionally used a minimum output-bin length of 200,000 bases. CONCOCT inputs were split into 1,000-base segments with the final segment merged, while clustering used a 1,500-base length threshold. Refined bins were dereplicated across samples with dRep (Olm et al., 2017), using completeness and contamination cut-offs of 75% and 25%, primary and secondary average-nucleotide-identity thresholds of 0.90 and 0.95, and tertiary clustering. These selection settings did not define a uniformly high-quality MAG subset. The resulting MAG representatives were combined with the representative vOTUs in a common sequence catalogue.

## References

Alneberg J, Bjarnason BS, de Bruijn I, Schirmer M, Quick J, Ijaz UZ, Lahti L, Loman NJ, Andersson AF, Quince C. 2014. Binning metagenomic contigs by coverage and composition. Nature Methods 11:1144-1146. https://doi.org/10.1038/nmeth.3103

Wu Y-W, Simmons BA, Singer SW. 2016. MaxBin 2.0: an automated binning algorithm to recover genomes from multiple metagenomic datasets. Bioinformatics 32:605-607. https://doi.org/10.1093/bioinformatics/btv638

Kang DD, Li F, Kirton E, Thomas A, Egan R, An H, Wang Z. 2019. MetaBAT 2: an adaptive binning algorithm for robust and efficient genome reconstruction from metagenome assemblies. PeerJ 7:e7359. https://doi.org/10.7717/peerj.7359

Nissen JN, Johansen J, Allesøe RL, Sønderby CK, Almagro Armenteros JJ, Grønbech CH, Jensen LJ, Nielsen HB, Petersen TN, Winther O, Rasmussen S. 2021. Improved metagenome binning and assembly using deep variational autoencoders. Nature Biotechnology 39:555-560. https://doi.org/10.1038/s41587-020-00777-4

Pan S, Zhao X-M, Coelho LP. 2023. SemiBin2: self-supervised contrastive learning leads to better MAGs for short- and long-read sequencing. Bioinformatics 39:i21-i29. https://doi.org/10.1093/bioinformatics/btad209

Tisza MJ, Varsani A, Petrosino JF, Cregeen SJJ. 2026. Cenote-Taker 3 for fast and accurate virus discovery and annotation of the virome. Peer Community Journal 6:e31. https://doi.org/10.24072/pcjournal.706

## Gene-coordinate paragraph

The common gene-coordinate reference combined the dereplicated-MAG gene intervals from Bakta (Schwengers et al., 2021) with viral gene intervals from Cenote-Taker 3 (version 3.4.4; Tisza et al., 2026). Cenote-Taker contig identifiers were linked to the original catalogue identifiers through the archived name map. Viral gene starts were converted to zero-based BED coordinates, with the corresponding chunk offsets added to both interval boundaries for genes reported within extracted prophage regions. The combined BED retained the records from both source tables; coordinate-aware feature identifiers distinguished repeated gene names at different positions.

## Evidence and limits

- `derived/upstream_execution_audit_2026-09-09-v2/execution_audit.json` covers
  260 complete execution records, including all 12 CONCOCT split/clustering
  pairs and all per-sample refinement inputs. This extends, not overwrites, v1.
- Archived `binning/dereplication/log/cluster_arguments.json` records 75/25
  completeness/contamination, 0.90/0.95 ANI, tertiary clustering, and the
  CheckM lineage workflow. SHA256
  `c5c7b09af5234ba8894e40514ed2419f9222b4ae6f950aef9e888638c4ddcada`.
  The coordinate audit also preserves this JSON and its source hash.
- The unusual CONCOCT split/filter combination is reported as executed. This
  audit does not claim it was optimal or prove its contribution to final bins.
- The 25% contamination cut-off must not be replaced in prose by a conventional
  5% or 10% threshold. It is an upstream eligibility setting, not the observed
  contamination of every retained MAG. MAG-quality sensitivity of organism-level
  interpretation remains a review item.
- The gene-coordinate audit verifies all 766,445 viral annotation records
  against the BED after chunk offsets, including repeated records. The combined
  BED matches the exact row multiplicities of the MAG and viral tables; only
  ordering differs. Three representative MAG genes match Bakta GFF start-minus-
  one conversion; this is not a full per-MAG GFF audit. Source hashes are in
  `derived/catalogue_coordinate_audit_2026-09-09-v3/coordinate_audit.json`.
  Its 1,734,193 combined rows comprise 1,734,019 unique records and 174 exact
  duplicates; 30,666 viral rows require chunk offsets. Repeated gene names
  alone are not a basis for deduplication. The superseded v1 audit assumed
  byte-concatenation and omitted chunk offsets; its failures were audit
  assumptions, not evidence of corrupted source data.
- Five binning papers checked against publisher/PubMed records and publisher-
  deposited Crossref metadata on 2026-09-09. MaxBin's volume citation is 2016,
  not its 2015 online-publication date. No execution version is inferred from
  a paper's year. Cenote-Taker 3 cites its published 2026 paper, not its earlier
  preprint: https://peercommunityjournal.org/articles/10.24072/pcjournal.706/ .
  References remain static until supported Zotero conversion.
