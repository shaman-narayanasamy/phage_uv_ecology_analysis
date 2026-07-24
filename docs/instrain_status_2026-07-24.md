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
three were incomplete at live inspection:

- `CBF1`: only minimal raw files and log, missing `covT.hd5`,
  `cumulative_scaffold_table.csv.gz`, `cumulative_snv_table.csv.gz`,
  `raw_linkage_table.csv.gz`, `raw_snp_table.csv.gz`, and scaffold SNV pickle/list.
- `CBF2`: same incomplete pattern as `CBF1`.
- `TI2`: same incomplete pattern as `CBF1`.

The fetched `instrain_profile_manifest.tsv` is therefore stale as a completion
indicator. It marks 12 rows as `ready`, but that readiness appears to mean
input/profile-path readiness, not completed inStrain profile outputs.

## Next Step

Rerun or repair inStrain profiles for `CBF1`, `CBF2`, and `TI2`, then create
`profile.done` markers only after core raw profile tables exist. After all 12
profiles are complete, launch `run_instrain_compare.sh` and parse the compare
table through `community_uv_response/scripts/parse_instrain_compare.py`.
