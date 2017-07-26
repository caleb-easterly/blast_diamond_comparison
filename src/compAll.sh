
names="blast1 diamond1 diamond2 diamond3 blast2 diamond4 diamond5 diamond6 blast3 diamond7 diamond8 diamond9 blast4 diamond10 diamond11 diamond12 blast5 diamond13 diamond14 diamond15"

echo > out/basicStats.tab
for i in $names; do
	echo $i
	stats=$(src/countingOut.sh $i) 
	echo -e "$i\t$stats" >> out/basicStats.tab
done



# comparison stats
echo > out/compStats.tab
bnames=(blast1 blast2 blast3 blast4 blast5)
diamondIndex=1
for i in `seq 0 4`; do
	#blank line for each blast entry
	echo ${bnames[i]} >> out/compStats.tab	
	for j in `seq 0 2`; do
		diamondName=diamond$diamondIndex
		stats=$(src/compare_outputs.sh \
			$diamondName ${bnames[i]})
		echo -e "$diamondName\t$stats" >> out/compStats.tab
		let diamondIndex=$diamondIndex+1
	done
done


	


