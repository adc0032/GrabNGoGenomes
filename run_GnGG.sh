#!/bin/bash

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load sra/2.8.1
module load pgi/12.1


cd $HOME

get_SeqRec -F "Grey wolf" RNA-Seq
