# Publication-size network and abundance figures S8/S9

Status: verified vector masters, inspected renders, verified uploads and native
suggested replacements in manuscript v2. Baseline `20260909T183055Z`; final
readback `20260909T183356Z`. Complete manuscript text/captions, all 15 image
IDs/order and 13 non-target image properties are unchanged. No suggestions
or comments were accepted or rejected. All 156 targeted checks pass; the 216
suggested text runs and ten original Zotero metadata names are preserved.

## Sources and reproducibility

```sh
bash scripts/run_qmd.sh scripts/build_host_phage_network_figure.qmd DATA_ROOT NEW_NETWORK_OUTPUT --publication-size
bash scripts/run_qmd.sh scripts/run_community_differential_abundance.qmd NEW_ABUNDANCE_OUTPUT --figure-only --publication-size
python tests/test_network_abundance_publication_figures.py NEW_NETWORK_OUTPUT NEW_ABUNDANCE_OUTPUT
```

S8: `derived/network_figure_publication_2026-09-09-v2/`.
S9: `derived/abundance_figure_publication_2026-09-09-v2/`.
Both retain archived source notebooks, input hashes and output checksums.
The network's four canonical tables and abundance analysis's nine tables are
byte-identical to their frozen originals. No models, ordinations or networks
were refitted. No new environment or dependencies were installed. Quarto
entrypoints remain canonical and old versions remain intact. Documentation
usage paragraphs were added to the working notebooks after the build; the
archived notebook hashes identify the exact executed versions.

The network remains 86 candidate links between 80 MAGs and 85 viral contigs;
49 linked hosts have supported adjusted membrane coefficients. Only 12 linked
viral representatives have current annotations and none pass the high-quality,
classified vOTU filter. The graphic does not establish infection, induction or
a treatment mechanism. The six labelled multi-candidate hosts and shared viral
candidate are unchanged.

S8 is 180 x 260 mm, with the network above separately stacked host/viral
summaries. Nodes, labels and legends are sized for this width; count labels
now sit clearly outside bar ends. S9 is 180 x 180 mm, retaining both MAG/vOTU
ordination and adjusted contrast panels. Cycle labels are dark and repelled
from points; the supported MAG label is dark with its original green point.
Phase names are consistently capitalized. All coefficients and positions are
unchanged. One membrane per condition remains the inferential boundary.

Both final renders were inspected. PDFs contain embedded fonts, minimum 6.5 pt
ordinary text, no raster objects and no text outside the page. Tests verify
source equality, required labels and counts, archived source hashes, input
hashes and every output checksum. The test checks rotated y-axis labels in raw
PDF character order as well as extracted reading order; no figure values were
changed to satisfy text extraction. Quarto and manuscript registry checks pass.

## Artifact identity and live previews

| Master | Bytes | SHA256 |
|---|---:|---|
| host-phage-network-evidence-audit.pdf | 117032 | `3a902481600c2256dae1e21d97bc7646eaa1339ef24be7cefe901fb391ceb5a7` |
| community-differential-abundance.pdf | 154352 | `84e4bd70209cd123506568406454ee0dcdf6d7935cc0ca716c827944b2af5007` |

2160-pixel-wide previews reside under the author-review root's
`figure_previews/s8-publication-v2.png` and `s9-publication-v2.png`.

| Figure | Drive ID | Bytes | Server MD5 |
|---|---|---:|---|
| S8 | `1AI4CVhMHZ1QO1rt-DAtL6ctgsxITruVp` | 431418 | `849af6ff0015c11093b61890bfb837a9` |
| S9 | `1ufkfwWbm0qT4LEnMX-ieQcjGAQuOoTCW` | 242827 | `d072be9162a3d2c69285d6ff0f97c840` |

Both uploads were independently read back for MD5, size and exact parent in
the established Figure previews folder. No sharing changes. Receipts are
`s8_publication_preview_upload_receipt.json` and
`s9_publication_preview_upload_receipt.json` under the author-review root.
Existing image IDs were retained; inherited crops reset and proportions
verified. S9's fully loaded rendering was confirmed in the Doc.

Aggregate audit v8 passes 14/15 current masters; S10 is the only remaining
final-size rebuild. Audit JSON: 17582 bytes, SHA256
`be7f5ee77dd86b07e21999eb16a6c770c08e206ebff8b1e163c50c13ccc4d93e`.
This is a provisional editorial size screen, not journal certification.
The released companion v2/source JSON and separate subway v11 remain untouched.
Next: S10, then versioned companion and the remaining editorial/scientific gates.
