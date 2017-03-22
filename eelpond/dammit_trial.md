Try to annotate with dammit

Ran on MacBook Pro 2011, OS X El Capitan version 10.11.6

Install things
```
brew install infernal parallel ruby emboss hmmer blast transdecoder 
```
And if V2 was not installed before:
```
cd ~/Desktop/Tools
git clone https://gitlab.com/ezlab/busco.git
export PATH=~/Desktop/Tools/busco:$PATH
echo 'export PATH=~/Desktop/Tools/busco:$PATH' >> $HOME/.bashrc
```

```
sudo gem install crb-blast
```

Probably not necessary for mac:
```
liburi-escape-xs-perl liburi-perl build-essential libsm6 libfontconfig1 libx11-dev libxrender1 unzip
```

Last
```
cd ~/Desktop/Tools
curl -LO http://last.cbrc.jp/last-658.zip
unzip last-658.zip
cd last-658
make
make install
export PATH=$HOME/Desktop/Tools/last-658/src:$PATH
export PATH=$HOME/Desktop/Tools/last-658/scripts:$PATH
```

To add to path permenently
```
echo 'export PATH=$PATH:$HOME/Deskotp/Tools/last-658/src' >> $HOME/.bashrc
```

Install miniconda
```
cd ~/Desktop/Tools
curl -LO https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh -b
source ~/.bashrc
```

Create environment for dammit
```
cd ~/Desktop/Tools
~/miniconda3/bin/conda create -y -n dammit anaconda python=3.5
source ~/miniconda3/bin/activate dammit
```

Install things with python dependencies
```
conda install -y --file <(curl https://raw.githubusercontent.com/camillescott/shmlast/master/environment.txt)
pip install --upgrade pip
pip install shmlast
```
# Install matplot lib
```
pip install https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.5.1.tar.gz
```

Install dammit from refractor branch 1.0
```
pip install https://github.com/camillescott/dammit/archive/refactor/1.0.zip
```

Build databases
```
dammit databases --install --busco-group eukaryota
```

Make directory for annotations
```
cd ~/Desktop/DIB_eelpond/
mkdir -p annotation
cd annotation
ln -s ~/Desktop/DIB_eelpond/assembly/trinity_out_dir/Trinity.fasta .

Run dammit
```
dammit annotate Trinity.fasta --busco-group eukaryota --n_threads 2 | tee dammit_Trinity_outfile.log
```
```
source deactivate dammit
```
