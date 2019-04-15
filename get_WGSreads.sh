#!/bin/bash

if [[ $1 == "-h" ]]; then

    echo "Enter search query organism for lists of sequence run accession information."
    echo "Script file with a tab delimited table including SRA, /# of bases, Library Type, Sample"


elif [[ $# -lt 1 ]]; then

        echo "Please provide Organism for a table of NCBI's sequence information. Try -h for help"
        exit 0
else
    touch $1.SRA_info.txt
    echo  "Run  Size    LibraryType Sample# SciName" >> $1.SRA_info.txt
    esearch -db sra -query "$1 [ORGN]"|
    efetch -format runinfo -mode xml |
    xtract -pattern Row -tab "\t" -sep "," -def "BLANK" -element Run bases LibraryStrategy Sample ScientificName |
    awk -F "\t" '$3=="WGS"{print $0}' >> $1.SRA_info.txt
fi

Entries=$(tail -n +2 $1.SRA_info.txt | wc -l)
echo "$Entries entries found. See $1.SRA_info.txt for more information"
