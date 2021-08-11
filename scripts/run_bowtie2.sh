#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#SBATCH -N 1
#SBATCH -n 28
#SBATCH --mem=168G

#SBATCH -t 48:00:00


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



# calls the profile variable to pull sample names from a list iteratively
export SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`

#gives the full name of the file of raw data
F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"

# calls individual sample directory
export BOWOUT="${SMPLE}/bowtie2/unused_reads"

# prints command to terminal
echo "$BOWTIE/bowtie2 --un-conc $BOWOUT/cotton_rm.fastq -x $INDEX/gossypium_hirsutum.fasta -q -1 $RAW/$F1 -q -2 $RAW/$R1 -S $OUT_DIR/bowtie2/${SMPLE}.SAM"

$BOWTIE/bowtie2 --un-conc ${OUT_DIR}/${SMPLE}/bowtie2/unused_reads/"${SMPLE}_cotton_rm.fastq" -x $INDEX/gossypium_hirsutum.fasta -q -1 $RAW/$F1 -q -2 $RAW/$R1 -S ${OUT_DIR}/${SMPLE}/bowtie2/${SMPLE}.SAM
