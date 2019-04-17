#!/bin/bash

if [[ $1 == "-h" || $1 == '' ]]; then
####Telling user that if using scientific name, USER_ORGANISM must be in quotes
    echo "Usage: get_WGSread.sh USER_ORGANISM or \"USR_Genus USR_species\""
    echo "Enter search query organism for lists of sequence run accession information; If entering name with more than one word, use quotes"
    echo "Example: get_WGSread.sh dog | get_WGSread.sh \"Canis lupis familaris\""
    echo "Script will provide a tab delimited table including SRR & SRS, library information, Scientific Name, sequencer informoation, and consent information for the organism"
    echo "Script will also create a file with a list of run IDs for WGS data from queried organism; use awk/grep on provided SRA_info file to create filtered lists to provide to sequence downloader, seq_pull.sh "
    exit 1


elif [[ $# -lt 1 ]]; then

        echo "Please provide organism for a table of NCBI's sequence information. Try -h for help"
        exit 0
else
###assigning positional argument to variable "org" that can be used for further manipulation 
    org=$1
    genus=$(echo $org|awk '{print $1}')
    species=$(echo $org|awk '{print $2}')
    cdate=$(date|awk '{OFS="_"}{print $2,$3}')
    echo "Run_ID    Lib_Size(MB)    Lib_Type    Sample_ID    Scientific_Name    Sequencing_Platform    Model    Consent        $cdate" > $genus$species~SRA_info_$cdate.txt
    esearch -db sra -query "$org [ORGN]"|
    efetch -format runinfo -mode xml |
    xtract -pattern Row -tab "\t" -sep "," -def "BLANK" -element Run size_MB LibraryStrategy Sample ScientificName Platform Model Consent |
    awk -F "\t" '$3=="WGS"{print $0}' >> $genus$species~SRA_info_$cdate.txt
fi


awk '{print $1}' $genus$species~SRA_info_$cdate.txt| tail -n +2 > $genus$species~run_accession.$cdate.txt

Entries=$(tail -n +2 $genus$species~SRA_info_$cdate.txt | wc -l)
echo "$Entries entries found. Run IDs for sequence download is availabe as $genus$species~run_accession.$cdate.txt. See $genus$species~SRA_info_$cdate.txt for more information"
