#!/bin/bash

if [[ $1 == "-h" ]]; then

    echo "Enter search query organism for lists of sequence run accession information."
    echo "Script file with a tab delimited table including SRA, /# of bases, Library Type, Sample, and Scientific Name"


elif [[ $# -lt 1 ]]; then

        echo "Please provide Organism for a table of NCBI's sequence information. Try -h for help"
        exit 0

#This elif statement essentially duplicates the else statement but requires an input of two arguments and the search/filenames are now $1$2 instead of ust $1
elif [[ $# == 2 ]]; then
    touch $1$2.SRA_info.txt
    echo -e "Run\tSize\tLibraryType\tSample#\tSciName" >> $1$2.SRA_info.txt
    esearch -db sra -query "$1 $2 [ORGN]"|
    efetch -format runinfo -mode xml |
    xtract -pattern Row -tab "\t" -sep "," -def "BLANK" -element Run bases LibraryStrategy Sample ScientificName |
    awk -F "\t" '$3=="WGS"{print $0}' >> $1$2.SRA_info.txt

else
    touch $1.SRA_info.txt
    echo -e "Run\tSize\tLibraryType\tSample#\tSciName" >> $1.SRA_info.txt
    esearch -db sra -query "$1 [ORGN]"|
    efetch -format runinfo -mode xml |
    xtract -pattern Row -tab "\t" -sep "," -def "BLANK" -element Run bases LibraryStrategy Sample ScientificName |
    awk -F "\t" '$3=="WGS"{print $0}' >> $1.SRA_info.txt
fi

#The above addition requires that our word count also be duplicated so that an argument of two is required and the filenames are $1$2 instead of $1.
if [[ $# == 2 ]]; then
    Entries=$(tail -n +2 $1$2.SRA_info.txt | wc -l)
    echo "$Entries entries found. See $1$2.SRA_info.txt for more information"

else
    Entries=$(tail -n +2 $1.SRA_info.txt | wc -l)
    echo "$Entries entries found. See $1.SRA_info.txt for more information"
fi
