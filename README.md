# Sourmash & RNA-seq data
All analyses were performed using data from the Schurch et al. 2016 paper (doi: 10.1261/rna.053959). This dataset consistes of 48 biological replicates of *wt* yeast, and 48 biological replicates of *snf2* mutant yeast. Each biological replicate also had seven techincal replicates. In total, there were 672 RNA-seq samples. 

In order to determine sourmash's performance when given RNA-seq data, `sourmash compute` and `sourmash compare` were run with a variety of k-mer sizes and scaled sizes. The output of these were converted into .csv files and imported in to R for visualization. The output of sourmash compare allowed us to see that some biological replicate and technical replicates likely group by batch effect, not by treatment (i.e., *wt* clusters more closely with *snf2* than with other *wt* in some cases).

To understand if sourmash was picking up on real differential expression, and appropriately discerning that some *wt* were indeed more similar to *snf2* than to other *wt*, I next used the Eel Pond protocol (https://khmer-protocols.readthedocs.io/en/latest/mrnaseq/) for differential expression. 
