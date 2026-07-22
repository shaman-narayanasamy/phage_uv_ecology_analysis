# HPC Job Agent Protocol

This project has long-running HPC jobs. Agent sessions must not burn time and
tokens repeatedly polling Slurm without making decisions. The correct pattern is
event-oriented: submit with clear sentinels, inspect only useful state, and
react to completion or failure.

## Non-Negotiable Rules

- Do not poll `squeue` in tight loops.
- Do not keep asking whether a job is done without checking the job's log,
  sentinel files, and expected outputs.
- Do not treat a completed job as success until expected output files exist and
  pass a minimal validation check.
- Do not silently continue after a failed job. Inspect stderr/logs, identify the
  failing rule or command, and either fix it or write a blocker report.
- Do not submit broad full-scale jobs before a dry-run and a small smoke test
  have passed.

## Required Job Wrapper Shape

Each long-running job should write:

- a wrapper script copied into `logs/` or `launchers/rendered/`;
- stdout and stderr paths;
- a `*.started` sentinel with timestamp, hostname, cwd, branch, and commit;
- a `*.exitcode` file;
- either `*.PASS` or `*.FAIL`;
- a small final summary file with expected output checks.

Use a shell trap, for example:

```sh
set -euo pipefail
status_file="logs/my_job_$(date +%Y%m%d_%H%M%S)"
trap 'code=$?; echo "$code" > "${status_file}.exitcode"; if [ "$code" -eq 0 ]; then touch "${status_file}.PASS"; else touch "${status_file}.FAIL"; fi' EXIT
```

## Monitoring Cadence

Default monitoring cadence:

- Immediately after submission: record job ID, paths, and expected outputs.
- Next check: inspect logs/sentinels only after a useful interval, such as 30 to
  60 minutes for heavy jobs, unless the scheduler reports immediate failure.
- If the user wants asynchronous notification, write a lightweight check command
  or issue comment, not a polling loop.

## Completion Reaction

When a job completes:

1. Read the exit code.
2. Read the final 100 to 200 log lines.
3. Check expected output files exist and are non-empty.
4. Run a cheap domain validation:
   - row counts for tables,
   - expected sample IDs,
   - expected MAG/vOTU IDs,
   - checksums for staged files where practical.
5. Report to the user:
   - success/failure,
   - output paths,
   - validation summary,
   - recommended next step.

## Failure Reaction

When a job fails:

1. Identify the first real error from stderr/logs.
2. Identify whether the failure is:
   - input missing,
   - environment/module problem,
   - resource limit,
   - workflow bug,
   - transient cluster issue.
3. If it is fixable without changing scientific intent, patch and rerun the
   smallest failing step.
4. If it requires a decision or missing data path, create/update a GitHub issue
   and tell the user exactly what is blocked.

## GitHub Tracking

For this project, every long-running HPC job should have one of:

- a GitHub issue tracking the run, or
- a PR comment on the active analysis PR.

The issue/comment must include:

- command submitted,
- job ID,
- output root,
- sentinel/log paths,
- expected output files,
- validation command to run when complete.

This is how local Codex and HPC Codex hand off without chat context.
