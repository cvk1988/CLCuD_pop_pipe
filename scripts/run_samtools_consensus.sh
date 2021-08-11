#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#SBATCH -N [1[-1]]
#SBATCH -n [28]
#SBATCH --mem=[28][G]
#SBATCH --shared
#SBATCH -t [48:00:00]

# calls the profile variable to pull sample names from a list iteratively
SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`


samtools mpileup -uf -@ 16 /Users/roadegbola/cory/reference_genomes/CaMMV_MW052520_PR3_circle_sim.fasta /Volumes/EMPRESS/PROJECTS\ FOLDER/Badnaviruses/USDA\ 2021/results/USDA22_CSFP210001070-1a_H2N55DSX2_L2_CaMMV_rm.bam  | bcftools call -mv -Oz -o USDA22_variant.vcf.gz tabix USDA22_variant.vcf.gz cat /Users/roadegbola/cory/reference_genomes/CaMMV_MW052520_PR3_circle_sim.fasta | bcftools consensus USDA22_variant.vcf.gz > USDA22_consensus.fa


