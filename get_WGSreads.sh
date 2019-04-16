#!/bin/bash

if [[ $1 == "-h" ]]; then

    echo "Enter search query organism for lists of sequence run accession information."
    echo "Script will provide a tab delimited table including SRR & SRS, library information, Scientific Name, sequencer informoation, and consent information for the organism"
    echo "Script will also create a file with a list of run IDs for WGS data from queried organism; use awk/grep on provided SRA_info file to create filtered lists to provide to sequence downloader, seq_pull.sh "



elif [[ $# -lt 1 ]]; then

        echo "Please provide Organism for a table of NCBI's sequence information. Try -h for help"
        exit 0
else
    touch $1.SRA_info.txt
    echo -e "Run\tSize\tLibraryType\tSample#\tSciName" >> $1.SRA_info.txt
    esearch -db sra -query "$1 [ORGN]"|
    efetch -format runinfo -mode xml |
    xtract -pattern Row -tab "\t" -sep "," -def "BLANK" -element Run bases LibraryStrategy Sample ScientificName |
    awk -F "\t" '$3=="WGS"{print $0}' >> $1.SRA_info.txt
fi

Entries=$(tail -n +2 $1.SRA_info.txt | wc -l)
echo "$Entries entries found. See $1.SRA_info.txt for more information"
