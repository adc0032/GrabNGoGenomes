#!/bin/bash


if [[ $1 == "-h" ]]; then

    echo "Usage: seq_pull.sh [ORGANISM] [ORGANISM.run_accession.DATE.txt]"
    echo "Include organism name and file with sequence run accessions for downloading associated sequences to a directory"
    echo "Run get_WGSreads.sh USER_ORGANISM to get SRR list to input into seq_pull.sh"

elif [[ $# -lt 2 ]]; then

    echo "Please provide an organism and the associated run accession list file to download sequences. Try -h for help"
    exit 0

else
    if [[ ! -f $2 ]]; then
        echo "Please enter run accession file name after organism name (position 2)"
        exit 0
    else

        if [[ ! -s $2 ]]; then
            echo "File is empty. Please provide SRR list; try seq_pull.sh -h for more information"
        else
            ##Modules and Variables
            module load sra/2.8.1
            echo "Loaded SRA Toolkit version 2.8.1"
            echo " "
            cdate=$(date|awk '{OFS="_"}{print $2,$3}')

            mkdir $1~files_$cdate
            cd $1~files_$cdate

            echo "Created the following directory for sequencing reads: $1~files_$cdate/"
            echo " "
            echo "====================================================="


            add=0
            for run in $(cat ../$2 ); do
                let add++
                tot=$(cat ../$2|wc -l)
                fastq-dump --split-files -I $run
                gzip *.fastq


                echo "$add of $tot sequences downloaded & zip compressed"
                echo "----------------------------------------"
            done


            echo " "
            echo "====================================================="
            echo "Downloader Complete! Sequences can be found in $1~files_$cdate"
        fi
    fi
fi
