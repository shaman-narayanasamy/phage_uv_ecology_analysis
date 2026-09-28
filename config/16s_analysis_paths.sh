# Shell configuration for the delegated 16S workstream.
#
# Source this file before running any 16S step:
#
#   source config/16s_analysis_paths.sh
#
# Every value can be overridden by exporting it before sourcing. Raw reads,
# reference databases, and derived objects are deliberately kept outside Git.

# Managed data root for this project on the analyst workstation.
: "${PHAGE_UV_DATA_ROOT:=${HOME}/Work/data/phage_uv_treatment/PRJEB79569}"

# Inputs.
: "${PHAGE_UV_16S_RAW_DIR:=${PHAGE_UV_DATA_ROOT}/16s_raw_reads}"
: "${PHAGE_UV_16S_REFERENCE_DIR:=${PHAGE_UV_DATA_ROOT}/reference/16s}"

# Derived output root and its per-step subdirectories.
: "${PHAGE_UV_16S_DERIVED:=${PHAGE_UV_DATA_ROOT}/derived/16s_analysis}"
: "${PHAGE_UV_16S_TRIMMED_DIR:=${PHAGE_UV_16S_DERIVED}/01_primer_removal}"
: "${PHAGE_UV_16S_SUBSAMPLED_DIR:=${PHAGE_UV_16S_DERIVED}/01b_subsampled}"
: "${PHAGE_UV_16S_QUALITY_DIR:=${PHAGE_UV_16S_DERIVED}/02_quality_profiles}"
: "${PHAGE_UV_16S_DADA2_DIR:=${PHAGE_UV_16S_DERIVED}/03_dada2}"
: "${PHAGE_UV_16S_TAXONOMY_DIR:=${PHAGE_UV_16S_DERIVED}/04_taxonomy}"
: "${PHAGE_UV_16S_PHYLOSEQ_DIR:=${PHAGE_UV_16S_DERIVED}/05_phyloseq}"
: "${PHAGE_UV_16S_ECOLOGY_DIR:=${PHAGE_UV_16S_DERIVED}/06_ecology}"
: "${PHAGE_UV_16S_DA_DIR:=${PHAGE_UV_16S_DERIVED}/07_exploratory_differential_abundance}"
: "${PHAGE_UV_16S_FIGURE_DIR:=${PHAGE_UV_16S_DERIVED}/08_figures}"
: "${PHAGE_UV_16S_RETURN_DIR:=${PHAGE_UV_16S_DERIVED}/09_return_package}"

# Denoising parameters. Change these only with a recorded reason; every value
# is written into the provenance table by scripts/run_16s_dada2.qmd.
: "${PHAGE_UV_16S_THREADS:=4}"
# Settled from the 2026-09-02 quality profiles: reverse median quality falls
# from 30 at cycle 235 to 22 at 245 and 19 at 255.
: "${PHAGE_UV_16S_TRUNC_LEN_R1:=279}"
: "${PHAGE_UV_16S_TRUNC_LEN_R2:=235}"
: "${PHAGE_UV_16S_MAX_EE_R1:=2}"
: "${PHAGE_UV_16S_MAX_EE_R2:=2}"
: "${PHAGE_UV_16S_MIN_OVERLAP:=20}"
: "${PHAGE_UV_16S_POOL:=pseudo}"
: "${PHAGE_UV_16S_MIN_BOOT:=80}"
: "${PHAGE_UV_16S_LEARN_NBASES:=1e8}"

# Even-depth subsampling before denoising (optional; see the protocol).
: "${PHAGE_UV_16S_SUBSAMPLE_DEPTH:=150000}"
: "${PHAGE_UV_16S_SUBSAMPLE_SEED:=42}"

# Set to false where the GTDB k-mer index does not fit in memory.
: "${PHAGE_UV_16S_GTDB_CROSSCHECK:=true}"

# Primers as reported in the original study (515F / 907R, degenerate IUPAC).
: "${PHAGE_UV_16S_PRIMER_FWD:=GTGYCAGCMGCCGCGGTAA}"
: "${PHAGE_UV_16S_PRIMER_REV:=CCCCGYCAATTCMTTTRAGT}"

export PHAGE_UV_DATA_ROOT PHAGE_UV_16S_RAW_DIR PHAGE_UV_16S_REFERENCE_DIR \
  PHAGE_UV_16S_DERIVED PHAGE_UV_16S_TRIMMED_DIR PHAGE_UV_16S_QUALITY_DIR \
  PHAGE_UV_16S_DADA2_DIR PHAGE_UV_16S_TAXONOMY_DIR PHAGE_UV_16S_PHYLOSEQ_DIR \
  PHAGE_UV_16S_ECOLOGY_DIR PHAGE_UV_16S_DA_DIR PHAGE_UV_16S_FIGURE_DIR \
  PHAGE_UV_16S_RETURN_DIR PHAGE_UV_16S_THREADS PHAGE_UV_16S_TRUNC_LEN_R1 \
  PHAGE_UV_16S_TRUNC_LEN_R2 PHAGE_UV_16S_MAX_EE_R1 PHAGE_UV_16S_MAX_EE_R2 \
  PHAGE_UV_16S_MIN_OVERLAP PHAGE_UV_16S_POOL PHAGE_UV_16S_MIN_BOOT \
  PHAGE_UV_16S_LEARN_NBASES PHAGE_UV_16S_SUBSAMPLED_DIR \
  PHAGE_UV_16S_SUBSAMPLE_DEPTH PHAGE_UV_16S_SUBSAMPLE_SEED \
  PHAGE_UV_16S_GTDB_CROSSCHECK \
  PHAGE_UV_16S_PRIMER_FWD PHAGE_UV_16S_PRIMER_REV
