# first argument is diamond output, second is blast output

diamondDataFile=out/$1.tab
blastDataFile=out/$2.tab

# basic data on blast
blastNumMatches=$(wc -l $diamondDataFile | awk '{print $1}')
blastUniqQuery=$(awk '{print $1}' $blastDataFile | sort -u | wc -l)

# ----Comparisons----

#Query Sensitivity
#This sensitivity is the number of reads for which Blast and Diamond find at least
#+	one common alignment divided by the number of reads for which Blast finds 
#+	at least one alignment (percentage of queries mapped)
# sorted queries and accessions
cut -d\| -f2 $blastDataFile > temp/acc && cut -f1 $blastDataFile >\
	 temp/seq && paste -d: temp/seq temp/acc | sort -u >\
	 temp/blastSeqAcc.temp
awk '{printf "%s:%s\n", $1, $2}' $diamondDataFile | sort -u  >\
	 temp/diamondSeqAcc.temp

# join on entire line, then select the query sequence (awk),
# then count unique sequences
# Queries Mapped by Both Methods
commonSeq=$(join temp/diamondSeqAcc.temp temp/blastSeqAcc.temp |\
	awk -F ":" '{print $1}' | sort -u | wc -l)

# Percentage of Queries Mapped
percQueryMapped=$(echo "scale=3; $commonSeq/$blastUniqQuery" | bc ) 

# Match Sensitivity
# Measure of sensitivity based on number of alignments found both by Blast and Diamond
#+	divided by the total # of alignments found by Blast 
#+ 	(percentage of matches recovered)

# Alignments Found by Both Methods
commonAlign=$(join temp/diamondSeqAcc.temp temp/blastSeqAcc.temp | wc -l)

# Percentage of Blast's Alignments Mapped
percAlignMatch=$(echo "scale=3; $commonAlign/$blastNumMatches" | bc )

echo -e "$commonSeq\t$percQueryMapped\t$commonAlign\t$percAlignMatch"

exit 0
