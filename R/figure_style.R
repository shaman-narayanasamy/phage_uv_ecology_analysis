# Shared visual grammar for all manuscript and supplementary figures.
#
# Source this file before constructing plots. A factor may own colour only when
# colour is the clearest encoding in that panel. Do not map two meanings to
# colour in the same panel.

phage_uv_condition_colours <- c(
  control = "#8FCB8A",
  phage_uv = "#7E57C2",
  treatment = "#7E57C2",
  uv = "#7E57C2"
)

phage_uv_phase_shapes <- c(
  initial = 16,
  backflush = 17
)

phage_uv_cycle_linetypes <- c(
  `1` = "solid",
  `2` = "22",
  `3` = "42"
)

phage_uv_phylum_colours <- c(
  Bacteroidota = "#E69F00",
  Chloroflexota = "#009E73",
  Omnitrophota = "#56B4E9",
  Pseudomonadota = "#0072B2",
  Halobacteriota = "#CC79A7",
  Patescibacteria = "#F0E442",
  Planctomycetota = "#D55E00",
  Verrucomicrobiota = "#8DA0CB",
  Desulfobacterota = "#A6761D",
  Acidobacteriota = "#66C2A5",
  Actinomycetota = "#E78AC3",
  Spirochaetota = "#A6D854",
  UBA10199 = "#1B9E77",
  Bacillota_A = "#E6AB02",
  Campylobacterota = "#7570B3",
  Hydrogenedentota = "#A6CEE3",
  Thermotogota = "#8C564B",
  Zixibacteria = "#BCBD22",
  Myxococcota = "#E7298A",
  Chlamydiota = "#FB9A99",
  Eremiobacterota = "#B15928",
  JACPWU01 = "#6A3D9A",
  Other = "#B3B3B3",
  Unclassified = "#B3B3B3"
)

# Fixed family colours for the MAG-level metagenomic community profile. The
# named set is frozen from the current mean-abundance ranking so that the same
# family never changes colour between manuscript and supplementary figures.
phage_uv_family_colours <- c(
  `4484-276` = "#4E79A7",
  Anaerolineaceae = "#F28E2B",
  SHND01 = "#E15759",
  Smithellaceae = "#76B7B2",
  Propionibacteriaceae = "#59A14F",
  Methanotrichaceae = "#EDC948",
  Methanoregulaceae = "#B07AA1",
  Burkholderiaceae_B = "#FF9DA7",
  Arcobacteraceae = "#9C755F",
  Rhodocyclaceae = "#17BECF",
  JAFGLZ01 = "#1B9E77",
  `FEN-979` = "#D95F02",
  UBA1135 = "#7570B3",
  UBA4823 = "#E7298A",
  `CAG-138` = "#66A61E",
  `Unclassified at family level` = "#969696",
  `Other classified families` = "#D9D9D9"
)

phage_uv_viral_realm_colours <- c(
  Duplodnaviria = "#355070",
  Riboviria = "#E76F51",
  Floreoviria = "#6A994E",
  Varidnaviria = "#E9C46A",
  Adnaviria = "#2A9D8F",
  unclassified_virus = "#8C8C8C",
  Unclassified = "#B3B3B3"
)

phage_uv_signature_colours <- c(
  nucleotide_excision_repair = "#4477AA",
  photoreactivation = "#66CCEE",
  recombination_repair = "#228833",
  SOS_response = "#CCBB44",
  oxidative_stress = "#EE6677",
  redox_stress = "#AA3377",
  base_excision_oxidative_repair = "#BBBBBB",
  general_stress = "#EE7733"
)

phage_uv_omics_shapes <- c(
  metagenomics = 21,
  metatranscriptomics = 24
)

phage_uv_normalise_condition <- function(x) {
  x <- as.character(x)
  x[x %in% c("uv", "phage_uv")] <- "treatment"
  factor(x, levels = c("control", "treatment"))
}

phage_uv_normalise_realm <- function(x) {
  x <- sub("^r_", "", as.character(x))
  x[is.na(x) | x == ""] <- "Unclassified"
  x
}

phage_uv_phylum_colour <- function(x) {
  x <- as.character(x)
  mapped <- ifelse(
    is.na(x) | x == "",
    "Unclassified",
    ifelse(x %in% names(phage_uv_phylum_colours), x, "Other")
  )
  unname(phage_uv_phylum_colours[mapped])
}

theme_phage_uv <- function(base_size = 9, base_family = "sans") {
  ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.title = ggplot2::element_blank(),
      legend.title = ggplot2::element_text(face = "plain"),
      legend.key = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "plain"),
      axis.title = ggplot2::element_text(face = "plain"),
      axis.text = ggplot2::element_text(colour = "#222222"),
      panel.spacing = grid::unit(1.2, "lines")
    )
}
