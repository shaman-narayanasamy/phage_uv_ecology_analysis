# Domain documentation

This repository is a single-context scientific project.

## Read before acting

1. `docs/codex_context.md` for the current project boundary.
2. The newest relevant handoff under `notes/`; prefer topic-specific handoffs over older general ones.
3. `manuscript/claim_evidence_registry.tsv` and `manuscript/analysis_registry.tsv` before changing manuscript claims.
4. Relevant files under `docs/` for statistical, figure, population-genomic, or expression-analysis decisions.
5. Root `CONTEXT.md` and relevant `docs/adr/` records if they exist in the future.

## Knowledgebase boundary

The author's personal knowledgebase remains the canonical source for private scientific context, writing voice, and cross-project operating procedures. Repository-local documentation provides only the context required to reproduce, review, and continue this project. Do not copy private knowledgebase material into public-facing text unless the author explicitly approves it.

## Scientific guardrails

- The design has one membrane per condition; condition and membrane identity are inseparable.
- Repeated phase-by-cycle observations are temporal observations, not independent biological replicates.
- Full transcriptome-wide differential expression is the inferential analysis; subset-first analyses remain quarantined as exploratory checks.
- Population-genomic findings are descriptive and coverage-qualified unless independent support is added.
- The delegated 16S analysis is an integration stream, not an invitation to rerun or take over the collaborator's work.
