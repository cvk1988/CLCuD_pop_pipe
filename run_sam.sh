#!/bin/sh
set -u
#
# Checking args
#
source ./config.sh

#
# Job submission
# 
ARGS="-p $QUEUE --account=$GROUP --mail-user $MAIL_USER --mail-type $MAIL_TYPE"

#
# Bowtie2 to cotton
#

Prog="SAM2BAM"
export STDERR_DIR="$SCRIPT_DIR/err/$Prog"
export STDOUT_DIR="$SCRIPT_DIR/out/$Prog"
init_dir "$STDERR_DIR" "$STDOUT_DIR"

echo "$Prog"
echo "launching $SCRIPT_DIR/run_samtools_bam.sh as a job."
#-a tells the number of jobs to submit to the PBS array
JOB_ID=`sbatch $ARGS --export=ALL,WORKER_DIR=$WORKER_DIR,STDERR_DIR=$STDERR_DIR,STDOUT_DIR=$STDOUT_DIR -o $STDOUT_DIR/output.%a.out -e $STDERR_DIR/err.%a.out --job-name sam2bam $SCRIPT_DIR/run_samtools_bam.sh`

if [ "${JOB_ID}x" != "x" ]; then
        JOB_ID=${JOB_ID#"Submitted batch job "}

        echo Job: \"$JOB_ID\"
        PREV_JOB_ID=$JOB_ID
else
        echo Problem submitting job. Job terminated.
        exit 1
fi
