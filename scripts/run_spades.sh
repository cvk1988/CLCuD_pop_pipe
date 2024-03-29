#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#PBS -l select=1:ncpus=28:mem=168gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00

#--------------------------------------------------------------------
# makes directory stucture?
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}
# -------------------------------------------------------------------

SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`

F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"

export SAMPLE_FOLD="$SPADESOUT/${SAMPLE}"
init_dir "$SAMPLE_FOLD"

$SPADES/spades.py --isolate -o $SAMPLE_FOLD -1 $BOWOUT/${SAMPLE}_virus_rm.1.fastq -2 $BOWOUT/${SAMPLE}_virus_rm.2.fastq


