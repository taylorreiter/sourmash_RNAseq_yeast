```
brew install bwa
```
Make a directory to place everything in
```
mkdir bwa_map
cd bwa_map
ln -s ../assembly/trinity_out_dir/Trinity.fasta .
ln -s ../trimmomatic/*trim.fastq.gz .
```

Index the assembly
```
bwa index Trinity.fa
```

Align to reference
```
for infile in *gz
do
  bwa aln Trinity.fasta ${infile} > ${infile}.sam
done
```

Index the transcriptome
```
samtools faidx Trinity.fasta
```

Whoops...should have come out as .sai
```
for infile in *sam; do j=$(basename $infile .sam); mv $infile ${j}.sai; done
```

Then convert to sam
```
for infile in *.sai
do
    j=$(basename $infile .sai)
    bwa samse Trinity.fasta ${infile} ${j} > ${j}.sam
done
```

Convert from sam to bam
```
for i in *.sam
do
  # samtools faidx Trinity.fasta
  samtools view -bt Trinity.fasta.fai ${i} > ${i}.bam
done
```
Sort bam
```
for infile in *bam
do
  samtools sort $infile -o ${infile}.sorted.bam
done
```

Index bam
```
for infile in *sorted.bam
do
  samtools index ${infile}
done
```

Check if it worked
```
samtools tview ERR459108_trim.fastq.gz.sam.bam Trinity.fasta -p SN:TRINITY_DN9_c0_g1_i1	LN:626
```

Plot with Circos

Install Circos
```
mkdir circos
cd circos
curl -O http://dib-training.ucdavis.edu.s3.amazonaws.com/metagenomics-scripps-2016-10-12/circos-0.69-3.tar.gz
tar -xvzf circos-0.69-3.tar.gz
```
Cheat and get dependencies through homebrew:
```
brew install circos
```
```
cd ..
mkdir plotting
cd plotting
```
Link in gff files
```
ln -fs ../../annotation/Trinity.fasta.dammit/Trinity.fasta.dammit.gff3 .
ln -fs ../../assembly/trinity_out_dir/Trinity.fasta .
ln -fs ../../quant/*counts .
```

Grab things from DIB
```
curl -L -O https://github.com/ngs-docs/2016-metagenomics-sio/raw/master/circos-build.tar.gz
tar -xvzf circos-build.tar.gz
```

Limit data to longest contigs in assembly using khmer

Not ran...yeast is small, see how it does
```
# extract-long-sequences.py  final.contigs.fa -l 24000 -o final.contigs.long.fa
```

Make Circos acceptable files
*NB* This file is specific to tutorial. Modify, or re-write something else to parse data. 
```
python parse_data_for_circos.py
```

Make circos plot
```
cd circos-build
circos
```
