# Branch overview and repository checkpoint

Scope: `shaman-narayanasamy/phage_uv_ecology_analysis` (private).
Remote refs refreshed on 2026-09-10. Comparison base is the pre-checkpoint
analysis HEAD `044cfcf`; counts below are historical, not a moving HEAD.

| Branch | Tip at inspection | Relationship to 044cfcf | Purpose/state |
| --- | --- | --- | --- |
| `feature/prjeb79569-cluster-analysis-ingest` | `044cfcf` | Current local and remote branch matched | Main analysis/manuscript work; open PR #18 into dev |
| `docs/susana-16s-v2-handoff-20260909` | `e1c5821` | One commit ahead | Remote-only collaborator handoff; four added documentation files |
| `feature/prjeb79569-16s-analysis` | `b6acbe5` | Diverged: 13 analysis-only, 6 branch-only commits | Remote-only 16S collaborator analysis |
| `feature/prjeb79569-assemblies` | `ef60695` | Diverged: 55 analysis-only, 12 branch-only commits | Remote-only assembly/HPC branch |
| `feature/initial-analysis-scaffold` | `551ae37` remote | Ancestor, 56 commits behind | Local copy `0edc71c` is three commits behind its remote |
| `dev` | `b17b929` | Ancestor, 55 commits behind | Local and remote match; PR integration target |
| `main` | `c30376a` | Ancestor, 60 commits behind | Local and remote match; repository default |

No branches were merged, rebased, deleted or force-pushed. Only one local
worktree was registered, on the current analysis branch. This does not prove
that no other machine or agent has another checkout.

## Parallel work and checkpoint boundaries

The schematic notebook `manuscript/build_schematic_figures.qmd` and the seven
files in `manuscript/figure_sources/` were newly untracked in this same checkout.
They contain the other workflow/setup figure work, not a separate local branch.
The user explicitly requested committing everything; preserve these unchanged
in a separate draft-source commit. Versioning a draft does not approve the
metro v11 or promote it into the accepted figure inventory. Do not rerender or
rewrite the parallel agent's sources as part of this checkpoint.

The remote Susana handoff commit adds:

- `manuscript/literature_citation_handoff.md`
- `notes/handoff-2026-09-09-16s-v2-isolated.md`
- `notes/handoff-2026-09-09-cycle0-16s-extension.md`
- `notes/handoff-2026-09-09-susana-16s-v2-start-here.md`

Those files are not merged into the current branch by this operation. Refresh
and read that branch when resuming collaborator work; do not infer analysis
completion or take over the collaborator's scope from its title alone.

## Verification and push boundary

Before committing: whitespace checks, the 25-entry Quarto test, reference and
manuscript registry tests passed. Python sources/chunks and the schematic R
chunk were syntax-checked; all five SVG sources parsed as XML. No analyses or
figure renders were rerun. The targeted credential-pattern scan returned no
matches. Generated analysis data and derived PDFs remain outside this code
repository; ignored logs, caches and local settings are not staged.

Existing PR: <https://github.com/shaman-narayanasamy/phage_uv_ecology_analysis/pull/18>.
The KB version-control SOP requires flagging an existing open PR before a push
changes it. Local commits may be created now; pushing is held pending the
author's confirmation to update PR #18. No new PR is requested or created.

For parallel development, a separate branch AND worktree is safer than two
agents editing this same checkout. This note recommends that separation; it
does not switch or move the other agent's work.
