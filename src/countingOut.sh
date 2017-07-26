datafile=out/$1.tab
timefile=out/$1.time
awk '{print $1}' $datafile | sort -u > temp/seq.temp

numMatches=$(wc -l $datafile | awk '{print $1}')
uniqQuery=$(cat seq.temp | wc -l)
uniqAccessions=$(awk '{print $2}' $datafile | sort -u | wc -l)
walltime=$(cat $timefile)

echo -e "$numMatches\t$uniqQuery\t$uniqAccessions\t$walltime"
rm temp/seq.temp
