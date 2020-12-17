# Basic gene usage analysis
# https://alakazam.readthedocs.io/en/stable/vignettes/GeneUsage-Vignette/

# 0. importing required libararies.

library(alakazam)
library(dplyr)
library(scales)

# subsetting the built-in example dataset.
data(ExampleDb)

# or
# filtered_contig_heavy_germ-pass.tsv

	### I am stuck at loading my data 
	'''
	gene <- countGenes("filtered_contig_heavy_germ-pass.tsv", gene="v_call_10x", groups="sample_id", mode="gene")
	Error in countGenes("filtered_contig_heavy_germ-pass.tsv", gene = "v_call_10x",  : 
	  The column v_call_10x was not found
	'''

# 1. quantifying the usage at the gene level #mode. 
gene <- countGenes(ExampleDb, gene="v_call", groups="sample_id", mode="gene")
head(gene, n=4)

# 1.1. assigning sorted level and subset to "IGHV1"
ighv1 <- gene %>%
   mutate(gene=factor(gene, levels=sortGenes(unique(gene), method="name"))) %>%
   filter(getFamily(gene) == "IGHV1") # only selecting rows containing IGHV1.

   # plotting V gene usage in IGHV1 family by sample. 
g1 <- ggplot(ighv1, aes(x=gene, y=seq_freq)) +
    theme_bw() +
    ggtitle("IGHV1 Usage") +
    theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1)) +
    ylab("Percent of repertoire") +
    xlab("") +
    scale_y_continuous(labels=percent) +
    scale_color_brewer(palette="Set1") +
    geom_point(aes(color=sample_id), size=5, alpha=0.8)
plot(g1)

# Alternatively, 
# 2. quantifying the usage at the family level or allele level #mode. 
family <- countGenes(ExampleDb, gene="v_call", groups="sample_id", mode="family")

g2 <- ggplot(family, aes(x=gene, y=seq_freq)) +
    theme_bw() +
    ggtitle("Family Usage") +
    theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1)) +
    ylab("Percent of repertoire") +
    xlab("") +
    scale_y_continuous(labels=percent) +
    scale_color_brewer(palette="Set1") +
    geom_point(aes(color=sample_id), size=5, alpha=0.8)
plot(g2)

# 3. Applying multiple groupings using #groups argument. 
# Perform by unique sample and isotype pairs.
# Using #clone count instead of sequence count. 
# quantifying the V family clonal usage by sample and isotypes. 
family <- countGenes(ExampleDb, gene="v_call", groups=c("sample_id", "c_call"), 
                     clone="clone_id", mode="family")
head(family, n=4) 

# 3.1 subsetting c_call (isotypes) to IGHM and IGHG for plotting.
family <- filter(family, c_call %in% c("IGHM", "IGHG"))

# 3.2 plot V family clonal usage by sample and isotypes
g3 <- ggplot(family, aes(x=gene, y=clone_freq)) +
    theme_bw() +
    ggtitle("Clonal Usage") +
    theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1)) +
    ylab("Percent of repertoire") +
    xlab("") +
    scale_y_continuous(labels=percent) +
    scale_color_brewer(palette="Set1") +
    geom_point(aes(color=sample_id), size=5, alpha=0.8) +
    facet_grid(. ~ c_call)
plot(g3)

# Instead of using clonal usage,
# 4. quantifying V family copy numbers by sample and isotypes.
# clone arg is ignored.
family <- countGenes(ExampleDb, gene="v_call", groups=c("sample_id", "c_call"), 
                     mode="family", copy="duplicate_count")
head(family, n=4)

# 4.1 subsetting c_call (isotypes) to IGHM and IGHG for plotting.
family <- filter(family, c_call %in% c("IGHM", "IGHG"))

# plot V family copy abundance by sample and isotype
g4 <- ggplot(family, aes(x=gene, y=copy_freq)) +
    theme_bw() +
    ggtitle("Copy Number") +
    theme(axis.text.x=element_text(angle=45, hjust=1, vjust=1)) +
    ylab("Percent of repertoire") +
    xlab("") +
    scale_y_continuous(labels=percent) +
    scale_color_brewer(palette="Set1") +
    geom_point(aes(color=sample_id), size=5, alpha=0.8) +
    facet_grid(. ~ c_call)
plot(g4)
