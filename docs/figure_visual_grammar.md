# Figure visual grammar

This registry applies to every candidate, main-text, and supplementary figure.
Candidate plots remain unnumbered until the manuscript argument is known.

The executable mappings are in `R/figure_style.R`.

## Primary rule

Each visual channel has one meaning within a panel. Condition has first claim on
colour:

- control: pastel green, `#8FCB8A`
- phage-UV treatment: UV violet, `#7E57C2`

The phage-UV treatment mapping is fixed across the entire manuscript. A functional or
taxonomic palette may own colour in a panel only when condition is separated by
facets, position, or another unambiguous encoding.

## Stable encodings

| Factor | Default encoding | Reason |
|---|---|---|
| condition | colour and fill | Primary experimental contrast |
| phase | point shape | Avoids competing with condition colour |
| cycle | ordered position; linetype only when needed | Cycle is ordered, not nominal |
| microbial taxonomy | phylum colour strip or swatch | Stable identity across plots without assigning a colour to every MAG |
| viral taxonomy | realm colour strip or swatch | Realm is the most stable useful viral rank |
| UV-response category | category colour | Useful in functional composition plots |
| UV tier | order, facet, or symbol | Tier is ordinal and should not compete with category or condition colour |
| omics layer | point shape or facet | DNA and RNA are measurement layers, not treatments |
| entity type | shape or outline | Distinguishes MAG, vOTU, and gene without spending colour |
| significance | filled versus open mark plus printed statistic | Colour is not used as a significance code |

## Taxonomy policy

The 348 classified MAGs span 45 phyla. A unique colour per phylum or MAG would
not remain legible. The registry therefore fixes colours for abundant phyla and
phyla represented among the focal inStrain MAGs. All remaining phyla map to
`Other`. Deeper taxonomic labels inherit their phylum colour.

Taxon names should normally remain dark text. Use an adjacent colour strip,
swatch, point, or branch rather than low-contrast coloured text.

## Plot construction

- No embedded figure titles.
- Vector PDF is the primary output.
- Captions are written separately and remain descriptive.
- Use direct labels when possible and avoid redundant legends.
- Keep statistical results in the relevant panel.
- Do not encode both condition and taxonomy with colour in the same marks.
- Retain the same mappings in supplementary figures.
