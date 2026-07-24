# inStrain Status, 2026-07-24

Live Iris check of the `community_uv_response` variant analysis showed that
inStrain has not completed to the point needed for manuscript SNV comparisons.

## Confirmed Paths

- Profile root:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain/profiles`
- Expected compare output:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain/compare/all_samples`
- Compare launcher:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/scripts/run_instrain_compare.sh`

## Status

- Profile directories exist for 12 biological sample IDs.
- No `profile.done` markers were found under the active profile root.
- No `compare.done` marker was found.
- No `instrain_compare_*` logs were found under `variant_analysis/logs`.
- No active Slurm jobs matching `instrain` or `mags_votu` were running.

## Profile Completeness

Most profile directories contained the expected core raw inStrain tables, but
two were incomplete at follow-up live inspection:

- `CBF2`: only minimal raw files and log, missing `covT.hd5`,
  `cumulative_scaffold_table.csv.gz`, `cumulative_snv_table.csv.gz`,
  `raw_linkage_table.csv.gz`, `raw_snp_table.csv.gz`, and scaffold SNV pickle/list.
- `TI2`: same incomplete pattern as `CBF2`.

`CBF1` has the core raw inStrain outputs on follow-up inspection, but still
lacks a `profile.done` marker. Treat it as data-present but not workflow-marked.

The fetched `instrain_profile_manifest.tsv` is therefore stale as a completion
indicator. It marks 12 rows as `ready`, but that readiness appears to mean
input/profile-path readiness, not completed inStrain profile outputs.

## Next Step

Do not keep increasing memory on the current MAG+vOTU-wide command. The active
workflow profiled against `mags_votu.fasta` (3.7 GB, 1,749,137 records), whereas
the manuscript SNV question only requires microbial rMAGs.

Rerun or repair inStrain using a scoped rMAG-only or prioritized-rMAG scaffold
set, with `--database_mode`, `--skip_plot_generation`, `--scaffolds_to_profile`,
and an STB file. Create `profile.done` markers only after core raw profile
tables exist. After all selected profiles are complete, launch
`run_instrain_compare.sh` or an equivalent scoped compare and parse the compare
table through `community_uv_response/scripts/parse_instrain_compare.py`.

## Scoped Repair Attempt

Generated priority rMAG inputs on Iris:

- Priority MAG table:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain/priority_mag_inputs/priority_mags.tsv`
- Scaffold list:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain/priority_mag_inputs/priority_mag_scaffolds.txt`
- STB file:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain/priority_mag_inputs/priority_mag_scaffolds.stb`

The first scoped smoke run was submitted for `CBF2`, because it is one of the
two genuinely incomplete profiles from the broad MAG+vOTU run.

- Slurm job: `5555249`
- Launcher:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/launchers/priority20_profile_smoke.sbatch`
- Output root:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20`
- Expected PASS sentinel:
  `/scratch/users/snarayanasamy/phage_uv_treatment/output/PRJEB79569/community_uv_response/variant_analysis/instrain_priority_20/logs/CBF2_profile_smoke_5555249.PASS`

Do not launch all-sample scoped inStrain until this smoke run passes and the
core `CBF2/raw_data/` outputs validate.
