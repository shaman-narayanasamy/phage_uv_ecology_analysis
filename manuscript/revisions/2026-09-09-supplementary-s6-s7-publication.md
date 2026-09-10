# Publication-size taxonomy figures S6 and S7

Status: visually inspected vector masters, checksum-verified uploads and
native suggested replacements in manuscript v2. Baseline live readback:
`20260909T181933Z`; post-replacement readback: `20260909T182253Z`.
Complete manuscript text, all 15 inline image IDs/order and 13 non-target
images remain unchanged. Both captions remain immediately below their images.
No suggestions or comments were accepted or rejected.

## Reproduce and verify

```sh
bash scripts/run_qmd.sh scripts/build_taxonomic_context_figures.qmd NEW_OUTPUT --publication-size
Rscript tests/test_taxonomic_context_revision.R NEW_OUTPUT
python tests/test_taxonomic_publication_figures.py NEW_OUTPUT
```

Current root: `derived/taxonomic_figures_publication_2026-09-09-v3/`.
The existing Quarto entrypoint has an explicit display-only publication mode,
with a new output directory required. Earlier default behavior and versions
are preserved. All eight frozen tables and both Newick trees are byte-identical
to `taxonomic_context_revision_2026-09-09-v2`. Ten input hashes and an archived
notebook snapshot are recorded. No models were fitted. No new environment or
dependency was installed. The existing Quartz device embeds fonts on macOS.

S6 is 180 x 250 mm. The 348-MAG taxonomy-derived tree retains completeness and
contamination as its first two rings, followed by adjusted coherence and
recurrence. The lower panel preserves Figure 1's exact top-25 family values,
full denominator, shared microshades and aligned control/phage-UV positions.

S7 is 180 x 230 mm. The same 45 taxonomy groups contain the same 607 filtered
vOTUs. All 18 previously selected labels remain; horizontal repelled labels
replace rotated text. White label backgrounds improve contrast against tree
branches. Realm counts and the taxonomy-derived topology are unchanged.
These are not sequence phylogenies or replicated treatment tests.

Both PDFs contain embedded fonts, minimum 6.5 pt ordinary text, no raster
objects and no out-of-page text. V3 renders were inspected (S6's render is
byte-identical to inspected v2). Source/geometry tests, Quarto entrypoint
checks and manuscript registries pass. Font-size checks do not by themselves
establish scientific or editorial acceptance.

## Artifact identity

| Artifact | Bytes | SHA256 |
|---|---:|---|
| mag-taxonomic-context.pdf | 266454 | `6c092f7e3beb01a00d550d9c4694dd19a88d9b8f281c9ac6d944e5958e3c41f7` |
| votu-taxonomic-context.pdf | 62496 | `47f5af7f67a97f234ba6123bbd7c819733f056fca013233cfc7a4e5f991ef7e1` |
| output_checksums.md5.tsv | 1306 | `a6722c4f85febe8449e8e365e1d64fde95002d638efb17af20a0b58b5b528f50` |

Previews are 2160 px wide under the author-review root's `figure_previews/`.
The existing Figure previews folder and all permissions are unchanged.

| Figure | PNG | Drive ID | Bytes | Server MD5 |
|---|---|---|---:|---|
| S6 | s6-publication-v3.png | `1uo7B2ATlJ88LguVTOojY9O_iSHfTc7rg` | 1004344 | `a14c9e4de8e325acfbc50a0e49544d10` |
| S7 | s7-publication-v3.png | `1FC8MGkZP5EAwvir4sDgjFARh3zMsPfe9` | 346147 | `5ac839e4c51799d1636346fb4bf4907c` |

Receipts: `s6_publication_preview_upload_receipt.json` and
`s7_publication_preview_upload_receipt.json`. Both uploads were read back and
verified by MD5, byte count and exact parent. Native replacement retained the
existing objects and reset their inherited crops. S7's fully loaded image was
visually confirmed in the Doc.

Aggregate audit v7 now passes Figures 1-5 and S1-S7 at the provisional 180 mm
width. S8-S10 remain below the minimum text screen. Audit JSON: 17,900 bytes,
SHA256 `0f0ea32769fd7d08cff878383e8af2af38509c034f178c636f517ea1d3a2ab36`.
The released companion v2 and its source specification remain unchanged until
all remaining figures are rebuilt into a new companion. The subway v11 draft
is untouched. Zotero live fields, visibly verified line numbers and the wider
scientific/editorial gates remain open.
