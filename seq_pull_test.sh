#!/bin/bash


if [[ $1 == "-h" ]]; then

    echo "Usage: seq_pull.sh [USER_ORGANISM] (name used in previous script)"
    echo "Provide organism name used in get_WGSreads.sh"
    echo "You will be prompted to input a file file with sequence run accessions for downloading associated sequences to a directory."
    echo "If a file is not provided, the script will default to the last created output from get_WGSreads.sh USER_ORGANISM."
    echo "Run get_WGSreads.sh USER_ORGANISM to get SRR list to input into seq_pull.sh"

elif [[ $# -lt 1 ]]; then

    echo "Please provide an organism. Try -h for help"
    exit 0

else
    
    org=$1
    genus=$(echo $org|awk '{print $1}')
    species=$(echo $org|awk '{print $2}')
    cdate=$(date|awk '{OFS="_"}{print $2,$3}')
    
    read -e -p "Enter run accession list filename (default is get_WGSreads.sh output file): " -i "$genus$species~run_accession.$cdate.txt" runs
    echo " "
    echo "File used: $runs"
    if [[ ! -s $runs ]]; then
        echo "File is empty. Please provide SRR list; try seq_pull.sh -h for more information"
    else
        ##Modules and Variables
        module load sra/2.8.1
        echo "Loaded SRA Toolkit version 2.8.1"
        echo " "

        mkdir $genus$species~files_$cdate
        sd="./$genus$species~files_$cdate/"
        
        echo "Created the following directory for sequencing reads: $sd"
        echo " "
        echo "====================================================="
    
        add=0
        for run in $(cat $runs ); do
            let add++
            tot=$(cat $runs|wc -l)
            fastq-dump -v --split-files -I --gzip -O $sd $run
        

            echo "$add of $tot sequences downloaded to $sd"
            echo "----------------------------------------"
        done
    

        echo " "
        echo "====================================================="
        echo "Downloader Complete! Sequences can be found in $sd"
        
    fi
fi

