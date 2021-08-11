#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#PBS -l select=1:ncpus=28:mem=168gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00


### sample names from a list correlates to raw data
SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`

F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"

### directory for individual files go here


$SAMTOOL/samtools fixmate -0 bam,level=1 -m #



