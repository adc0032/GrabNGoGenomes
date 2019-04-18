#!/bin/bash

if [[ $1 == "-h" || $1 == "" ]]; then
    echo "Usage: get_SeqReads [-F|-P] [USER_ORGANISM | \"USR_Genus USR_species\] [WGS|WXS|AMPL$
    echo "Enter search query organism for lists of sequence run archive information; If enteri$
    echo "Examples: get_SeqReads -P dog | get_SeqReads -F \"Canis lupis familaris\" RAD-Seq"
    echo "In partial mode (-P), script will provide a tab delimited table including SRR & SRS,$
    echo "use awk/grep on provided SRA_info file to create filtered lists to provide to sequen$
    echo "When running get_SeqReads in full mode (-F) library strategy must be included after $
    echo "Full mode creates a file with a list of run IDs from queried organism and downloads $
    exit 0


elif [[ $# -lt 3 ]]; then

    echo "Please indicate -F or -P for full or partial run, followed by a search organism,$
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
