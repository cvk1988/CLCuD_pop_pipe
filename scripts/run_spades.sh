#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#SBATCH -N 1
#SBATCH -n 28
#SBATCH --mem=168G

#SBATCH -t 48:00:00


SMPLE=`head -n +${SLURM_ARRAY_TASK_ID} $PROFILE | tail -n 1`

F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"

export SPADESOUT="${SMPLE}"

$SPADES/spades.py --isolate -o ${OUT_DIR}/${SMPLE}/spades -1 ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_virus_rm.1.fastq" -2 ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_virus_rm.2.fastq"


