export CWD=$PWD

###### #Parameters 

# Location of raw data 


export RAW="/home/u32/corykeith/CLCuD_pop_pipe_2/raw"
export OUT_DIR="/home/u32/corykeith/CLCuD_test"
export PROFILE="/home/u32/corykeith/CLCuD_pop_pipe_2/profile.txt"

# Location of tools and indices
export INDEX="/home/u32/corykeith/reference_genomes/bowtie2_indices"
export BOWTIE="/home/u32/corykeith/tools/bowtie2-2.4.1-linux-x86_64"
export SPADES="/home/u32/corykeith/tools/SPAdes-3.14.1-Linux"

#Place to store scripts
export SCRIPT_DIR="$PWD/scripts"
export WORKER_DIR="$PWD/scripts/workers"
export GEMSIM="$WORKER_DIR/GemSIM_v1.6_changed"
# User information

export QUEUE="standard"
export GROUP="jkbrown"
export MAIL_USER="corykeith@email.arizona.edu"
export MAIL_TYPE="ALL"


# --------------------------------------------------
# removes directories with name and makes new directory based on variable.
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}
