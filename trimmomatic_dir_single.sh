##########################################################
# This shell script submits a trimmomatic job for each .gz file in the input directory.
# Input -i directory -l #_bases_trim_off_lead -t #_bases_trim_off_end -w sliding_window_(threshhold:window) -m minlength
# The output directory is the same as the input
# Caution: Make sure all .gz files in directory are intended to be processed
########################################################## 
# Step 1 Parse input arguments (subject to change)

while getopts "i::l:t:w:m:" option; do
#	echo $OPTARG
	case $option in
		i) indir="$OPTARG";;
#		a) adapt="$OPTARG";;
		l) lead="$OPTARG";;
		t) trail="$OPTARG";;
		w) window="$OPTARG";;
		m) length="$OPTARG";;
		*) echo "ERROR: Invalid option: -i:input directory,-a:Illuminaclip adaptor sequence,-l:# bases trim off lead,-t:#bases trim off trail,-w:sliding window size (win length):(threshold),-m: minlength" >&2
	           exit 1
	esac
done


#########################################################
# Step 2 Inout argument checks

if [[ "$indir" == "" ]]; then
	echo "ERROR: Options -i  require arguments." >&2
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
# Step 3 Load necessary module and create output file name augmentation

module load trimmomatic

aug='_trimo.gz'


#########################################################
# Step 4 Job Submission loop

for f in $indir/*.gz
do
	echo $f
	sbatch -p highmem --mem=100g --time=15:00:00 --wrap "java -jar $TRIMMOMATIC SE $f $f$aug LEADING:$lead TRAILING:$trail SLIDINGWINDOW:$window MINLEN:$length"
done
















