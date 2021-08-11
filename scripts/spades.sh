#!/bin/sh

# Your job will use 1 node, 28 cores, and 168gb of memory total.
#PBS -l select=1:ncpus=28:mem=168gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00

source config.sh

"$SPADES"/spades.py --isolate -o "$SPADESOUT" -1 "$BOWOUT"/unused_reads/virus_rm.1.fastq -2 "$BOWOUT"/unused_reads/virus_rm.2.fastq


