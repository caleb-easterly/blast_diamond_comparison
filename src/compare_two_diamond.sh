# first argument is output dir,
# second is diamond name to be compared, third is base diamond name

OUT_DIR=$1
compDiamondDataFile=$OUT_DIR/$2.tab
baseDiamondDataFile=$OUT_DIR/$3.tab

# basic data on blast
baseDiaNumMatches=$(wc -l $baseDiamondDataFile | awk '{print $1}')
baseDiaUniqQuery=$(awk '{print $1}' $baseDiamondDataFile | sort -u | wc -l)

# ----Comparisons----

#Query Sensitivity
#This sensitivity is the number of reads for which Blast and Diamond find at least
#+	one common alignment divided by the number of reads for which Blast finds 
#+	at least one alignment (percentage of queries mapped)
# sorted queries and accessions
awk '{printf "%s:%s\n", $1, $2}' $baseDiamondDataFile | sort -u  >\
	 temp/baseDiamondSeqAcc.temp
awk '{printf "%s:%s\n", $1, $2}' $compDiamondDataFile | sort -u  >\
	 temp/compDiamondSeqAcc.temp


# join on entire line, then select the query sequence (awk),
# then count unique sequences
# Queries Mapped by Both Methods
commonSeq=$(join temp/compDiamondSeqAcc.temp temp/baseDiamondSeqAcc.temp |\
	awk -F ":" '{print $1}' | sort -u | wc -l)

# Percentage of Queries Mapped
percQueryMapped=$(echo "scale=3; $commonSeq/$baseDiaUniqQuery" | bc ) 

# Match Sensitivity
# Measure of sensitivity based on number of alignments found both by Blast and Diamond
#+	divided by the total # of alignments found by Blast 
#+ 	(percentage of matches recovered)

# Alignments Found by Both Methods
commonAlign=$(join temp/compDiamondSeqAcc.temp temp/baseDiamondSeqAcc.temp | wc -l)

# Percentage of Blast's Alignments Mapped
percAlignMatch=$(echo "scale=3; $commonAlign/$baseDiaNumMatches" | bc )

echo -e "$commonSeq,$percQueryMapped,$commonAlign,$percAlignMatch"

exit 0
