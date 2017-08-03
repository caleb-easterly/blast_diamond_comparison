# first argument is output directory, second is 
# name of data file

OUT_DIR=$1
datafile=$OUT_DIR/$2.tab
timefile=$OUT_DIR/$2.time

awk '{print $1}' $datafile | sort -u > temp/seq.temp

numMatches=$(wc -l $datafile | awk '{print $1}')
uniqQuery=$(cat temp/seq.temp | wc -l)
uniqAccessions=$(awk '{print $2}' $datafile | sort -u | wc -l)
walltime=$(cat $timefile)

echo -e "$numMatches\t$uniqQuery\t$uniqAccessions\t$walltime"
rm temp/seq.temp
