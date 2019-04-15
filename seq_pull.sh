#!/bin/bash

module load sratooklkit.2.9.6-centos_linux64

$DATE= date | awk'{OFS="_"}{print $2,$3}'

mkdir seq_files_$DATE

cd seq_files

awk $1 file.txt > Run_list.txt

for: Run in $(cat Run_list.txt)
    do
    fastq-dump -I $Run
    Done
