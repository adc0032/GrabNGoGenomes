# Grab-N-Go Genomes (GrabNGoGenomes): Automating Sequence Data Retrieval
## Purpose: Wrapper used to search NCBI's SRA database through Entrez's E-utilities (v) for sequence data and download sequencing data using NCBI's SRA Toolkit (v) 

### _Introduction_
_Grab-N-Go Genomes: Automating Sequence Data Retrieval_ 

`GrabNGoGenomes` was created with the "intro to bicomputing" student in mind. Often times, graduate students are new to bioinformatic skillsets and programs needed to perform their research. `GrabNGoGenomes` can help students get started by disentangling the sequence search and download process into a more streamlined process.

__To get started, visit the setup repo at [GnGG_setup](https://github.com/adc0032/GnGG_setup/blob/master/README.md)__

### _Troubleshooting_
The `xtract` command present in `get_SeqRec` script should be included in the edirect download. However, if you are receiving an error claiming you do not have xtract then try using the following commands to download xtract:

``` bash
ftp-cp ftp.ncbi.nlm.nih.gov /entrez/entrezdirect xtract.Linux.gz
gunzip -f xtract.Linux.gz
chmod +x xtract.Linux
```
After this, replace `xtract` anywhere in `get_SeqRec` with `xtract.Linux` and this should solve the issue.
