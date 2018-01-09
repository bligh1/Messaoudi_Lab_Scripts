##########################################################
# This shell script submits a trimmomatic job of a single file to the ucr cluster.
# Input intended file as well as the intended name of output file.
# Other arguments default to certain values if not specified.
# The output directory will correspond with the input file.
##########################################################
# Step 1 Parse input arguments (subject to change)

while getopts "i:o:l:t:w:m:" option; do
#	echo $OPTARG
	case $option in
		i) input="$OPTARG";;
		o) output="$OPTARG";;
#		a) adapt="$OPTARG";;
		l) lead="$OPTARG";;
		t) trail="$OPTARG";;
		w) window="$OPTARG";;
		m) length="$OPTARG";;
		*) echo "ERROR: Invalid option: -i:input fastq.gz file,-o:output file,-a:Illuminaclip adaptor sequence,-l:# bases trim off lead,-t:#bases trim off trail,-w:sliding window size (win length):(threshold),-m: minlength" >&2
	           exit 1
	esac
done


#########################################################
# Step 2 Input argument checks

if [[ "$input" == "" || "$output" == "" ]]; then
	echo "ERROR: Options -i -o require arguments." >&2
	exit 1
fi 

if [[ "$lead" == "" ]]; then
	lead=0
	echo "No input for -l; no bases trimmed off lead"
fi
if [[ "$trail" == "" ]]; then
	trail=0
	echo "No input for -t; no bases trimmed off trail"
fi
if [[ "$window" == "" ]]; then
	window=4:15
	echo "No input for -w; sliding window set to 4:15"
fi
if [[ "$length" == "" ]]; then
	length=35
	echo "No input for -m; minlength set to 35"
fi


#########################################################
# Step 3 Load necessesary module and job submission

module load trimmomatic

#echo LEADING:$lead

sbatch -p highmem --mem=100g --time=20:00:00 --wrap "java -jar $TRIMMOMATIC SE $input $output LEADING:$lead TRAILING:$trail SLIDINGWINDOW:$window MINLEN:$length"








