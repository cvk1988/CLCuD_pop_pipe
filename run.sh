#!/bin/sh
set -u
#
# Checking args
#
source ./config.sh
#
#makes sure sample file is in the right place
#
if [[ ! -f "$PROFILE" ]]; then
    echo "$PROFILE does not exist. Please provide the path for a metagenome profile. Job terminated."
    exit 1
fi
#
# creates outdir
#
if [[ ! -d "$OUT_DIR" ]]; then
    echo "$OUT_DIR does not exist. The folder was created."
    mkdir $OUT_DIR
fi
## new code with a "while loop" this builds individual directories from the list of samples in the profile list
while read SAMPLE; do
  echo "$SAMPLE"
    export SAMPLE_DIR="$OUT_DIR/$SAMPLE"
    export BOWOUT="$SAMPLE_DIR/bowtie2/unused_reads"   
    export SPADESOUT="$SAMPLE_DIR/spades"
    export ALNMNTOUT="$SAMPLE_DIR/bowtie2/alignments"
    export CONSENSUS="$SAMPLE_DIR/consensus"
    init_dir "$SAMPLE_DIR" "$BOWOUT" "$SPADESOUT" "$ALNMNTOUT" "$CONSENSUS"
done <$PROFILE




#
# Job submission
# 
ARGS="-p $QUEUE --account=$GROUP --mail-user $MAIL_USER --mail-type $MAIL_TYPE"

#
# Bowtie2 to cotton
#

Prog="Bowtie2_filter_cotton"
export STDERR_DIR="$SCRIPT_DIR/err/$Prog"
export STDOUT_DIR="$SCRIPT_DIR/out/$Prog"
init_dir "$STDERR_DIR" "$STDOUT_DIR"

# how many jobs in the array
export NUM_JOB=$(wc -l < "$PROFILE")


echo "$BOWTIE"
echo "launching $SCRIPT_DIR/run_bowtie2.sh as a job."
#-a tells the number of jobs to submit to the PBS array
JOB_ID=`sbatch $ARGS --export=ALL,BOWOUT=$BOWOUT,SAMPLE_DIR=$SAMPLE_DIR,BOWTIE=$BOWTIE,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR=$STDERR_DIR,STDOUT_DIR=$STDOUT_DIR,INDEX=$INDEX,RAW=$RAW,PROFILE=$PROFILE,ALNMNTOUT=$ALNMNTOUT -o $STDOUT_DIR/output.%a.out -e $STDERR_DIR/err.%a.out --job-name remove_cotton -a 1-$NUM_JOB $SCRIPT_DIR/run_bowtie2.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi

#
# Bowtie2 to beta
#

Prog2="Bowtie2_filter_beta"
export STDERR_DIR2="$SCRIPT_DIR/err/$Prog2"
export STDOUT_DIR2="$SCRIPT_DIR/out/$Prog2"
init_dir "$STDERR_DIR2" "$STDOUT_DIR2"

echo " launching $SCRIPT_DIR/run_bowtie2_beta.sh in queue"
echo "previous job ID $PREV_JOB_ID"

JOB_ID=`sbatch $ARGS --export=ALL,BOWOUT=$BOWOUT,SAMPLE_DIR=$SAMPLE_DIR,BOWTIE=$BOWTIE,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR2=$STDERR_DIR2,STDOUT_DIR2=$STDOUT_DIR2,INDEX=$INDEX,RAW=$RAW,PROFILE=$PROFILE,ALNMNTOUT=$ALNMNTOUT --job-name align_beta -o $STDOUT_DIR2/output.%a.out -e $STDERR_DIR2/err.%a.out --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_bowtie2_beta.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi

#
# Bowtie2 to virus
#

Prog3="Bowtie2_filter_virus"
export STDERR_DIR3="$SCRIPT_DIR/err/$Prog3"
export STDOUT_DIR3="$SCRIPT_DIR/out/$Prog3"
init_dir "$STDERR_DIR3" "$STDOUT_DIR3"

echo " launching $SCRIPT_DIR/run_bowtie2_virus.sh in queue"
echo "previous job ID $PREV_JOB_ID"

