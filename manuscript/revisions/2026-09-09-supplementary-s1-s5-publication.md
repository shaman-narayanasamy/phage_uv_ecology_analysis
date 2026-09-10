# Publication-size supplementary figures S1-S5

Status: verified local vector masters, Drive uploads and native suggested
Google Docs replacements. A new compiled companion is pending. Live readback
`20260909T180753Z` passes all 153 targeted checks against the immediate
pre-replacement baseline `20260909T180118Z`. The author unpaused the goal.

## Sources and scientific preservation

Canonical new notebook: `manuscript/supplementary_publication_figures.qmd`.
This is a visual-only builder with ordered debugging chunks. It reads five
frozen figure tables plus library normalization, interaction, omnibus and MAG
coherence results. It fits no models and does not touch earlier builders or
their outputs. The five frozen tables are copied byte-for-byte. A source
snapshot inside the output preserves the exact notebook used for this build.

S2's displayed points retain the original deterministic 20,000-feature context
sample per comparison and every supported feature: 1 cycle-2 coefficient hit,
11 cycle-3 hits and 357 omnibus hits. The test independently reconstructs their
IDs in source row order and compares every displayed logFC/logCPM/FDR value
with the original input. S4 rank counts are independently reconciled to the
eligible MAG table. These are system-specific, confounded comparisons, not
replicated treatment tests. Nothing here establishes direct DNA damage.

```sh
bash scripts/run_qmd.sh manuscript/supplementary_publication_figures.qmd NEW_OUTPUT
```

The output directory must not exist. No new environment or dependency was
installed. Input and output hashes are recorded; tests also verify the archived
notebook hash, dimensions, required labels, font embedding and vector content.

## Layout and visual checks

Current root: `derived/supplementary_figures_publication_2026-09-09-v2/`.
All five masters are 180 mm wide with minimum 6.5 pt ordinary text. S1-S5
heights are 165, 175, 240, 170 and 245 mm. S3 stacks its four coefficient
panels so full category names remain readable. S5 has five matrices in two
columns with a common scale, readable sample axes and two-line organism labels.

All five v1 full renders were visually inspected. V2 corrects S1's phase
legend order and capitalization; S1's final render was inspected. S2-S5 final
rendered PNGs are byte-identical to the inspected v1 PNGs. There is no clipping
or overlap requiring another revision in this pass. Publication size is an
editorial target, not journal-specific approval. Earlier versions are retained.

| Master filename | Bytes | SHA256 |
|---|---:|---|
| supplementary-cycle-interaction-landscape.pdf | 5411944 | `5b41184c9584b92469f69830d63acab6fe7c96b433c6adec22eae0c38cffb038` |
| supplementary-functional-coefficients.pdf | 24191 | `91e90a1eec7c4e7edfb896920e823796cb86b979036cff12b26f64f43475c298` |
| supplementary-mag-coherence.pdf | 112752 | `dd64750abfa1c9ddabec57c57eb898a587aaadfc3fb88f5e630c25da5626be56` |
| supplementary-model-diagnostics.pdf | 27454 | `6a5ceaeb8fc5f9a6ba2dadc7a48db4a624236ca5fbd8ecaf979209677b6ef0f0` |
| supplementary-population-genomics.pdf | 51175 | `6924430dba8d50387400b38d2aed2e0d321c8c22d76de5a3c20077ed92cfbce1` |

## Uploaded previews and verified native replacements

Each PNG is 2160 pixels wide and lives under the author-review root's
`figure_previews/sN-publication-v2.png`. All were uploaded to the established
Figure previews folder, with server MD5, bytes and parent rechecked. Sharing
was unchanged; no existing preview was overwritten. Receipts are
`sN_publication_preview_upload_receipt.json` under the author-review root.

| Figure | Drive file ID | PNG bytes |
|---|---|---:|
| S1 | `1gu7hz-9EKTbWBDyCw25o7dZIJLVfxy2x` | 152807 |
| S2 | `1vUakPyeQCsyXke_CZfMtHFkwhp4Q9cWp` | 652550 |
| S3 | `1aEm-RtEKTBgs_YBH9RAqh9tcMabYWw5d` | 283484 |
| S4 | `1qPGanckaoUdgcD9scYiUICz7IBOD_tuh` | 161095 |
| S5 | `1WjKCilMpJqKdt1m1JWMZ9sHCSL-88kwK` | 150311 |

The five existing images were replaced in native Suggesting mode and inherited
crops reset. Verified aspect ratios are 180/165, 180/175, 180/240, 180/170 and
180/245 within preview rounding. All 15 inline IDs/order, ten non-target image
properties and complete text/captions are unchanged. There are still 216
suggested text runs and ten original Zotero metadata names; no suggestions or
comments were accepted or rejected. S5's fully loaded rendering was confirmed.
The current companion v2 and its source JSON remain unchanged;
update that specification only with the next complete companion build.

Aggregate audit v6 screens the five main and five revised supplementary
masters successfully; S6-S10 still need rebuilding. The output inventory,
PDFs, PNGs, code and tests are manifest registered. The four delivery gates
(Zotero, visible line numbering, full figure suite and separate companion)
remain open.
