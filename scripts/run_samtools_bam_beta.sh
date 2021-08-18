#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#PBS -l select=1:ncpus=28:mem=168gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00


### sample names from a list correlates to raw data
export SMPLE=`head -n +${SLURM_ARRAY_TASK_ID} $PROFILE | tail -n 1`

F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"

### directory for individual files go here

samtools view -bo ${OUT_DIR}/${SMPLE}/bowtie2/alignments/${SMPLE}_beta.SAM > ${OUT_DIR}/${SMPLE}/bowtie2/alignments/${SMPLE}_beta.bam | samtools sort ${OUT_DIR}/${SMPLE}/bowtie2/alignments/${SMPLE}_beta.bam  -o ${OUT_DIR}/${SMPLE}/bowtie2/alignments/${SMPLE}_beta_sorted.bam 




