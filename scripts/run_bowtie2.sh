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



# calls the profile variable to pull sample names from a list iteratively
SMPLE=`head -n +${PBS_ARRAY_INDEX} $PROFILE | tail -n 1`
#gives the full name of the file of raw data
F1="${SMPLE}_R1_001.fastq"
R1="${SMPLE}_R2_001.fastq"

# makes directory for individual samples for each sample
#export BOWOUT="$SAMPLE_DIR/bowtie2/unused_reads"
#init_dir "$BOWOUT"

### my thoughts on how to make the directory write to the correct folder?
#if "${SMPLE}" == "${BOWOUT}


echo "$BOWTIE/bowtie2 --un-conc $BOWOUT/cotton_rm.fastq -x $INDEX/gossypium_hirsutum.fasta -q -1 $RAW/$F1 -q -2 $RAW/$R1 -S $OUT_DIR/bowtie2/${SMPLE}.SAM"

$BOWTIE/bowtie2 --un-conc ${BOWOUT}/${SMPLE}_cotton_rm.fastq -x $INDEX/gossypium_hirsutum.fasta -q -1 $RAW/$F1 -q -2 $RAW/$R1 -S ${SAMPLE_DIR}/bowtie2/${SMPLE}.SAM
