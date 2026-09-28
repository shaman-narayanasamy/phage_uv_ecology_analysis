#!/usr/bin/env bash
set -euo pipefail

REPO="/mnt/aiongpfs/users/snarayanasamy/repositories/phage_uv_ecology_analysis"
HPC_SITE="${HPC_SITE:-iris}"
ANNOTATION_LAUNCHER="${ANNOTATION_LAUNCHER:-launchers/sbatch_annotation_${HPC_SITE}.sh}"
cd "$REPO"

mkdir -p logs
WATCH_LOG="$REPO/logs/annotation_after_binning_watch_$(date +%Y%m%d_%H%M%S).log"
exec >> "$WATCH_LOG" 2>&1

DEREP_DIR="/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/binning/dereplication/dereplicated_genomes"
ANNOTATION_DONE="/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/annotation/annotation.done"

echo "[$(date --iso-8601=seconds)] Watching for dereplicated genomes in $DEREP_DIR"

while true; do
  if [[ -f "$ANNOTATION_DONE" ]]; then
    echo "[$(date --iso-8601=seconds)] Annotation already complete: $ANNOTATION_DONE"
    exit 0
  fi

  bin_count=0
  if [[ -d "$DEREP_DIR" ]]; then
    bin_count=$(find "$DEREP_DIR" -maxdepth 1 -type f \( -name '*.fasta' -o -name '*.fa' -o -name '*.fna' \) | wc -l)
  fi

  binning_running=0
  if pgrep -af 'snakemake .*PRJEB79569_binning_.*_config.yml|sbatch_binning.sh' >/dev/null; then
    binning_running=1
  fi

  echo "[$(date --iso-8601=seconds)] dereplicated_genomes=$bin_count binning_running=$binning_running"

  if [[ "$bin_count" -gt 0 && "$binning_running" -eq 0 ]]; then
    break
  fi

  sleep 600
done

echo "[$(date --iso-8601=seconds)] Dereplicated genomes are present and binning is no longer running."

DRY_LOG="$REPO/logs/annotation_dry_run_$(date +%Y%m%d_%H%M%S).log"
echo "[$(date --iso-8601=seconds)] Running annotation dry-run with $ANNOTATION_LAUNCHER: $DRY_LOG"
if ! bash "$ANNOTATION_LAUNCHER" --dry-run > "$DRY_LOG" 2>&1; then
  echo "[$(date --iso-8601=seconds)] Annotation dry-run failed. See $DRY_LOG"
  exit 1
fi

ANNOTATION_LOG="$REPO/logs/annotation_launch_$(date +%Y%m%d_%H%M%S).log"
echo "[$(date --iso-8601=seconds)] Launching annotation with $ANNOTATION_LAUNCHER: $ANNOTATION_LOG"
setsid bash -lc "cd '$REPO' && bash '$ANNOTATION_LAUNCHER' > '$ANNOTATION_LOG' 2>&1" < /dev/null &
echo "[$(date --iso-8601=seconds)] Annotation controller PID: $!"
echo "[$(date --iso-8601=seconds)] Watcher complete."
