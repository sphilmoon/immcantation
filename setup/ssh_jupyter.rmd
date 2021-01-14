# In local server
1. Connect to remote server:
	ssh bmrc@10.13.102.33
	pw: qwe123

# In remote server:
2. Run docker image (Not saving the container)
	docker run --network=host -it --rm -v /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/outs/outs_wt:/home/phil_docker/jupyter:z -p 8888:8888 immcantation/suite:4.1.0 bash

# Back to local server (in order to run jupyter remotely):
3. Open localhost jupyter notebook
	ssh -N -f -L localhost:8888:localhost:8888 bmrc@10.13.102.33

# In remote server:
4. Run jupyter notebook
	jupyter notebook --ip 0.0.0.0 --no-browser --allow-root

# Back to local server
5. copy http://127.0.0.1:8888/?token=a2fe848f5588528bba747251c05a5837812cb551f0ff8418 on your chrome.

### Secure copy (example): ###

# From local to remote
scp -r /mnt/d/raw_data/scrnaseq_raw/count_cellranger bmrc@10.13.102.33:/home/bmrc/Public/phil_ubuntu/gene_expression/fastq

# From remote to local (my Macbook)
scp -r bmrc@10.13.102.33:/home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/outs/outs_wt/graph.png .



### This one works: 
docker run --rm -v /home/bmrc/Public/phil_ubuntu/sc/airr/immcantation/outs:/home/phil_docker:z immcantation/suite:4.1.0 versions report


AssignGenes.py igblast -s filtered_contig.fasta -b /usr/local/share/igblast --organism mouse --loci ig --format blast
