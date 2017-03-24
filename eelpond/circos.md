### Install circos

```
cd ~/Desktop/Tools
curl -O http://dib-training.ucdavis.edu.s3.amazonaws.com/metagenomics-scripps-2016-10-12/circos-0.69-3.tar.gz
tar -xvzf circos-0.69-3.tar.gz
export PATH=~/Desktop/Tools/circos-0.69-3/bin:$PATH
```
```
brew install libgd
```

```
circos -modules > modules
grep missing modules |cut -f13 -d " " > missing_modules
for mod in $(cat missing_modules);
  do
  sudo cpan install $mod;
  done
```
Upgrade cpan
```
sudo perl -MCPAN -e 'install Bundle::CPAN'
```
Install GD manually
```
curl -O http://www.cpan.org/authors/id/L/LD/LDS/GD-2.50.tar.gz
tar xvfz GD-2.50.tar.gz
cd GD-2.50
perl Makefile.pl
sudo make install
```
Check that everything is installed:
```
circos -modules
```

### Run Circos

Link in data
```
ln -fs ~/Desktop/Trinity.fasta.dammit/*gff3 .
ln -fs ~/Desktop/Trinity.fasta.dammit/Trinity.fasta.dammit.fasta .
ln -fs ~/Desktop/yeast_quant/*counts .
```

Use khmer to reduce contig size to below 5000
```
extract-long-sequences.py Trinity.fasta.dammit.fasta -l 5000 -o long.contigs.Trinity.fasta.dammit.fasta
```

Edit python script and parse data for circos
```
python parse_data_for_circos.py 
```
