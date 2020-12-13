# Work on remote server.
# Using 10x Genomics cellranger vdj processed output files.
# developed by https://bitbucket.org/kleinstein/immcantation/src/master/docs/tutorials/10x_tutorial.rst

1. Run docker image (and save the results in my computer):

	docker run --network=host --rm -v /home/bmrc/Public/phil_ubuntu/sc/airr/
  immcantation/outs/outs_wt:/home/phil_docker:z immcantation/suite:4.1.0 bash

2. Use changeo-10x script supplied in the Docker container. 

note: changeo-10x runs IgBLAST (what about imgt ??), converts to change-o tsv format, 
AssignGenes, ParseDb select, correct clonal groups, add germline sequences to the db. 
Basically, runs changeo-clone and -igblast.

	changeo-10x -s filtered_contig.fasta -a filtered_contig_annotations.csv -o . -g mouse -t ig -x 0.16

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output files:

-rw-rw-rw- 1 root  root    9406322 Dec 11 02:29 temp_files.tar.gz
-rw-rw-rw- 1 root  root   12334123 Dec 11 02:29 filtered_contig_heavy_germ-pass.tsv
drwxrwxrwx 2 root  root       4096 Dec 11 02:29 logs
-rw-rw-rw- 1 root  root       4602 Dec 11 02:28 filtered_contig_threshold-plot.pdf
-rw-rw-rw- 1 root  root    2338448 Dec 11 02:27 filtered_contig_light_productive-F.tsv
-rw-rw-rw- 1 root  root   13105974 Dec 11 02:27 filtered_contig_light_productive-T.tsv
-rw-rw-rw- 1 root  root    2753250 Dec 11 02:27 filtered_contig_heavy_productive-F.tsv
-rw-rw-rw- 1 root  root   29442971 Dec 11 02:27 filtered_contig_db-pass.tsv
-rw-rw-rw- 1 root  root   63721064 Dec 11 02:26 filtered_contig_igblast.fmt7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


##### Alternatively, run changeo-10x manually as follows: #####

3. Define clonal groups manually

# define heavy chain clones

note: Extract filtered_contig_heavy_productive-T.tsv from temp_files.tar.gz

	DefineClones.py -d filtered_contig_heavy_productive-T.tsv --act set --model ham \
    --norm len --dist 0.09 --outname filtered_contig_heavy

 OUTPUT> filtered_contig_heavy_clone-pass.tsv
 CLONES> 4940
RECORDS> 5159
   PASS> 5159
   FAIL> 0
    END> DefineClones

# split heavy chain clones with different light chains

	light_cluster.py -d filtered_contig_heavy_clone-pass.tsv -e filtered_contig_light_productive-T.tsv \
    -o filtered_contig_heavy_clone-light.tsv

output file: filtered_contig_heavy_clone-light.tsv

# reconstruct heavy chain germline V and J sequences

	CreateGermlines.py -d filtered_contig_heavy_clone-light.tsv -g dmask --cloned \
    -r /usr/local/share/germlines/imgt/mouse/vdj/imgt_mouse_IGHV.fasta \
    /usr/local/share/germlines/imgt/mouse/vdj/imgt_mouse_IGHD.fasta \
    /usr/local/share/germlines/imgt/mouse/vdj/imgt_mouse_IGHJ.fasta \
    --outname filtered_contig_heavy

 OUTPUT> filtered_contig_heavy_germ-pass.tsv
RECORDS> 4389
   PASS> 4386
   FAIL> 3
    END> CreateGermlines


##### End the alternative method here. #####

4. Build lineage trees using IgPhyML in Alakazam CRAN package. 

# building maximum likelihood trees of B cell-specific data

	BuildTrees.py -d filtered_contig_heavy_germ-pass.tsv --minseq 2 --clean all \
    --igphyml --collapse --nproc 16 --asr 0.9

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   START> BuildTrees
    FILE> filtered_contig_heavy_germ-pass.tsv
COLLAPSE> True

PROGRESS> 06:06:26 |Done                                              | 0.0 min

        OUTPUT> filtered_contig_heavy_germ-pass_lineages.tsv
       RECORDS> 4386
INITIAL_FILTER> 35
          PASS> 14
          FAIL> 21
 NONFUNCTIONAL> 0
FRAMESHIFT_DEL> 0
FRAMESHIFT_INS> 0
 CLONETOOSMALL> 8
  CDRFWR_ERROR> 0
  GERMLINE_PTC> 0
    OTHER_FAIL> 0
     DUPLICATE> 13
           END> BuildTrees

START> IgPhyML GY94 tree estimation

    START> IgPhyML HLP analysis
 OPTIMIZE> lr
    TS/TV> e
wFWR,wCDR> e,e
   MOTIFS> WRC_2:0,GYW_0:1,WA_1:2,TW_0:3,SYC_2:4,GRS_0:5
  HOTNESS> e,e,e,e,e,e
    NPROC> 16

       OUTPUT> filtered_contig_heavy_germ-pass_igphyml-pass.tab
  TREE_LENGTH> 0.11
        LHOOD> -628.88
    KAPPA_MLE> 3.21
OMEGA_FWR_MLE> 0.39
OMEGA_CDR_MLE> 0.78
    WRC_2_MLE> 2.44
    GYW_0_MLE> 3.67
     WA_1_MLE> 0.82
     TW_0_MLE> -0.42
    SYC_2_MLE> -0.99
    GRS_0_MLE> -0.65

START> CLEANING
SCOPE> all

END> IgPhyML analysis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Open R to load libraries.

library(alakazam)
library(ape)
library(dplyr)

# read in the data
db <- readIgphyml("filtered_contig_heavy_germ-pass_igphyml-pass.tab", format="phylo",
      branches="mutations")

png("graph.png",width=8,height=6,unit="in",res=300)
plot(db$trees[[1]],show.node.label=TRUE)
add.scale.bar(length=5)
dev.off()

output file: graph.png

5. Read 

Merge Cell Ranger annotations -> Parsing 10X Genomics V(D)J data [DONE]

### The end of assigning VDJ genes and defining clonal groups.

6. Move on to other pipelines.

	After 3. or changeo-10x, I can vew the final germ-pass.tab (change-o) or tsv (airr) file. 

	Use alakazam for clonal abundance and diversity, lineage construction.

	Use shazam-threshold.r :

		basically, I can make figures for mutational load, SHM targeting biases, quantification.

	Use tigger-genotype.r for polymorphism detection and genotyping. 

