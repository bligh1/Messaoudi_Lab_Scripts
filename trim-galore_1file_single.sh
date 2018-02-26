##################################################################
# This shell script submits a trim-galore job of a single file to the ucr cluster.
# Input a fastq.gz file with minimum length, # bases to trim off the ends, and optionally quality.
# The output directory for the resulting files will correspond with the input file.
##################################################################
# Step 1 Parse input arguments (List of arguments subject to change)

while getopts "f:l:q:e:" option; do
	case $option in
		f) file="$OPTARG";;
		l) length="$OPTARG";;
		q) quality="$OPTARG";;
		e) ends="$OPTARG";;
		*) echo "ERROR: Invalid option: -f:input fastq file, -l:min length -q:quality -e:# bases to trim" >&2
	           exit 1
	esac
done

##################################################################
# Step 2 Input argument checks

if [[ "$file" == "" ]]; then
	echo "ERROR: Option -f requires arguments." >&2
	exit 1
fi

if [[ "$quality" == "" ]]; then
	quality=20
	echo "No input for -q; quality set to 20"
fi 

if [[ "$length" == "" ]]; then
	length=35
	echo "No input for -l; length set to 35"
fi
##################################################################
# Step 3 Load necessary modules and create remaining variables

module load fastqc/0.11.3
module load fastqc 
module load trim_galore/0.4.1

out=$(dirname $file)


##################################################################
# Step 4 Submit job to cluster
if [["$ends" == "" ]]; then
	sbatch -p highmem --mem=100g --time=15:00:00 --wrap "trim_galore --fastqc --gzip --length $length -o $out -q $quality  $file"
	exit 1
fi


sbatch -p highmem --mem=100g --time=15:00:00 --wrap "trim_galore --fastqc --gzip --clip_R1 $ends --three_prime_clip_R1 $ends --length $length -o $out -q $quality  $file"

