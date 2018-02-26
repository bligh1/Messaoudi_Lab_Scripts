###############################################################
# This shell script submits trim-galore jobs for every .gz file of a directory to the ucr cluster.
# Input intended directory with minimum length, # of bases to trim off the ends, and optionally quality.
# The output directory is the same as the input
# Caution: Make sure all .gz files of the directory are intended to be processed
###############################################################
# Step 1: Parse input arguments (subject to change)

while getopts "d:l:q:e:" option; do
#	echo $OPTARG
	case $option in
		d) dir="$OPTARG";;
		l) len="$OPTARG";;
		q) quality="$OPTARG";;
		e) ends="$OPTARG";;
		*) echo "ERROR: Invalid option; -d directory -l minlength -e #_bases_trim_off_ends -q quality" >&2
	           exit 1
	esac
done


###############################################################
# Step 2: Input argument checks and loading of necessary modules

if [[ "$dir" == "" ]]; then
	echo "ERROR: Option -d requires arguments." >&2
	exit 1
fi 

if [[ "$quality" == "" ]]; then
	quality=20
	echo "No input for -q; quality set to 20"
fi

if [[ "$len" == "" ]]; then
        length=35
        echo "No input for -l; length set to 35"
fi

out=$dir


module load fastqc/0.11.3 
module load fastqc
module load trim_galore/0.4.1


##############################################################
# Step 3: Read input directory

directory=$(readlink -f "$dir")


##############################################################
#Step 4: Search directory for .gz files and submit them to cluster

if [["$ends" == "" ]]; then
	for f in $directory/*.gz
	do
  		echo $f
        	sbatch -p highmem --mem=100g --time=15:00:00 --wrap "trim_galore --fastqc --gzip --length $len -o $out -q $quality $f"
	done
	exit 1
fi


for f in $directory/*.gz
do
	echo $f
	sbatch -p highmem --mem=100g --time=15:00:00 --wrap "trim_galore --fastqc --gzip --clip_R1 $ends --three_prime_clip_R1 $ends --length $len -o $out -q $quality $f"
done








