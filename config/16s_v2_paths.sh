# Shell configuration for the isolated 16S_v2 workstream.
#
# Source this file INSTEAD OF config/16s_analysis_paths.sh:
#
#   source config/16s_v2_paths.sh
#
# It reuses every denoising parameter from the v1 configuration but routes
# every read and write into a self-contained v2 workspace, and refuses to
# continue if any output directory resolves into a protected v1 location
# (handoff notes/handoff-2026-09-09-16s-v2-isolated.md, "Isolation contract").
#
# Source commit of the reused code: b6acbe5 (feature/prjeb79569-16s-analysis).

# Self-contained v2 workspace. Nothing under it is shared with v1.
: "${PHAGE_UV_16S_V2_ROOT:=${HOME}/Work/data/phage_uv_treatment/16S_v2}"

# Read-only reference to the preserved v1 return copy on this machine. Used
# only for checksum inventories and for copying the accepted 12-sample ASV
# table into the v2 inputs; never written to.
: "${PHAGE_UV_16S_V1_RETURN_COPY:=${HOME}/Library/CloudStorage/OneDrive-nium.io/00_Projects/2026_09_03_phage_uv_data_16S_analysis/PRJEB79569/derived/16s_analysis}"

# Map the v1 variable names onto v2 locations BEFORE sourcing the v1 file so
# that its `: "${VAR:=default}"` assignments become no-ops.
export PHAGE_UV_DATA_ROOT="${PHAGE_UV_16S_V2_ROOT}"
export PHAGE_UV_16S_RAW_DIR="${PHAGE_UV_16S_V2_ROOT}/inputs/raw_reads"
export PHAGE_UV_16S_REFERENCE_DIR="${PHAGE_UV_16S_V2_ROOT}/inputs/reference"
export PHAGE_UV_16S_DERIVED="${PHAGE_UV_16S_V2_ROOT}/results"
export PHAGE_UV_16S_TRIMMED_DIR="${PHAGE_UV_16S_DERIVED}/01_primer_removal"
export PHAGE_UV_16S_SUBSAMPLED_DIR="${PHAGE_UV_16S_DERIVED}/01b_subsampled"
export PHAGE_UV_16S_QUALITY_DIR="${PHAGE_UV_16S_DERIVED}/02_quality_profiles"
export PHAGE_UV_16S_DADA2_DIR="${PHAGE_UV_16S_DERIVED}/03_dada2"
export PHAGE_UV_16S_TAXONOMY_DIR="${PHAGE_UV_16S_DERIVED}/04_taxonomy"
export PHAGE_UV_16S_PHYLOSEQ_DIR="${PHAGE_UV_16S_DERIVED}/05_phyloseq"
export PHAGE_UV_16S_ECOLOGY_DIR="${PHAGE_UV_16S_DERIVED}/06_ecology"
export PHAGE_UV_16S_DA_DIR="${PHAGE_UV_16S_DERIVED}/07_exploratory_differential_abundance"
export PHAGE_UV_16S_FIGURE_DIR="${PHAGE_UV_16S_DERIVED}/08_figures"
export PHAGE_UV_16S_RETURN_DIR="${PHAGE_UV_16S_DERIVED}/09_return_package"

# v2-only locations.
export PHAGE_UV_16S_V2_INPUTS="${PHAGE_UV_16S_V2_ROOT}/inputs"
export PHAGE_UV_16S_V2_METADATA="${PHAGE_UV_16S_V2_ROOT}/metadata"
export PHAGE_UV_16S_V2_LOGS="${PHAGE_UV_16S_V2_ROOT}/logs"
export PHAGE_UV_16S_V2_CACHE="${PHAGE_UV_16S_V2_ROOT}/cache"
export PHAGE_UV_16S_V2_REPORTS="${PHAGE_UV_16S_V2_ROOT}/reports"
export PHAGE_UV_16S_V2_CYCLE_MODEL_DIR="${PHAGE_UV_16S_DERIVED}/10_cycle_models"

# Threads for this machine (8-core Apple M2, 16 GB). Override before sourcing.
: "${PHAGE_UV_16S_THREADS:=6}"
export PHAGE_UV_16S_THREADS

# Executed-parameter pin for the 12-sample REPRODUCTION.
#
# The v1 config defaults (279/235, pool = pseudo, nbases = 1e8) are NOT what
# produced the accepted return. The returned provenance table
# (09_return_package/16s_dada2_parameters.tsv, run 2026-09-02 10:56 UTC)
# records 279/200, pool = FALSE, learnErrors nbases = 5e7, seed 20260901; the
# 279/235 run was retained separately as 03_dada2_trunc279x235 for comparison.
# The reproduction must match the executed run, so the executed values are
# pinned here. Any full-depth or altered-parameter rerun must override these
# explicitly and is reported as a separate v2 variant, not a reproduction.
: "${PHAGE_UV_16S_TRUNC_LEN_R1:=279}"
: "${PHAGE_UV_16S_TRUNC_LEN_R2:=200}"
: "${PHAGE_UV_16S_POOL:=FALSE}"
: "${PHAGE_UV_16S_LEARN_NBASES:=5e7}"
export PHAGE_UV_16S_TRUNC_LEN_R1 PHAGE_UV_16S_TRUNC_LEN_R2 PHAGE_UV_16S_POOL PHAGE_UV_16S_LEARN_NBASES
# The GTDB cross-check exceeded memory in v1 and was not part of the accepted
# result; keep it off for the reproduction.
: "${PHAGE_UV_16S_GTDB_CROSSCHECK:=false}"
export PHAGE_UV_16S_GTDB_CROSSCHECK

# Inherit every denoising / taxonomy parameter and primer from v1 unchanged.
# Source from the repository root (as scripts/run_16s_pipeline.sh does), or
# set PHAGE_UV_REPO_ROOT. Written to work under both bash and zsh.
_v1_config="${PHAGE_UV_REPO_ROOT:-${PWD}}/config/16s_analysis_paths.sh"
if [[ ! -f "${_v1_config}" ]]; then
  printf '16S_v2: cannot find %s; source from the repository root\n' "${_v1_config}" >&2
  return 1 2>/dev/null || exit 1
fi
# shellcheck source=config/16s_analysis_paths.sh
source "${_v1_config}"
unset _v1_config

# Guard: refuse any output location that resolves into a protected v1 path.
# Substrings, not exact matches, so that any nesting under them is caught.
_protected=(
  "derived/16s_analysis"
  "derived/16s_manuscript_integration"
  "phage_uv_treatment/PRJEB79569"
  "OneDrive-nium.io"
  "incoming/16s_collaborator_return"
)
for _var in PHAGE_UV_16S_DERIVED PHAGE_UV_16S_RAW_DIR PHAGE_UV_16S_REFERENCE_DIR \
  PHAGE_UV_16S_V2_INPUTS PHAGE_UV_16S_V2_METADATA PHAGE_UV_16S_V2_LOGS \
  PHAGE_UV_16S_V2_CACHE PHAGE_UV_16S_V2_REPORTS; do
  eval "_value=\${${_var}}"
  for _p in "${_protected[@]}"; do
    if [[ "${_value}" == *"${_p}"* ]]; then
      printf '16S_v2 isolation violated: %s=%s resolves into protected location "%s"\n' \
        "${_var}" "${_value}" "${_p}" >&2
      return 1 2>/dev/null || exit 1
    fi
  done
done
unset _protected _var _value _p

export PHAGE_UV_16S_V2_ROOT PHAGE_UV_16S_V1_RETURN_COPY
