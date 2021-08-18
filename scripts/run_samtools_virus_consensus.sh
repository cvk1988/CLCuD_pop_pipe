#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#SBATCH -N 1
#SBATCH -n 28
#SBATCH --mem=168G
#SBATCH -t 48:00:00

# calls the profile variable to pull sample names from a list iteratively
SMPLE=`head -n +${PBS_ARRAY_TASK_ID} $PROFILE | tail -n 1`


samtools mpileup -uf /home/u32/corykeith/reference_genomes/CLCuMuV_WA01_circle_sim.fasta  ${OUT_DIR}/${SMPLE}/bowtie2/alignments/${SMPLE}_virus_sorted.bam  | bcftools call -c | vcfutils.pl vcf2fq > ${SMPLE}_virus_consensus.fa


