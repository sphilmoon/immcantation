#!/local/bin bash
# running "cellranger aggr" command from my own csv files created.

# aggregating three vdj_contig_info.pb files: a, vac, and wt.
cellranger aggr --id=a_vac_wt --csv=aggr_a.csv

# aggregating three vdj_contig_info.pb files: r, vac, and wt.
cellranger aggr --id=r_vac_wt --csv=aggr_r.csv