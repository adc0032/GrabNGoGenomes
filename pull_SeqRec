#!/bin/bash


if [[ $1 == "-h" ]]; then

    echo "Usage: seq_pull.sh [USER_ORGANISM] (name used in previous script)"
    echo "Provide organism name used in get_WGSreads.sh"
    echo "Provide file to input a file file with sequence run accessions for downloading associated sequences to a directory."
    echo "If a file is not provided, the script will error out."
    echo "Run get_SeqReads -F USER_ORGANISM RNA-seq to get SRR list to input into seq_pull.sh. This script requires SRA Toolkit, please load local/cluster module."

elif [[ $# -lt 2 ]]; then

    echo "Please provide an organism followed by a list of SRR IDs. run get_SeqReads -F USR_ORGN RNA-seq for example input file. Try -h for help"
    exit 0

else

    org=$1
    genus=$(echo $org|awk '{print $1}')
    species=$(echo $org|awk '{print $2}')
    cdate=$(date|awk '{OFS="_"}{print $2,$3}')

##only useful at command line 
#    read -e -p "Enter run accession list filename (run 'get_SeqReads -F' for example output file): " runs
    echo " "
    echo "File used: $2"
    runs=$2

    asc="sra/2.8.1"
    pbs="sratoolkit/2.8.0"

    if [[ ! -s $runs ]]; then
        echo "File is empty. Please provide SRR list; try seq_pull.sh -h for more information"
        exit 0
    else

        ##Modules and Variables
        if [ "${HOSTNAME:0:9}" == "dmcvlogin" ]; then
                module load $asc
                echo "Loaded SRA Toolkit: $asc "
        fi

        if [ -n "$PBS_JOBNAME" ]; then
                module load $pbs
                echo "Loaded SRA Toolkit: $pbs "

        fi
        echo " "
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
