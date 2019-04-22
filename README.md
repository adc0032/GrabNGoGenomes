# Grab-N-Go Genomes (GrabNGoGenomes): Automating Sequence Data Retrieval

## Purpose: Wrapper used to search NCBI's SRA database through Entrez's E-utilities (10.9) for sequence data and download sequencing data using NCBI's SRA Toolkit (2.9.6) 

### _Introduction_
_Grab-N-Go Genomes: Automating Sequence Data Retrieval_ 

_Grab-N-GoGenomes_ was created with the "intro to biocomputing" student in mind. Often times, graduate students are new to bioinformatic skillsets and programs needed to perform their research. _GrabNGoGenomes_ can help students get started by disentangling the sequence search and download process into a more streamlined process. 

__To get started, visit the setup repo at [GnGG_setup](https://github.com/adc0032/GnGG_setup/blob/master/README.md)__

After using the setup repo above you can use the `get_SeqRec` and `pull_SeqRec` scripts contained in this repo. 
Usage explained through example:

### _Dependencies_

_Grab-N-GoGenomes_ is a wrapper for two NCBI toolkits, _E-utilities_ and _SRA Toolkit_, used for searching and sharing data from biomedical and genomic databases of information. _E-utilities_ is set up during installation. Since these scripts are meant to be executed on an HPC, due to the large storage and computational resources required, please use your cluster's syntax for loading the _SRA Toolkit_ module. Add a `module load USER_VERSION_SRA-TOOLKIT` statement to your job header.

```bash
[user@hostname](~)[22:55]: module load sra/2.8.1
```
**Note:** Above is an example command, module name and version will vary. Please search user modules for more information.


### _Getting Sequence Information_
#### Usage and Arguments


`get_SeqRec` requires **three** arguments
```
get_SeqRec [-F|-P] ["QUERY_ORGANISM"|"Q_Genus Q_species"] [WGS|WXS|AMPLICON|RNA-Seq|RAD-Seq|ChIP-Seq|Hi-C]
```
`pull_SeqRec` requires **two** arguments
```
pull_SeqRec ["QUERY_ORGANISM"|"Q_Genus Q_species"] [Run_accession_file]
```

**Arguments are case-sensitive and require correct syntax to produce desired results**
Further infomation about the scripts can be found using the -h flag or simply calling the script

```bash
pull_SeqRec -h
```
```bash
get_SeqRec
```

#### _Full Mode (-F) vs. Partial Mode (-P)_

##### Full Mode
_GrabNGoGenomes_ can be run in two modes, full and partial. The full option will obtain info for all nucleotide sequences of a given organism. `get_SeqRec` will download SRA run info when given an input of an organism name (this can be genus or species scientific name as well as a common name). Query organisms should be formatted with quotes (ex: `"Microcebus"`, `"Microcebus rufus"`, `"dog"`)

```bash
[user@hostname](~)[22:55]: get_SeqRec -F "Microcebus rufus" WGS
```
print them out in two easy-to-read tab-delimited files:

```
[user@hostname](Microcebusrufus~Apr_20)[22:55]: ls 
Microcebusrufus~full_SRA_info_Apr_20.txt
Microcebusrufus~filtered_SRA_info_Apr_20.txt
```

`Microcebusrufus~full_SRA_info_Apr_20.txt` contains archived results that are filtered for public consent and are SRR (vs. ERR or DRR) 

`Microcebusrufus~filtered_SRA_info_Apr_20.txt` filters the full results by a user-specified sequencing method.

Output example:

```bash
[user@hostname](Microcebusrufus~Apr_20)[22:55]: cat ~GrabNGoGenomes/Microcebusrufus~Apr_20/Microcebusrufus~full_SRA_info_Apr_20.txt

Run_ID    Lib_Size(MB)    Lib_Type    Sample_ID    Scientific_Name    Sequencing_Platform    Model    Consent        Apr_20
SRR3496213	428	WGS	SRS1412880	Microcebus rufus	ILLUMINA	NextSeq 500	public
SRR3496243	324	WGS	SRS1412880	Microcebus rufus	ILLUMINA	NextSeq 500	public
```

A list of run accessions is created:

```bash
[user@hostname](Microcebusrufus~Apr_20)[22:55]: cat ~GrabNGoGenomes/Microcebusrufus~Apr_20/Microcebusrufus~run_accession_Apr_20.txt
SRR3496213
SRR3496243
SRR3496245
SRR3496215
```

The script provides the accession list to _fastq-dump_, a module of _SRA Toolkit_, which downloads sequences for each accession. Sequences will be gzip compressed, split into two files (from paired-end libraries), and read (.1 or .2) suffixes are appended to the header line.

Output example:

```bash
[user@hostname](Microcebusrufus~files_Apr_20)[23:00] ls
SRR3496213_1.fastq.gz  
SRR3496215_1.fastq.gz  
SRR3496243_1.fastq.gz  
SRR3496245_1.fastq.gz

[user@hostname](Microcebusrufus~files_Apr_20)[23:00] zcat SRR3496213_1.fastq.gz | head -4
@SRR3496213.1.1 2_11101_18707_1025_1 length=146
CATGCAGGAAACTACCTTAACCCAAAGCAACAAGGTTCAAATAAAAATTAGTTCATTAAATAAAAAGTTGAATGAAGGAGAAAGACCATAAAAATAATAGGTATGTACTTTTGATATCTTTTGAACTTAAAACATATAAAAACACA
+SRR3496213.1.1 2_11101_18707_1025_1 length=146
/A/EAEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEAEAAEEEEEEEEEEEEEEEEE6EEEEEEEEEEEEE/EEEEEEEEEEE//AAEEEEAEEEEEAE/EAEEEEEEEE<AEEEEEEEE/6E6<EE/EEEAAE</E//<</
```
*Note: sequencing results were not paired end, hence the lack of SRR#\_2.fastq.gz files.*

##### Partial Mode

```bash
[user@hostname](~)[22:55]: get_SeqRec -P "Microcebus rufus" WGS
```
The partial option will obtain SRA run info just as described in full mode, but not the sequences themselves.

*Partial mode requires the use of the both `get_SeqRec` and `pull_SeqRec` scripts to obtain sequences.* 

This allows users to filter data with their own parameters. `pull_SeqRec` requires a list of SRR accessions. If user desires sequences, a file with SRR accession must be created (See Full Mode output for example) and provided to`pull_SeqRec` as an argument, which will obtain desired seqeunces.

```bash
awk '{print $1}' Microcebusrufus~filtered_SRA_info_Apr_20.txt| tail -n +2 > Microcebusrufus~run_accession_Apr_20.txt
```

This awk one-liner can be used on user-filtered files to create run accession lists appropriate for input into `pull_SeqRec`

```bash
[user@hostname](Microcebusrufus~files_Apr_20)[23:00] pull_SeqRec "Microcebus rufus" Microcebusrufus~run_accession_Apr_21.txt
```

### _Troubleshooting_
The `xtract` command present in `get_SeqRec` script should be included in the edirect download. However, if you are receiving an error claiming you do not have xtract then try using the following commands to download xtract:

``` bash
ftp-cp ftp.ncbi.nlm.nih.gov /entrez/entrezdirect xtract.Linux.gz
gunzip -f xtract.Linux.gz
chmod +x xtract.Linux
```
After this, replace `xtract` anywhere in `get_SeqRec` with `xtract.Linux` and this should solve the issue.

See Note in the dependencies section about SRA Toolkit
