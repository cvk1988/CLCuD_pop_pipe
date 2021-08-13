#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#SBATCH -N 1
#SBATCH -n 28
#SBATCH --mem=168G

#SBATCH -t 48:00:00

# calls the profile variable to pull sample names from a list iteratively
export SMPLE=`head -n +${SLURM_ARRAY_TASK_ID} $PROFILE | tail -n 1`

# calls individual sample directory
export BOWOUT="${SMPLE}/bowtie2/unused_reads"

echo "$BOWTIE/bowtie2 --un-conc $BOWOUT/${SMPLE}_beta_rm.fastq -x $INDEX/CLCuMB_WA01_circle_sim.fasta -q -1 "$BOWOUT"/${SMPLE}_cotton_rm.1.fastq -q -2 "$BOWOUT"/${SMPLE}_cotton_rm.2.fastq -S "$OUT_DIR"/bowtie2/${SMPLE}_beta.SAM"

$BOWTIE/bowtie2 --un-conc ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_beta_rm.fastq" -x $INDEX/CLCuMB_WA01_circle_sim.fasta -q -1 ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_cotton_rm.1.fastq" -q -2 ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_cotton_rm.2.fastq" -S ${OUT_DIR}/${SMPLE}/bowtie2/alignments/${SMPLE}_beta.SAM


