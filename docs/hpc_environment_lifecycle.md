# HPC Environment And Temporary-File Lifecycle

This project previously accumulated more than 115,000 unnecessary filesystem
entries under its Iris scratch tree. The software was not intrinsically broken:
the accumulation came from storing several complete Conda environment families
in project scratch and retaining job-temporary SpacePHARER output.

## Hard Rules

1. Do not create Conda or Mamba prefixes anywhere below
   `/scratch/users/snarayanasamy/phage_uv_treatment`.
2. Snakemake-managed rule environments must use
   `/work/projects/bioinformatics_platform/cache/conda` through
   `--conda-prefix`.
3. Prefer versioned Apptainer SIF images on persistent Isilon for stable tools
   when the workflow supports them. A SIF avoids the large inode cost of an
   unpacked Conda prefix.
4. Every manually managed environment must have a persistent explicit package
   specification or lock file outside scratch before it is considered
   reproducible.
5. Job-temporary data must live in a job-scoped temporary directory and be
   removed after successful completion. Use Snakemake `temp()` for true
   intermediates; do not routinely launch with `--notemp`.
6. A workflow is not complete until its temporary directories and unused
   environments have been inventoried. Preserve results and reproducibility
   records; do not retain replaceable software trees by default.

These rules apply to agents and interactive users. A manual command such as
`mamba create -p /scratch/...` is prohibited for this project even if it is
technically valid Conda usage.

## Why The Pile-Up Happened

Conda environments are directory trees containing the selected program and all
of its dependencies. The old `inStrain` prefix therefore contained about
25,000 entries even though it represented one top-level analysis tool. The
project also mixed manually named environments, three separate viromics
environments, a CAT/BAT environment, and seven Snakemake hash-named
environments. Snakemake retains reusable environments unless they are cleaned,
and a package cache on another filesystem cannot provide the same inode-saving
hard-link behavior as a co-located cache.

Separately, the host-phage workflow produced per-MAG SpacePHARER temporary
trees while its cleanup commands were commented out. Those trees contributed
about 37,000 more project entries.

## Cleanup And Recovery Record: 2026-08-04

Before cleanup, the project scratch tree contained 259,420 entries. The cleanup
removed the inactive `inStrain` environment, seven reproducible Snakemake
hash-named environments, and the SpacePHARER temporary tree. It preserved all
scientific outputs and reduced the project tree to 143,575 entries. The user's
Lustre inode count fell from 715,215 to 599,629.

Recreation records were exported and checksum-verified at:

`/mnt/isilon/projects/bioinformatics_platform/projects/shared_references/scratch_archives/snarayanasamy/phage_uv_treatment_20260726_full_output/environment_specs_20260804`

That directory includes explicit package specifications, Conda histories,
Snakemake YAML definitions, and `SHA256SUMS`.

The following environments were deliberately retained pending a separate
keep-or-rebuild decision:

- `conda/viromics_db_envs/checkv`
- `conda/viromics_db_envs/vcontact3`
- `conda/viromics_db_envs/cenotetaker3`
- `conda/catbat_db_tools`

Do not delete these retained environments without explicit authorization.

## Verification

Run the repository validator before any HPC launch:

```sh
bash scripts/validate_manifests.sh
```

The validator rejects launcher or configuration files that set a Conda prefix
inside this project's scratch tree and verifies that both preprocessing
launchers use the shared Conda prefix.
