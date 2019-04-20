# Grab-N-Go Genomes (GrabNGoGenomes): Automating Sequence Data Retrieval
## Purpose: Wrapper used to search NCBI's SRA database through Entrez's E-utilities (v) for sequence data and download sequencing data using NCBI's SRA Toolkit (v) 

### _Introduction_
_Grab-N-Go Genomes: Automating Sequence Data Retrieval_ 

_GrabNGoGenomes_ was created with the "intro to biocomputing" student in mind. Often times, graduate students are new to bioinformatic skillsets and programs needed to perform their research. _GrabNGoGenomes_ can help students get started by disentangling the sequence search and download process into a more streamlined process. 

__To get started, visit the setup repo at [GnGG_setup](https://github.com/adc0032/GnGG_setup/blob/master/README.md)__

After using the setup repo above you can use the `get_SeqRec` and `pull_SeqRec` scripts contained in this repo. 
Usage explained through example:

### _Dependencies_

_GrabNGoGenomes_ is a wrapper for two NCBI toolkits, _E-utilities_ and _SRA Toolkit_, used for searching and sharing data from biomedical and genomic databases of information. _E-utilities_ is set up during installation. Since these scripts are meant to be executed on an HPC, due to the large storage and computational resources required, please use your cluster's syntax for loading the _SRA Toolkit_ module. Add a `module load USER_VERSION_SRA-TOOLKIT` statement to your job header.

```bash
[user@hostname](~)[22:55]: module load sratoolkit/2.8.0
```
**Note:** Above is an example command, module name and version will vary. Please search user modules for more information.


### _Getting Sequence Information_
#### Usage and Arguments

Scripts require **three** arguments. 

```bash
get_SeqRec [-F|-P] ["QUERY_ORGANISM"|"Q_Genus Q_species"] [WGS|WXS|AMPLICON|RNA-Seq|RAD-Seq|ChIP-Seq|Hi-C]
```
```bash
pull_SeqRec [-F|-P] ["QUERY_ORGANISM"|"Q_Genus Q_species"] [WGS|WXS|AMPLICON|RNA-Seq|RAD-Seq|ChIP-Seq|Hi-C]
```

**All arguments are case-sensitive and require correct syntax to produce desired results**
Further infomation about the scripts can be found using the -h flag or simply calling the script

```bash
pull_SeqRec -h
```
```bash
get_SeqRec
```

#### Partial Mode (-P) v Full Mode (-F)
_GrabNGoGenomes_ can be run in two modes, partial and full. The partial option will obtain SRA run info for all nucleotide sequences of a given organism (but not the sequences themself) and print them out in two easy-to-read tab-delimited files (one with all archived results that are public and have"SRR#" run IDs, and one that filters by a user specified sequencing method).

```bash
[user@hostname](~)[22:55]: get_SeqRec -P "Microcebus rufus" WGS
```

Output example:

```bash
[user@hostname](Microcebusrufus~Apr_20)[22:55]: cat ~GrabNGoGenomes/Microcebusrufus~Apr_20/Microcebusrufus~full_SRA_info_Apr_20.txt
Run_ID    Lib_Size(MB)    Lib_Type    Sample_ID    Scientific_Name    Sequencing_Platform    Model    Consent        Apr_20
SRR3496213	428	WGS	SRS1412880	Microcebus rufus	ILLUMINA	NextSeq 500	public
SRR3496243	324	WGS	SRS1412880	Microcebus rufus	ILLUMINA	NextSeq 500	public
```

**Partial mode requires the use of the both `get_SeqRec` and `pull_SeqRec` scripts to obtain sequences.** Partial mode allows user to filter data with their own parameters. `pull_SeqRec` requires a list of SRR numbers. If user desires sequences, create a file with a list of SRR numbers (See Full Mode output for example) and provide list as an argument to `pull_SeqRec`, which will obtain your seqeunces in the same manner as get_SeqRec full mode.

#############
```bash

```

```bash
[user@hostname](Microcebusrufus~Apr_20)[22:55]: cat ~GrabNGoGenomes/Microcebusrufus~Apr_20/Microcebusrufus~run_accession_Apr_20.txt
SRR3496213
SRR3496243
SRR3496245
SRR3496215

```

####  `get_SeqRec`



```bash
[user@hostname](~)[22:55]:get_SeqRec -F "Microcebus rufus" WGS
```

`get_SeqRec` will download SRA run info when given an input of an organism name (this can be genus or species scientific name as well as a common name). Query organisms should be formatted with quotes (ex: `"Microcebus"`, `"Microcebus rufus"`, `"dog"`)

`get_SeqRec` has two options;partial and full. The partial option will obtain SRA run info for all nucleotide sequences of a given organism (but not the sequences themself) and print them out in two easy-to-read tab-delimited file (one with all reads and one that filters out non-public sequences). The full option will obtain the same info and it will create an accession file that it will use to obtain sequences. If you use the partial mode and not the full mode but later want to obtain sequences then you can filter out the SSR numbers from your filtered file and run that through pull_SeqRec, which will obtain your seqeunces in the same manner as get_SeqRec full mode. Further infomation about the scripts can be found using the -h flag while running the scripts.

### _Troubleshooting_
The `xtract` command present in `get_SeqRec` script should be included in the edirect download. However, if you are receiving an error claiming you do not have xtract then try using the following commands to download xtract:

``` bash
ftp-cp ftp.ncbi.nlm.nih.gov /entrez/entrezdirect xtract.Linux.gz
gunzip -f xtract.Linux.gz
chmod +x xtract.Linux
```
After this, replace `xtract` anywhere in `get_SeqRec` with `xtract.Linux` and this should solve the issue.
