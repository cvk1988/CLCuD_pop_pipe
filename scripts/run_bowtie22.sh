# Your job will use 1 node, 28 cores, and 168gb of memory total.
#PBS -l select=1:ncpus=28:mem=168gb
#PBS -l place=pack:shared
#PBS -l walltime=48:00:00

cd $RAW

for f in *_R1_001.fastq
    do
        r="${f##R1_001.fastq}R2_001.fastq"
outname="${f%%R1_001.fastq}"
"$BOWTIE"bowtie2 --un-conc "$BOWOUT"cotton_rm.fastq -x /xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/reference_genomes/bowtie2_indices/gossypium_hirsutum.fasta -q -1 /xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/capture_seq/raw/plate2/Plate2/RAPiD-Genomics_F159_UAZ_146201_P002_WA01_i5-515_i7-59_S269_L002_R1_001.fastq -q -2 /xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/capture_seq/raw/plate2/Plate2/RAPiD-Genomics_F159_UAZ_146201_P002_WA01_i5-515_i7-59_S269_L002_R2_001.fastq -S "$OUT_DIR"/bowtie2/"$outname".SAM


done
