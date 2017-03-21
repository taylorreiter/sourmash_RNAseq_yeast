Eelpond Differential expression analysis
```
brew install fastqc
pip install multiqc
brew install trimmomatic
```
Used eelpond differential expression protocol on Barton yeast data in an attempt to determine whether sourmash compute/compare clustering clusters by true expression.
1. SNF2 13
2. SNF2 48
3. WT 34
4. WT 21
Documents were already downloaded locally via SRA toolkit. 

Performed
```
fastqc *fastq.gz
```
Viewed results
```
multiqc .
```

Downloaded adapter file to use for trimming
```
wget https://anonscm.debian.org/cgit/debian-med/trimmomatic.git/plain/adapters/TruSeq3-SE.fa
```
Adapted to include:
```
>TruSeq_UniversalAdapter
AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT
>Illumina_SingleEndAdapter1					
ACACTCTTTCCCTACACGACGCTGTTCCATCT
>Illumina_SingleEndAdapter2
CAAGCAGAAGACGGCATACGAGCTCTTCCGATCT					
>Illumina_SingleEndPCRPrimer1
AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT				
>Illumina_SingleEndPCRPrimer2
CAAGCAGAAGACGGCATACGAGCTCTTCCGATCT				
>Illumina_SingleEndSequencingPrimer
ACACTCTTTCCCTACACGACGCTCTTCCGATCT			
>TruSeq3_IndexedAdapter
AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
>TruSeq3_UniversalAdapter
AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA
```
Trimmed using trimmomatic
```
for infile in *fastq.gz
do 
 base=$(basename $infile .fastq.gz)
     trimmomatic SE -phred33 -trimlog ${base}.log ${infile} ${base}_trim_fastq.gz ILLUMINACLIP:AdaptedTruSeq3-SE.fa:2:30:10
done
```
Make files read only
```
chmod u-w ./*_trim.fastq.gz
```
Run fastqc on the trimmed files
```
fastqc *_trim.fastq.gz
```

Run multiqc to check results
```
multiqc .
```

Perform digital normalization

First, make new directory, and link in trimmed files
```
mkdir -p diginorm
cd diginorm
ln -s ../quality/*trim.fastq.gz .
```
Then, use khmer to normalize the reads
```
normalize-by-median.py -k 20 -C 20 -M 9e9  --savegraph normC20k20.ct  *_trim.fastq.gz
```
Lastly, k-mers that are likely erroneous
```
filter-abund.py -V -Z 18 normC20k20.ct *.keep
```

Rename the reads
```
for file in *.abundfilt
do
  newfile=${file%%.fq.gz.keep.abundfilt}.keep.abundfilt.fq
  mv ${file} ${newfile}
  gzip ${newfile}
done
```

Make assembly directory
```
cd ..
mkdir assembly
cd assembly
```
Link in diginorm files
```
ln -s ../diginorm/*abundfilt.fq.gz .
```
Concatenate all files into a single file
```
gunzip -c *trim.fq.gz > yeast_all.fq
```

Run Trinity
Trinity --single yeast_all.fq --seqType fq --max_memory 14G --CPU 1

