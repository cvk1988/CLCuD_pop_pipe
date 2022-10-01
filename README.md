
<a href="https://github.com/cvk1988/CLCuD_pop_pipe/graphs/contributors">
<img src="https://contrib.rocks/image?repo=cvk1988/CLCuD_pop_pipe" />
</a>

<img src="https://komarev.com/ghpvc/?username=cvk1988"/> ![Hits](https://hitcounter.pythonanywhere.com/count/tag.svg?url=https://github.com/cvk1988/CLCuD_pop_pipe/) 



# **ViCAT**

## Virus Community Assembly Tool
  A tool that assembles and characterizes virus communities from target enrichment high-throughput sequncing (TE-HTS)  data within and between samples. To be used on an HPC with slurm scheduler. 

### Dependencies
- [SPAdes](https://github.com/ablab/spades): at least version 3.14.1
- [SeqKit](https://github.com/shenwei356/seqkit)
- [csvtk](https://github.com/shenwei356/csvtk)
- [Local Blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
- [CD-HIT](http://bioinformatics.org/cd-hit/)
- [Bowtie2](https://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
- [samtools](http://www.htslib.org/)
- [bamtools](https://github.com/pezmaster31/bamtools)
- R packages: ggplot2; gridExtra; plyr
- Python (3.6 or higher) packages: Bipython; sys

### Installation

If tools are not installed on your HPC download the tools and install. Change the paths to the tools in the config.sh file to include the full path of the newly installed tools.

`SPADES="path/to/spades"`



Alternatively, create an Anaconda environment and download all of the tools with conda.

`conda create -n ViCAT python=3.7`

`conda activate ViCAT`

`pip install [packages]`

`conda install -c bioconda [tool]`

### Usage
*OPTIONAL lines of code are identified by comment boxes in the respective scripts.*

1. Edit the config.sh file in the home directory to include paths to:
    - RAW: the path to the raw data for the run.
    - OUT_DIR: the path to the desired location for the outputs of the tool. This will be re-written each time the tool is used, so be careful to backup the results of previous runs.
    - PROFILE: the path to the file that inlcudes the sample names as they relate to the filenames. An example profile in located in the home directory.
    - [TOOLS]: any paths to tools that were not installed via Anaconda.
    - [USER_INFO]: information for the HPC scheduler.
2. Edit the `run_spades.sh` lines 13 and 14 that set the file suffixes. The file can be found in `CWD/scripts`.

    `F1="${SMPLE}_R1.fastq"`
    
    `R1="${SMPLE}_R2.fastq"`
    
3. OPTIONAL but ***suggested***: edit the `run_covgraph_for.sh` lines 44-61 to remove portions of the sample name which may be uninformative and cause difficulties in reading coverage graph titles in the output files. The file can be found in `CWD/scripts`.
4. OPTIONAL: edit the `run_blastn.sh` file on line 32 to change blast options.
5. OPTIONAL: edit the `run_collect_contigs_accessions.sh` file on lines 25 and 42 to change filtering criteria for output files from Step 3. The file can be found in `CWD/scripts`. The file can be found in `CWD/scripts`.
6. OPTIONAL: edit the `run_cdhit.sh` file on line 20 to change percent similarity of blast hits for clustering. The file can be found in `CWD/scripts`.




