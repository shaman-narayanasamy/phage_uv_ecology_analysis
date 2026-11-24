# Repository agent guidance

## Mandatory provenance quarantine

Before choosing manuscript, supplementary, figure or factsheet inputs, read
`docs/manuscript_exclusion_register.md` and `docs/expression_quarantine.md`.
Their exclusions override old manifests, handoffs and cached figure allocations.
Do not reactivate excluded results without a new explicit author decision.
Preserve source files and mixed-folder active/provenance inputs.

## Manuscript editor identity — mandatory

Google Docs manuscript writes must be attributed to the dedicated Codex Assistant Google account (address recorded privately in `notes/handoff-2026-09-21-assistant-identity.md`, which is not in git).
Never edit as the author's personal account or use it as a fallback. Before OAuth,
select the assistant identity; before each write batch, verify the authenticated
identity on the actual write connection. Wrong or unverifiable identity blocks writes.
Keep assistant credentials separate from the author's credentials.

### Author-reviewed manuscript: suggestions only

The author is the decision-maker. Every proposed text change to the live
manuscript must be a tracked suggestion attributed to Codex Assistant. A separate
account does not make direct API replacements acceptable. Do not use
documents.batchUpdate text replacement for manuscript prose or captions; use
verified browser Suggesting mode and confirm suggestion insertion/deletion records.
Never accept or reject the author's suggestions without explicit instruction.
After addressing a comment, reply in that same document thread with the agreed
decision, what was suggested, and verification status. Backfill discussed items
when needed. Leave comment resolution and suggestion acceptance to the author.
Move directly to discussing the next comment after completing an agreed item;
do not wait for another prompt, but discuss substantive changes before applying.
Direct recovery is allowed only for the exact changes the author has authorised
reverting, with an intervening-edit check and revision lock.

Follow the canonical SOP:
`/Users/shaman.narayanasamy/Work/knowledgebase/sops/google-docs-live-document-editing.md`
(section “Mandatory gate: verify the assistant identity before authorisation and writes”).
Preserve the author's current text, comments, suggestions and Zotero fields; never
replace the live manuscript from an older local draft. The local import and image
upload tools enforce this through `scripts/manuscript_identity.py`; six offline
tests cover wrong/missing/unverified identity, network failure, account switching,
same-token verification and absent assistant credentials. Other write surfaces,
including MCP and browser edits, must establish their own verified identity;
these tests do not certify those connections.

## Agent skills

### Issue tracker

Work for this repository is tracked in GitHub Issues at `shaman-narayanasamy/phage_uv_ecology_analysis`. See `docs/agents/issue-tracker.md`.

### Triage labels

Use the repository's five canonical workflow labels. See `docs/agents/triage-labels.md`.

### Domain docs

This is a single-context scientific project. Read the repository context, current scientific handoff, and relevant decision records before changing analyses or manuscript claims. See `docs/agents/domain.md`.