JOB_ID=`sbatch $ARGS --export=ALL,BOWOUT=$BOWOUT,SAMPLE_DIR=$SAMPLE_DIR,BOWTIE=$BOWTIE,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR3=$STDERR_DIR3,STDOUT_DIR3=$STDOUT_DIR3,INDEX=$INDEX,RAW=$RAW,PROFILE=$PROFILE,ALNMNTOUT=$ALNMNTOUT --job-name align_virus -o $STDOUT_DIR3/output.%a.out -e $STDERR_DIR3/err.%a.out --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_bowtie2_virus.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi

#
#SPADES with unused reads
#

Prog4="SPADES_unused_reads"
export STDERR_DIR4="$SCRIPT_DIR/err/$Prog4"
export STDOUT_DIR4="$SCRIPT_DIR/out/$Prog4"
init_dir "$STDERR_DIR4" "$STDOUT_DIR4"


echo " launching $SCRIPT_DIR/run_spades.sh in queue"
echo "previous job ID $PREV_JOB_ID"

JOB_ID=`sbatch $ARGS --export=ALL,BOWOUT=$BOWOUT,SAMPLE_DIR=$SAMPLE_DIR,BOWTIE=$BOWTIE,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR4=$STDERR_DIR4,STDOUT_DIR4=$STDOUT_DIR4,PROFILE=$PROFILE,SPADES=$SPADES,SPADESOUT=$SPADESOUT --job-name denovo_unused -o $STDOUT_DIR4/output.%a.out -e $STDERR_DIR4/err.%a.out --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_spades.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi




#
#samtools virus sam to sorted bam with alignments
#

Prog5="SAM2BAM_virus"
export STDERR_DIR5="$SCRIPT_DIR/err/$Prog5"
export STDOUT_DIR5="$SCRIPT_DIR/out/$Prog5"
init_dir "$STDERR_DIR5" "$STDOUT_DIR5"


echo " launching $SCRIPT_DIR/run_samtools_bam_virus.sh in queue"
echo "previous job ID $PREV_JOB_ID"

JOB_ID=`sbatch $ARGS --export=ALL,SAMPLE_DIR=$SAMPLE_DIR,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR5=$STDERR_DIR5,STDOUT_DIR5=$STDOUT_DIR5,PROFILE=$PROFILE --job-name sam2bam -o $STDOUT_DIR5/output.%a.out -e $STDERR_DIR5/err.%a.out --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_samtools_bam_virus.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi

#
#samtools virus sam to sorted bam with alignments
#

Prog6="SAM2BAM_beta"
export STDERR_DIR6="$SCRIPT_DIR/err/$Prog6"
export STDOUT_DIR6="$SCRIPT_DIR/out/$Prog6"
init_dir "$STDERR_DIR6" "$STDOUT_DIR6"


echo " launching $SCRIPT_DIR/run_samtools_bam_beta.sh in queue"
echo "previous job ID $PREV_JOB_ID"

JOB_ID=`sbatch $ARGS --export=ALL,SAMPLE_DIR=$SAMPLE_DIR,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR6=$STDERR_DIR6,STDOUT_DIR6=$STDOUT_DIR6,PROFILE=$PROFILE --job-name sam2bam -o $STDOUT_DIR6/output.%a.out -e $STDERR_DIR6/err.%a.out --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_samtools_bam_beta.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi

#
#samtools virus sam to sorted bam with alignments
#

Prog7="BAM2FQ_virus"
export STDERR_DIR7="$SCRIPT_DIR/err/$Prog7"
export STDOUT_DIR7="$SCRIPT_DIR/out/$Prog7"
init_dir "$STDERR_DIR7" "$STDOUT_DIR7"


echo " launching $SCRIPT_DIR/run_samtools_consensus_virus.sh in queue"
echo "previous job ID $PREV_JOB_ID"

JOB_ID=`sbatch $ARGS --export=ALL,SAMPLE_DIR=$SAMPLE_DIR,WORKER_DIR=$WORKER_DIR,OUT_DIR=$OUT_DIR,STDERR_DIR7=$STDERR_DIR7,STDOUT_DIR7=$STDOUT_DIR7,PROFILE=$PROFILE --job-name sam2bam -o $STDOUT_DIR7/output.%a.out -e $STDERR_DIR7/err.%a.out --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_samtools_virus_consensus.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi


