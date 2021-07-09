#!/env/bash

# Arguments
DATA_DIR = /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/vac_output/outs
READS = /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/vac_output/outs/filtered_contig.fasta
ANNOTATIONS = /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/vac_output/outs/filtered_contig_annotations.csv
SAMPLE_NAME = vac
OUT_DIR = /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/vac_output/outs/results/changeo10x
DIST = auto
RECEPTOR = ig
NPROC = 16
SPECIES = mouse

# Running the changeo-10x pipeline in my docker image

docker run -v $DATA_DIR:/home/phil_docker:z sphilmoon/immcantation:devel \
	    changeo-10x -s $READS -a $ANNOTATIONS -g $SPECIES -t $RECEPTOR -x $DIST \
	        -n $SAMPLE_NAME -o $OUT_DIR -p $NPROC 
