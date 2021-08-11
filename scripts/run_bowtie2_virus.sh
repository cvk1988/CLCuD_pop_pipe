#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#SBATCH -N 1
#SBATCH -n 28
#SBATCH --mem=168G

#SBATCH -t 48:00:00


SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`

F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"


export BOWOUT="${SMPLE}/bowtie2/unused_reads"

$BOWTIE/bowtie2 --un-conc ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_virus_rm.fastq" -x ${INDEX}/CLCuMuV_WA01_circle_sim.fasta -q -1 ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_beta_rm.1.fastq" -q -2 ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_beta_rm.2.fastq" -S ${OUT_DIR}/${SMPLE}/bowtie2/${SMPLE}_virus.SAM


