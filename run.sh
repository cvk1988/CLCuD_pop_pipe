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
    export ALNMNTOUT="$SAMPLE_DIR/alignments"
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



echo "launching $SCRIPT_DIR/run_bowtie2.sh as a job."
#-a tells the number of jobs to submit to the PBS array
JOB_ID=`sbatch $ARGS --export=[BOWOUT,SAMPLE_DIR,BOWTIE,WORKER_DIR,OUT_DIR,STDERR_DIR,STDOUT_DIR,INDEX,RAW,PROFILE] --job-name remove_cotton -e "$STDERR_DIR" -o "$STDOUT_DIR" -a 1-$NUM_JOB $SCRIPT_DIR/run_bowtie2.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job"}

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

JOB_ID=`sbatch $ARGS --export=[BOWOUT,SAMPLE_DIR,BOWTIE,WORKER_DIR,OUT_DIR,STDERR_DIR2,STDOUT_DIR2,INDEX,PROFILE] --job-name align_beta -e "$STDERR_DIR2" -o "$STDOUT_DIR2" --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_bowtie2_beta.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job"}

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

JOB_ID=`sbatch $ARGS --export=[BOWOUT,SAMPLE_DIR,BOWTIE,WORKER_DIR,OUT_DIR,STDERR_DIR3,STDOUT_DIR3,INDEX,PROFILE] --job-name align_virus -e "$STDERR_DIR3" -o "$STDOUT_DIR3" --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_bowtie2_virus.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job"}

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

JOB_ID=`sbatch $ARGS --export=[BOWOUT,SAMPLE_DIR,SPADES,WORKER_DIR,OUT_DIR,STDERR_DIR4,STDOUT_DIR4,SPADES,SPADESOUT,PROFILE] --job-name denovo_unused -e "$STDERR_DIR4" -o "$STDOUT_DIR4" --dependency=afterok:$PREV_JOB_ID -a 1-$NUM_JOB $SCRIPT_DIR/run_spades.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job"}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1

