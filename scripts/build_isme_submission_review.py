#!/usr/bin/env python3
"""Build the ISME Communications author-review manuscript from canonical files.

The venue-neutral manuscript remains canonical. This builder creates a derived,
journal-formatted review source and raster previews for the Google Docs review
copy. Submitted figure files remain the canonical vector PDFs.
"""

from __future__ import annotations

import re
import subprocess
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
CANONICAL = REPO / "manuscript" / "manuscript_skeleton.md"
OUT_DIR = REPO / "manuscript" / "isme_communications"
OUT_MD = OUT_DIR / "submission_review_manuscript.md"
ASSET_DIR = OUT_DIR / "review_assets"
FIGURE_DIR = (
    REPO.parents[1]
    / "PRJEB79569"
    / "derived"
    / "manuscript_figure_candidates"
    / "figures"
)
HOST_PHAGE_FIGURE = (
    REPO.parents[1]
    / "PRJEB79569"
    / "derived"
    / "host_phage_network_review"
    / "figures"
    / "host-phage-network-evidence-audit.pdf"
)


def section(text: str, start: str, end: str | None) -> str:
    start_at = text.index(start)
    end_at = len(text) if end is None else text.index(end, start_at)
    return text[start_at:end_at].strip()


def cite(text: str) -> str:
    replacements = {
        "(Scarascia et al., 2021)": "[@Scarascia2021]",
        "(Myshkevych et al., 2025)": "[@Myshkevych2025]",
        "(Aroney et al., 2025)": "[@Aroney2025]",
        "(Dahl et al., 2022)": "[@Dahl2022]",
        "(Nayfach et al., 2021)": "[@Nayfach2021]",
        "(Robinson et al., 2010)": "[@Robinson2010edgeR]",
        "(Robinson and Oshlack, 2010)": "[@Robinson2010TMM]",
        "(Benjamini and Hochberg, 1995)": "[@Benjamini1995]",
        "(Schwengers et al., 2021)": "[@Schwengers2021]",
        "(von Meijenfeldt et al., 2019; Parks et al., 2022)": "[@vonMeijenfeldt2019; @Parks2022]",
        "(Wu and Smyth, 2012)": "[@Wu2012]",
        "(Olm et al., 2021)": "[@Olm2021]",
        "(Maslowska et al., 2019)": "[@Maslowska2019]",
        "(Lu et al., 2016; Cheng et al., 2019)": "[@Lu2016; @Cheng2019]",
    }
    for old, new in replacements.items():
        text = text.replace(old, new)
    flexible_replacements = {
        r"\(Scarascia\s+et\s+al\.,\s+2021\)": "[@Scarascia2021]",
        r"\(Myshkevych\s+et\s+al\.,\s+2025\)": "[@Myshkevych2025]",
        r"\(Robinson\s+et\s+al\.,\s+2010\)": "[@Robinson2010edgeR]",
        r"\(Schwengers\s+et\s+al\.,\s+2021\)": "[@Schwengers2021]",
        r"\(von\s+Meijenfeldt\s+et\s+al\.,\s+2019;\s+Parks\s+et\s+al\.,\s+2022\)": "[@vonMeijenfeldt2019; @Parks2022]",
        r"\(Lu\s+et\s+al\.,\s+2016;\s+Cheng\s+et\s+al\.,\s+2019\)": "[@Lu2016; @Cheng2019]",
    }
    for pattern, new in flexible_replacements.items():
        text = re.sub(pattern, new, text)
    return text


def extract_legend(block: str, label: str, next_label: str | None) -> str:
    start = block.index(f"**{label}")
    end = len(block) if next_label is None else block.index(f"**{next_label}", start)
    return block[start:end].strip()


def preview(source: str | Path, target: str) -> Path:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    source_path = source if isinstance(source, Path) else FIGURE_DIR / source
    target_stem = ASSET_DIR / target
    subprocess.run(
        ["pdftoppm", "-f", "1", "-singlefile", "-r", "150", "-png", str(source_path), str(target_stem)],
        check=True,
    )
    return target_stem.with_suffix(".png")


