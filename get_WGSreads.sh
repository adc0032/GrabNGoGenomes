#!/bin/bash

if [[ $1 == "-h" ]]; then

    echo "Enter search query organism for lists of sequence run accession information."
    echo "Script will provide a tab delimited table including SRR & SRS, library information, Scientific Name, sequencer informoation, and consent information for the organism"
    echo "Script will also create a file with a list of run IDs for WGS data from queried organism; use awk/grep on provided SRA_info file to create filtered lists to provide to sequence downloader, seq_pull.sh "



elif [[ $# -lt 1 ]]; then

        echo "Please provide organism for a table of NCBI's sequence information. Try -h for help"
        exit 0
else
    cdate=$(date|awk '{OFS="_"}{print $2,$3}')
    echo "Run_ID    Lib_Size(MB)    Lib_Type    Sample_ID    Scientific_Name    Sequencing_Platform    Model    Consent        $cdate" > $1.SRA_info_$cdate.txt
    esearch -db sra -query "$1 [ORGN]"|
    efetch -format runinfo -mode xml |
    xtract -pattern Row -tab "\t" -sep "," -def "BLANK" -element Run size_MB LibraryStrategy Sample ScientificName Platform Model Consent |
    awk -F "\t" '$3=="WGS"{print $0}' >> $1.SRA_info_$cdate.txt
fi


awk '{print $1}' $1.SRA_info_$cdate.txt| tail -n +2 > $1.run_accession.$cdate.txt

Entries=$(tail -n +2 $1.SRA_info_$cdate.txt | wc -l)
echo "$Entries entries found. Run IDs for sequence download is availabe as $1.run_accession.$cdate.txt. See $1.SRA_info_$cdate.txt for more information"
