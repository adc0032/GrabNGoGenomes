#!/bin/bash


if [[ $1 == "-h" ]]; then

    echo "Usage: seq_pull.sh [ORGANISM] [ORGANISM.run_accession.DATE.txt]"
    echo "Include organism name and file with sequence run accessions for downloading associated sequences to a directory"
    echo "Run get_WGSreads.sh USER_ORGANISM to get SRR list to input into seq_pull.sh"

elif [[ $# -lt 2 ]]; then

    echo "Please provide an organism and the associated run accession list file to download sequences. Try -h for help"
    exit 0

else
    ##Modules and Variables
    module load sra/2.8.1    
    cdate= $(date | awk'{OFS="_"}{print $2,$3}')

    mkdir seq_files_$cdate

    cd seq_files_$cdate

    for run in $(cat run_list.txt)
    do
    fastq-dump -I $run
    done