def figure_block(image_path: Path, legend: str, alt: str) -> str:
    relative = image_path.relative_to(REPO)
    return (
        f"![]({relative}){{width=6.5in}}\n\n"
        f"{cite(legend)}\n\n"
        f"Alt text: {alt}"
    )


def main() -> None:
    source = CANONICAL.read_text(encoding="utf-8")
    introduction = section(source, "## Introduction", "## Methods")
    methods = section(source, "## Methods", "## Results").replace(
        "## Methods", "## Materials and Methods", 1
    )
    results = section(source, "## Results", "## Discussion")
    discussion = section(source, "## Discussion", "## Data and code availability")
    data = section(source, "## Data and code availability", "## Declarations")
    main_legends = section(source, "## Working main-figure legends", "## Working supplementary-figure legends")
    supp_legends = section(source, "## Working supplementary-figure legends", "## Editorial insertion note")

    introduction = introduction.replace(
        "Membrane biofouling constrains anaerobic membrane bioreactors and creates a\n"
        "recurring need for cleaning.",
        "Membrane biofouling constrains anaerobic membrane bioreactors and creates a\n"
        "recurring need for cleaning [@Scarascia2021].",
    )
    introduction = introduction.replace(
        "A combined bacteriophage and UV-C procedure was",
        "A combined bacteriophage and ultraviolet C (UV-C) procedure was",
    )
    methods = methods.replace(
        "MAG-level community profiles were calculated",
        "Metagenome-assembled genome (MAG)-level community profiles were calculated",
    )
    methods = methods.replace(
        "The staged viral catalogue contained 607 deduplicated, classified,\n"
        "high-quality vOTUs",
        "The staged viral catalogue contained 607 deduplicated, classified,\n"
        "high-quality viral operational taxonomic units (vOTUs)",
    )
    methods = methods.replace(
        "trimmed mean\nof M-values method",
        "trimmed mean\nof M-values (TMM) method",
    )
    methods = methods.replace(
        "metagenome-assembled genome (MAG) and gene identifier",
        "MAG and gene identifier",
    )
    methods = methods.replace(
        "against a GTDB-derived database",
        "against a Genome Taxonomy Database (GTDB)-derived database",
    )
    methods = methods.replace(
        "Raw P values were adjusted\nby the Benjamini-Hochberg method",
        "Raw P values were adjusted\nby the Benjamini-Hochberg (BH) false discovery rate (FDR) method",
    )
    methods = methods.replace(
        "at least 1 Mbp and\n50%",
        "at least 1 million base pairs (Mbp) and\n50%",
    )
    methods = methods.replace("summarized", "summarised")
    introduction = introduction.replace(
        "Whether this changing engineering performance reflects a uniform microbial\n"
        "response is less clear.",
        "Membrane biofilms are dynamic communities whose membership and functional\n"
        "potential can change during colonisation and maturation [@Lu2016; @Cheng2019].\n"
        "Whether the changing engineering performance in the repeated-cleaning system\n"
        "reflects a uniform microbial response is less clear.",
    )
    discussion = re.sub(
        r"\nThe delegated 16S analysis can add a complementary amplicon-based view.*?programme was not supported\.\n?",
        "\nThe present evidence supports a precise conclusion: the two repeatedly sampled\n"
        "membranes developed broad, bidirectional, organism-resolved differences in\n"
        "their transcriptomes, whereas a uniform damage-response or adaptation\n"
        "programme was not supported. Future replicated experiments should separate\n"
        "membrane identity from cleaning treatment and pair metagenomic abundance with\n"
        "transcription at each time point.\n",
        discussion,
        flags=re.S,
    )

    abstract = """## Abstract

Combined bacteriophage and ultraviolet C cleaning can delay fouling of anaerobic
membrane bioreactors, but the community-wide context of this response is
unresolved. We analysed all expressed features from one control membrane and
one treated membrane sampled during two phases of three cleaning cycles.
Genome-resolved metagenomes showed diverse, changing community profiles, while
the global metatranscriptome was organised primarily by cleaning cycle. Of
1,734,019 input features, 361,907 passed a predeclared filter. After adjustment
for phase and cycle, 7,703 differed between membranes at a Benjamini-Hochberg
false discovery rate below 0.05, with 7,699 also exceeding an absolute log2
fold-change of 1. The signal was broad and bidirectional, while its functional
support was narrow. Genes assigned to the canonical bacterial damage-response
regulatory system were collectively higher-ranked in the treated membrane, but
the median log2 fold-change was 0.136 and the other seven predefined repair and
stress categories were unsupported. By contrast, 175 of 340 eligible
metagenome-assembled genomes carried coherent gene-set signals, split between
100 treated-membrane-higher and 75 control-membrane-higher sets. A predeclared
recurrence filter retained 6,985 genes across the six phase-cycle cells, again
in both directions. Five coverage-qualified genomes showed organism-specific
population stability and turnover without a uniform membrane-associated
pattern. Because each condition is represented by one membrane, treatment and
membrane identity are confounded. Repeated cleaning therefore coincided with
broad, organism-resolved transcriptional restructuring in this system, not a
uniform damage-response or adaptation programme.

**Keywords:** anaerobic membrane bioreactor; bacteriophage; UV-C; biofouling;
metatranscriptomics; genome-resolved analysis"""

    front = """Heterogeneous organism-resolved transcriptional restructuring across repeated phage-UV cleaning of anaerobic membrane biofilms

**Original Article**

**Running title:** Biofilm response to repeated phage-UV

Yevhen Myshkevych^1^, Giantommaso Scarascia^1^, Julie Sanchez Medina^1^,
Shaman Narayanasamy^1,2^, Venkata Satagopam^2^, and Pei-Ying Hong^1^

^1^ Environmental Science and Engineering Program, Biological and Environmental
Sciences & Engineering Division, King Abdullah University of Science and
Technology, Thuwal 23955-6900, Saudi Arabia

^2^ Luxembourg Centre for Systems Biomedicine, ELIXIR Luxembourg, University of
Luxembourg, Belval L-4367, Luxembourg

**Corresponding author:** Pei-Ying Hong, King Abdullah University of Science and
Technology, Thuwal 23955, Saudi Arabia; peiying.hong@kaust.edu.sa

**Author review note:** The author list, order, current affiliations,
corresponding-author designation, ORCID identifiers, contribution statement,
funding, and competing-interest declaration require confirmation. The list and
corresponding author above are inherited from the publication describing the
experimental system and are not treated as approved for this reanalysis. The
collaborator-owned 16S analysis is pending and is not represented as a result in
this version."""

    declarations = """## Acknowledgments

We thank the KAUST FM Utilities team for providing access to raw wastewater
samples. [AUTHOR CONFIRMATION REQUIRED]

## Author contributions

Proposed CRediT statement for author review: Yevhen Myshkevych: investigation,
methodology, and writing - review and editing. Giantommaso Scarascia:
investigation, conceptualisation, and writing - review and editing. Julie
Sanchez Medina: methodology, investigation, and writing - review and editing.
Shaman Narayanasamy: conceptualisation, data curation, formal analysis,
methodology, software, visualisation, writing - original draft, and writing -
review and editing. Venkata Satagopam: resources, software, and writing - review
and editing. Pei-Ying Hong: conceptualisation, funding acquisition, project
administration, resources, supervision, and writing - review and editing. All
roles require confirmation by the authors.

## Funding

The experimental study was supported by KAUST baseline grant BAS/1/1033-01-01
awarded to Pei-Ying Hong. The authors must confirm whether this grant supported
the present reanalysis and identify any additional support before submission.

## Conflict of interest

The authors declare no competing interests. [ALL AUTHORS TO RECONFIRM]
"""

    data = data.replace("## Data and code availability", "## Data availability", 1)
    data = data.replace(
        "project repository and its manifests",
        "project repository (https://github.com/shaman-narayanasamy/phage_uv_ecology_analysis) and its manifests",
    )

    main_specs = [
        (
            "Figure 1.", "Figure 2.", "community-transcriptome-trajectory.pdf", "figure1",
            "Three-panel figure showing the two-membrane sampling design, stacked family-level community profiles across six aligned cycle-phase observations, and leading log-fold-change coordinates for the 12 metatranscriptomic samples."
        ),
        (
            "Figure 2.", "Figure 3.", "transcriptome-response-architecture.pdf", "figure2",
            "Four-panel figure showing the adjusted membrane expression landscape, competitive repair and stress category results, counts of supported genome-level gene sets by direction, and median effects for the strongest supported organisms."
        ),
        (
            "Figure 3.", "Figure 4.", "recurrent-gene-structure.pdf", "figure3",
            "Three-panel figure showing the recurrent-gene selection funnel, counts by directional agreement across six cells, and a heatmap of cell-level differences for 24 deterministically selected genes."
        ),
        (
            "Figure 4.", "Figure 5.", "population-genomic-heterogeneity.pdf", "figure4",
            "Three-panel figure showing strain-cluster membership for five coverage-qualified genomes, their pairwise consensus-difference summaries, and the pairwise landscape for Propionicimonas sp023458095."
        ),
    ]
    supp_specs = [
        ("Supplementary Figure S1.", "Supplementary Figure S2.", "supplementary-model-diagnostics.pdf", "supplementary_figure_s1", "Three-panel diagnostic figure summarising feature filtering, retained and effective library sizes, and model-dispersion estimates."),
        ("Supplementary Figure S2.", "Supplementary Figure S3.", "supplementary-cycle-interaction-landscape.pdf", "supplementary_figure_s2", "Expression landscapes for cycle-2 and cycle-3 interaction coefficients and the two-degree-of-freedom interaction omnibus."),
        ("Supplementary Figure S3.", "Supplementary Figure S4.", "supplementary-functional-coefficients.pdf", "supplementary_figure_s3", "Competitive rank-test results for eight predefined repair and stress categories across four model coefficients."),
        ("Supplementary Figure S4.", "Supplementary Figure S5.", "supplementary-mag-coherence.pdf", "supplementary_figure_s4", "Counts and effect summaries for eligible genome-level gene sets across the adjusted membrane and two interaction coefficients."),
        ("Supplementary Figure S5.", "Supplementary Figure S6.", "supplementary-population-genomics.pdf", "supplementary_figure_s5", "Coverage-qualified pairwise consensus-difference matrices for the five genomes retained for descriptive population-genomic analysis."),
        ("Supplementary Figure S6.", "Supplementary Figure S7.", "mag-taxonomic-context.pdf", "supplementary_figure_s6", "Taxonomy-derived circular dendrogram for 348 genomes with quality and transcriptomic rings, paired with aligned stacked family-level metagenomic profiles."),
        ("Supplementary Figure S7.", "Supplementary Figure S8.", "votu-taxonomic-context.pdf", "supplementary_figure_s7", "Taxonomy-derived cladogram for 607 high-quality viral operational taxonomic units, grouped into 45 taxonomic paths, with realm-level catalogue counts."),
        ("Supplementary Figure S8.", None, HOST_PHAGE_FIGURE, "supplementary_figure_s8", "Bipartite evidence-audit network connecting 80 host genomes to 85 phage contigs through 86 deduplicated CRISPR-derived candidate links, with host-expression and viral-catalogue context."),
    ]

    figure_parts = []
    for label, next_label, pdf, stem, alt in main_specs:
        legend = extract_legend(main_legends, label, next_label)
        image = preview(pdf, stem)
        figure_parts.append(figure_block(image, legend, alt))

    supp_parts = []
    for label, next_label, pdf, stem, alt in supp_specs:
        legend = extract_legend(supp_legends, label, next_label)
        image = preview(pdf, stem)
        supp_parts.append(figure_block(image, legend, alt))

    body = "\n\n".join(
        [
            front,
            abstract,
            cite(introduction),
            cite(methods),
            cite(results),
            cite(discussion),
            declarations,
            cite(data),
            "## References\n\n::: {#refs}\n:::",
            "## Figures",
            "\n\n\\newpage\n\n".join(figure_parts),
            "## Supplementary figures",
            "\n\n\\newpage\n\n".join(supp_parts),
        ]
    )
    body = body.replace(" x 10^-", " × 10^-")
    OUT_MD.write_text(body.rstrip() + "\n", encoding="utf-8")
    print(OUT_MD)


if __name__ == "__main__":
    main()
