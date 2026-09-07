# Handoff: receipt audit for the collaborator-owned 16S return

Date: 2026-09-04. Direction: Gmail and collaborator branch to manuscript
integration stream. This supersedes any statement that the 16S analysis is
still missing or blocked.

## What was received

Susana Martinez Arbas sent two messages to `shaman.qn@gmail.com` on 2026-09-03:

- `UV-phage 16S data analysis`, from `susana@nium.bio`, containing the complete
  scientific return summary and reporting that the analysis was committed;
- a Microsoft 365 sharing notification for the recipient-only SharePoint folder
  `2026_09_03_phage_uv_data_16S_analysis`.

Susana sent a replacement OneDrive invitation on 2026-09-07. The user
downloaded `PRJEB79569.zip`; an independent download through the replacement
invitation produced the same 72-file tree byte-for-byte.

The repository now has `origin/feature/prjeb79569-16s-analysis`, ending at
`b6acbe5`. The return is represented by commits `5f70997`, `12e4bf5`, and
`b6acbe5`, on top of the collaborator workflow commits. The branch includes the
16S protocol, DADA2 and taxonomy notebooks, ecology and candidate-figure
notebooks, return-package tooling, tests, a scientific return handoff, and a
manuscript-integration guide.

## Reported result

- 12 physical samples and 2,700 ASVs assigned with SILVA 138.2 at minimum
  bootstrap 80.
- Cleaning cycle was the dominant community term: Bray-Curtis R2 = 0.606 and
  Aitchison R2 = 0.447, both p = 0.0001.
- Phase was smaller: Bray-Curtis R2 = 0.138, p = 0.0058; Aitchison R2 = 0.105,
  p = 0.053.
- The membrane condition contrast was small and unsupported: Bray-Curtis
  R2 = 0.032, p = 0.435; Aitchison R2 = 0.065, p = 0.197.
- All reported dispersion tests were non-significant. Observed richness was
  429 to 732 ASVs and Shannon diversity 3.55 to 5.44.
- The measured primer-free ASV mode was 376 bp, corresponding to an amplicon of
  about 415 bp with primers, not the approximately 550 bp stated previously.

The flat exports and return package are now locally available. The reported
inferential p-values remain subject to the statistical-design audit below.

### Statistical-design audit finding

The collaborator notebook currently calls
`adonis2(d ~ cycle + phase + condition, permutations = 9999, by = "margin")`
and `permutest(..., permutations = 9999)` without blocks or a restricted
permutation design. This does not encode that the six observations within each
condition come from the same physical membrane. The reported ordinations,
descriptive effect sizes, and diversity estimates remain reviewable, but the
PERMANOVA and dispersion p-values are not accepted as manuscript-ready until
the permutation design is justified or replaced with a design-aware analysis.
In particular, no permutation procedure can manufacture independent
replication for the condition term when condition and membrane are identical.

## Scientific and technical boundaries

- One membrane represents each condition. Condition is inseparable from
  membrane identity and repeated samples are temporal observations, not
  biological replicates.
- The 16S libraries are cDNA-derived and represent a putatively active
  community, not a total-DNA community.
- Reads were subsampled to 150,000 pairs per sample before denoising. A
  full-depth ULHPC rerun is recommended for the published version.
- SILVA 138.2 is the executed taxonomy. The GTDB r220 cross-check was not run
  because it exceeded available memory.
- Genus-level claims are not supportable: 1,941 of 2,700 ASVs were reportedly
  unassigned at genus.
- No per-ASV differential-abundance test was run, appropriately avoiding a
  pseudo-replicated condition contrast.

## Integration status

The return is **received and locally copied, with one internal manifest
exception and the statistical-design audit still open**. Do not describe it as
missing, blocked, or still awaiting the collaborator. Do not rerun or take
ownership away from the collaborator.

The user-downloaded ZIP is preserved at
`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/incoming/16s_collaborator_return_2026-09-07/PRJEB79569.zip`
(7,968,690 bytes; SHA-256
`dc48c073caa5d16f79bc475b09b9fbf85b4153e0c6c43668007ca2a743b1307a`).
It passes `unzip -t`. Its 72-file extracted tree is byte-identical to the
independent OneDrive download and has been promoted to
`/Users/shaman.narayanasamy/Work/data/phage_uv_treatment/PRJEB79569/derived/16s_analysis/`.

The supplied return-package manifest has 25 payload rows. Twenty-four match
their received files by byte count and MD5. The sole exception is
`16s_return_summary.md`: the manifest records 6,266 bytes and MD5
`a762a6277270b811636388fe353911c5`, while both independent downloads contain
the same 6,332-byte file with MD5 `8dc495f02eb743865b33ecdd3facb005`.
Because both downloads agree and both ZIPs pass integrity testing, this is a
stale collaborator manifest row, not evidence of transfer corruption.

Pending integration checks:

1. Ask the collaborator to regenerate or explicitly confirm the stale
   `16s_return_summary.md` manifest row; do not modify her supplied manifest in
   place.
2. Resolve the documentation wording: the return manifest contains 25 payload
   rows, while `docs/16s_manuscript_integration.md` describes 26 files.
3. Replace or supplement Susana's machine-local paths with canonical project
   paths without altering the preserved received package.
4. Reproduce the headline inferential tables from the flat exports after a
   defensible repeated-observation analysis has been selected.
5. Audit and correct the unrestricted PERMANOVA and dispersion permutation
   scheme for the repeated two-membrane design; retain descriptive effect sizes
   even if valid inferential p-values cannot be obtained.
6. Integrate the collaborator branch without overwriting the current Figure 1,
   manuscript allocation, audit, or Google Docs editorial state.

## Local descriptive integration completed on 2026-09-07

`scripts/integrate_16s_and_workflow.qmd` verifies that all 12 returned sample
identifiers and their condition, phase, and cycle fields match
`metadata/sample_metadata.tsv`. It computes exact Bray-Curtis turnover directly
from the unrarefied ASV count table and produces two visually verified,
unnumbered vector candidates under
`PRJEB79569/derived/16s_manuscript_integration/`:

- `16s-longitudinal-community-context.pdf`, containing aligned stacked family
  profiles, directed Bray-Curtis trajectories, alpha-diversity trajectories,
  and consecutive-cycle turnover;
- `study-analysis-workflow.pdf`, connecting the experimental design and all
  three sequencing layers to the current evidence products and limitations.

All four membrane-by-phase trajectories have lower C2-to-C3 than C1-to-C2
Bray-Curtis turnover. With only two membranes and three cycles, this is a
descriptive recurrent pattern, not a replicated time-series or treatment
effect. The collaborator's PERMANOVA R-squared values are retained in a
separate effect-size audit, while the unrestricted p-values remain excluded
from manuscript inference.

## Provisional manuscript placement

The result corroborates the existing community story rather than establishing
a treatment-associated community shift. The current author decision remains:
Figure 1 describes the community. After local verification, the most coherent
allocation is to fold the 16S composition and/or Bray-Curtis ordination into
Figure 1 and place alpha diversity plus Aitchison sensitivity in the
supplement. The 16S result does not receive a separately reserved Figure 5.

Do not edit the live Google Doc during this receipt audit. Once evidence is
verified, manuscript proposals should be supplied as comments prefixed
`Codex:` so they remain distinguishable from the author's tracked changes.
