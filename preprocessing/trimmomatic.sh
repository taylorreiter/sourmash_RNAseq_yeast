for infile in *fastq.gz
do 
 base=$(basename $infile .fastq.gz)
     trimmomatic SE -phred33 -trimlog ${base}.log ${infile} ${base}_trim_fastq.gz ILLUMINACLIP:AdaptedTruSeq3-SE.fa:2:30:10
done
