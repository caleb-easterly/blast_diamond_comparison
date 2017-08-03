# change to project root, to accurately use out and src 
cd /home/griffint/easte080/blast_diamond_comparison

OUT_DIR=$1

# function for writing given method and number
combineSplitData () {
	filename=$1

	# add times
	time1=$(cat $OUT_DIR/$filename.time1)
	time2=$(cat $OUT_DIR/$filename.time2)
	echo "${time1:-0} + ${time2:-0}" | bc > "$OUT_DIR/$filename.time"

	# concatenate output
	cat $OUT_DIR/$filename.tab1 $OUT_DIR/$filename.tab2 > $OUT_DIR/$filename.tab
}



# combine data
combineSplitData "blast4"
combineSplitData "diamond10"
combineSplitData "diamond11"
combineSplitData "diamond12"
combineSplitData "blast5"
combineSplitData "diamond13"
combineSplitData "diamond14"
combineSplitData "diamond15"

names="blast1 diamond1 diamond2 diamond3 blast2 diamond4 diamond5 diamond6 blast3 diamond7 diamond8 diamond9 blast4 diamond10 diamond11 diamond12 blast5 diamond13 diamond14 diamond15"

echo > $OUT_DIR/basicStats.tab
for i in $names; do
	echo $i
	stats=$(src/countingOut.sh $OUT_DIR $i) 
	echo -e "$i\t$stats" >> $OUT_DIR/basicStats.tab
done



# comparison stats
echo > $OUT_DIR/compStats.tab
bnames=(blast1 blast2 blast3 blast4 blast5)
diamondIndex=1
for i in `seq 0 4`; do
	#blank line for each blast entry
	echo ${bnames[i]} >> $OUT_DIR/compStats.tab	
	for j in `seq 0 2`; do
		diamondName=diamond$diamondIndex
		stats=$(src/compare_outputs.sh \
            $OUT_DIR \
			$diamondName ${bnames[i]})
		echo -e "$diamondName\t$stats" >> $OUT_DIR/compStats.tab
		let diamondIndex=$diamondIndex+1
	done
done


	


