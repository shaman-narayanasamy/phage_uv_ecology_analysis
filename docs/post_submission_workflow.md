# Post-submission responsibilities and response-to-review workflow

Applies to the Frontiers in Microbiomes submission of 2026-11-24 (see
`notes/handoff-2026-11-24-frontiers-submitted.md`).

## Frozen record

- The submitted files are frozen by their SHA-256 in the bundle's
  `release_2026-11-24/submission_release_manifest.tsv`. Never edit them in place.
- Every change after submission is a revision: new dated files, a new manifest, a new named Google
  Doc version. Do not start a new submission while this one is under review; withdrawal or
  resubmission elsewhere is the corresponding author's decision.

## Who does what

| Responsibility | Owner |
|---|---|
| Watch Frontiers email and the review forum; meet response deadlines | SN (corresponding author) |
| Accept, reject or discuss reviewer points | SN, with SMA |
| Draft responses and manuscript changes | agent, as tracked suggestions in the live Google Doc (Codex Assistant identity, per `AGENTS.md`) |
| Analyses requested by reviewers | agent, only after SN approves each one; no refits or new statistics without explicit approval |
| Article processing charge | SN; funding route (e.g. FNR Open Access Fund via SMA's fellowship) to be settled before acceptance |

## Response to review

1. Save each decision letter and reviewer report, unchanged, in the bundle under
   `review_round_<n>/`.
2. Make a point-by-point table: reviewer, point, verbatim text, proposed response, manuscript change,
   new analysis needed (yes or no), owner, status.
3. Discuss substantive points with SN before drafting; draft agreed changes as tracked suggestions in
   the Google Doc; reply in the matching comment thread with the decision and verification status.
4. Any new or changed result follows the provenance rules in `docs/manuscript_exclusion_register.md`
   and `docs/expression_quarantine.md`.
5. Export the revised manuscript from the Google Doc (DOCX, then PDF), rebuild changed figures or
   tables, write a new manifest with `scripts/build_submission_release_manifest.sh`, and draft the
   response letter in SN's voice.
6. SN uploads or approves the upload and presses submit. Name the Google Doc version and record the
   round in a new handoff note.

## Known items to raise at revision

- Supplementary Table S14 was split for the 30 MB limit; if the editor objects, trim it or deposit
  it on Zenodo and cite the DOI in the Data availability statement.
- If the FNR Open Access Fund pays the fee, add FNR's rights-retention sentence to the
  acknowledgement.
