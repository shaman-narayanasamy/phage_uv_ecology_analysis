# Handoff: receipt audit for the collaborator-owned 16S return

Date: 2026-09-04. Direction: Gmail and collaborator branch to manuscript
integration stream. This supersedes any statement that the 16S analysis is
still missing or blocked.

## What was received

Susana Martinez Arbas sent two messages to `shaman.qn@gmail.com` on 2026-09-03:

- `UV-phage 16S data analysis`, from `susana@nium.bio`, containing the complete
  scientific return summary and reporting that the analysis was committed;
- a Microsoft 365 sharing notification for the recipient-only SharePoint folder
  `2026_09_13_phage_uv_data_16S_analysis`.

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

These are collaborator-reported values until the checksum-addressed data
package is relocated to the canonical project data root and verified locally.

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

The return is **received, not yet accepted as locally verified manuscript
evidence**. Do not describe it as missing, blocked, or still awaiting the
collaborator. Do not rerun or take ownership away from the collaborator.

Pending integration checks:

1. Authenticate to the recipient-only SharePoint folder and inventory the
   actual return package. The Gmail-linked page currently requires Microsoft
   sign-in.
2. Resolve the return-count discrepancy: the Gmail summary and collaborator
   handoff say 25 files, while `docs/16s_manuscript_integration.md` says 26.
3. Copy the package into the canonical project data root, verify every supplied
   checksum, and replace Susana's machine-local paths in the manifest.
4. Compare all 12 sample identifiers with `metadata/sample_metadata.tsv` and
   reproduce the headline tables from the flat exports.
5. Integrate the collaborator branch without overwriting the current Figure 1,
   manuscript allocation, audit, or Google Docs editorial state.

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
