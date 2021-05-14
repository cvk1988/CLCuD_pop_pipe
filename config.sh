export CWD=$PWD

###### #Parameters 

# Location of raw data 
## Should I not have this, and instead run the config in the folder with the raw so I have a more robust script?

export RAW="/xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/capture_seq/raw/plate2/Plate2"
export OUT_DIR="/xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/results"
export PROFILE="/xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/capture_seq_run1/profile.txt"

# Location of tools and indices
export INDEX="/xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/reference_genomes/bowtie2_indices"
export BOWTIE="/xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/tools/bowtie2-2.4.1-linux-x86_64"
export SPADES="/xdisk/jkbrown/mig2020/rsgrps/jkbrown/cory/tools/SPAdes-3.14.1-Linux/bin"

#Place to store scripts
export SCRIPT_DIR="$PWD/scripts"
export WORKER_DIR="$PWD/scripts/workers"
export GEMSIM="$WORKER_DIR/GemSIM_v1.6_changed"
# User information

export QUEUE="standard"
export GROUP="jkbrown"
export MAIL_USER="corykeith@email.arizona.edu"
export MAIL_TYPE="bea"


# --------------------------------------------------
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
