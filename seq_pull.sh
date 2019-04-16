#!/bin/bash


##Modules and Variables

module load sratooklkit.2.9.6-centos_linux64
#for redundant runs making variable for date to include on directory for sequence output
cdate= $(date | awk'{OFS="_"}{print $2,$3}')

mkdir seq_files_$cdate

cd seq_files_$cdate

for run in $(cat run_list.txt)
do
    fastq-dump -I $run
done

