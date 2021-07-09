# Amino acid physicochemical property analysis.
# To calculate all of the available amino acid properties from DNA sequences
# in the junction column.
# https://alakazam.readthedocs.io/en/stable/vignettes/AminoAcids-Vignette/

# 0. importing required libararies.

library(alakazam)
library(dplyr)
library(scales)

# 1. subsetting the built-in example dataset.
data(ExampleDb)
db <- ExampleDb[ExampleDb$sample_id == "+7d", ]

# 2. defining amino acid properties.
db_props <- aminoAcidProperties(db, seq="junction", nt = TRUE, trim = TRUE, 
								label="cdr3")
# 2.1 the full set of properties will be calculated by default. 
dplyr::select(db_props[1:3, ], starts_with("cdr3"))

# 3. define a ggplot theme for all plots.
tmp_theme <- theme_bw() + theme(legend.position = "bottom")

# 3.1 generating plots for all four properties.
g1 <- ggplot(db_props, aes(x=c_call, y=cdr3_aa_length)) + tmp_theme +
    ggtitle("CDR3 length") + 
    xlab("Isotype") + ylab("Amino acids") +
    scale_fill_manual(name="Isotype", values=IG_COLORS) +
    geom_boxplot(aes(fill=c_call))
g2 <- ggplot(db_props, aes(x=c_call, y=cdr3_aa_gravy)) + tmp_theme + 
    ggtitle("CDR3 hydrophobicity") + 
    xlab("Isotype") + ylab("GRAVY") +
    scale_fill_manual(name="Isotype", values=IG_COLORS) +
    geom_boxplot(aes(fill=c_call))
g3 <- ggplot(db_props, aes(x=c_call, y=cdr3_aa_basic)) + tmp_theme +
    ggtitle("CDR3 basic residues") + 
    xlab("Isotype") + ylab("Basic residues") +
    scale_y_continuous(labels=scales::percent) +
    scale_fill_manual(name="Isotype", values=IG_COLORS) +
    geom_boxplot(aes(fill=c_call))
g4 <- ggplot(db_props, aes(x=c_call, y=cdr3_aa_acidic)) + tmp_theme +
    ggtitle("CDR3 acidic residues") + 
    xlab("Isotype") + ylab("Acidic residues") +
    scale_y_continuous(labels=scales::percent) +
    scale_fill_manual(name="Isotype", values=IG_COLORS) +
    geom_boxplot(aes(fill=c_call))
gridPlot(g1, g2, g3, g4, ncol=2) # in a 2x2 grid

