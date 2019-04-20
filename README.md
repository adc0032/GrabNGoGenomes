# Grab-N-Go Genomes (GrabNGoGenomes): Automating Sequence Data Retrieval
## Purpose: Wrapper used to search NCBI's SRA database through Entrez's E-utilities (v) for sequence data and download sequencing data using NCBI's SRA Toolkit (v) 

### _Introduction_
_Grab-N-Go Genomes: Automating Sequence Data Retrieval_ 

_GrabNGoGenomes_ was created with the "intro to biocomputing" student in mind. Often times, graduate students are new to bioinformatic skillsets and programs needed to perform their research. _GrabNGoGenomes_ can help students get started by disentangling the sequence search and download process into a more streamlined process. 

__To get started, visit the setup repo at [GnGG_setup](https://github.com/adc0032/GnGG_setup/blob/master/README.md)__

After using the setup repo above you can use the `get_SeqRec` and `pull_SeqRec` scripts contained in this repo. 
Usage explained through example:

### _Dependencies_

`GrabNGoGenomes` is a wrapper for two NCBI toolkits, _E-utilities_ and _SRA Toolkit_, used for searching and sharing data from biomedical and genomic databases of information. _E-utilities_ is set up during installation. Since these scripts are meant to be executed on an HPC, due to the large storage and computational resources required, please use your cluster's syntax for loading the _SRA Toolkit_ module.

```bash
[user@hostname](~)[22:55]: module load sratoolkit/2.8.0
```
**Note:** module name and program version may vary. Please search user modules for more information.

### get_SeqRec and pull_SeqRec
####  `get_SeqRec`


`get_SeqRec` will download SRA run info when given an input of an organism name (this can be genus or species scientific name as well as a common name).

```bash
[user@hostname](~)[22:55]:get_SeqRec -F "Microcebus rufus" WGS
```
`get_SeqRec` has two options;
partial and full. The partial option will obtain SRA run info for all nucleotide sequences of a given organism (but not the sequences themself) and print them out in two easy-to-read tab-delimited file (one with all reads and one that filters out non-public sequences). The full option will obtain the same info and it will create an accession file that it will use to obtain sequences. If you use the partial mode and not the full mode but later want to obtain sequences then you can filter out the SSR numbers from your filtered file and run that through pull_SeqRec, which will obtain your seqeunces in the same manner as get_SeqRec full mode. Further infomation about the scripts can be found using the -h flag while running the scripts.

### _Troubleshooting_
The `xtract` command present in `get_SeqRec` script should be included in the edirect download. However, if you are receiving an error claiming you do not have xtract then try using the following commands to download xtract:

``` bash
ftp-cp ftp.ncbi.nlm.nih.gov /entrez/entrezdirect xtract.Linux.gz
gunzip -f xtract.Linux.gz
chmod +x xtract.Linux
```
After this, replace `xtract` anywhere in `get_SeqRec` with `xtract.Linux` and this should solve the issue.
