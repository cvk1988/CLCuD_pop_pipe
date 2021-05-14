#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#PBS -l select=1:ncpus=28:mem=168gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00



SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`

F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"



echo "$BOWTIE/bowtie2 --un-conc $BOWOUT/${SMPLE}_beta_rm.fastq -x $INDEX/CLCuMB_WA01_circle_sim.fasta -q -1 "$BOWOUT"/${SMPLE}_cotton_rm.1.fastq -q -2 "$BOWOUT"/${SMPLE}_cotton_rm.2.fastq -S "$OUT_DIR"/bowtie2/${SMPLE}_beta.SAM"

$BOWTIE/bowtie2 --un-conc $BOWOUT/${SMPLE}_beta_rm.fastq -x $INDEX/CLCuMB_WA01_circle_sim.fasta -q -1 "$BOWOUT"/${SMPLE}_cotton_rm.1.fastq -q -2 "$BOWOUT"/${SMPLE}_cotton_rm.2.fastq -S "$OUT_DIR"/bowtie2/${SMPLE}_beta.SAM


