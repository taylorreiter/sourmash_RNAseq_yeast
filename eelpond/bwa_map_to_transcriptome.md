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
