# Phage-UV ecology analysis

Analysis code for the PRJEB79569 anaerobic membrane biofilm study. The project
combines 16S amplicon data, metagenomes and metatranscriptomes to assess
community dynamics, biofilm-associated transcription, stress responses and
candidate populations for subsequent treatment experiments.

Raw sequencing data: https://www.ebi.ac.uk/ena/browser/view/PRJEB79569.

## Analysis entry points

| Analysis | Source |
| --- | --- |
| Transcriptome-wide differential expression | `scripts/run_full_transcriptome_edger.qmd` |
| Functional interpretation | `scripts/interpret_full_transcriptome_de.qmd` |
| MAG and vOTU abundance models | `scripts/run_community_differential_abundance.qmd` |
| Cross-omics community comparison | `analysis/community_cross_omics_permutation_tests.qmd` |
| Combined biofilm-associated annotation list | `analysis/biofilm_combined_definition.qmd` |
| MAG-level functional concentration | `analysis/mag_functional_concentration.qmd` |
| Genomic-block dependence tests | `analysis/mag_concentration_dependence.qmd` |
| Cleaning-performance composite score | `analysis/cleaning_performance_score.qmd` |
| Candidate MAG suppression models | `analysis/cleaning_score_MAG_models.qmd` |
| Community-wide suppression models | `analysis/cleaning_score_all_MAG_models.qmd` |
| Population-genomic comparison | `scripts/build_population_genomics_descriptive.qmd` |

## Running the code

R notebooks can be opened in RStudio or executed with the supplied runner:

```sh
bash scripts/run_qmd.sh scripts/run_full_transcriptome_edger.qmd --help
```

Python notebooks use `scripts/run_python_qmd.py`. Check each notebook's input
paths and dependencies before execution, and use a fresh output directory.
Large input tables, assemblies, alignments and generated figures are stored
outside Git. Several notebooks retain the original workstation or cluster
paths; update these for your environment. Notebooks that support
`PHAGE_UV_DATA_ROOT` accept the study directory through that variable.

## Repository contents

- `analysis/`: ecological and statistical analyses, models and plotting code.
- `scripts/`: workflow entry points, notebook runners and validation tools.
- `R/`: shared analysis and plotting functions.
- `metadata/`: sample information and input contracts.
- `config/`, `hpc/` and `launchers/`: configuration and cluster execution.
- `tests/`: automated checks.

## Related workflows

- [multiomics_pipeline](https://github.com/shaman-narayanasamy/multiomics_pipeline): read processing, assembly, MAG recovery, annotation and quantification.
- [viromics_pipeline](https://github.com/shaman-narayanasamy/viromics_pipeline): viral identification, catalogue construction and annotation.
- [host_phage_linking](https://github.com/shaman-narayanasamy/host_phage_linking): sequence-based host-phage links.
- [community_uv_response](https://github.com/shaman-narayanasamy/community_uv_response): UV-response annotation and population-genomic utilities.
