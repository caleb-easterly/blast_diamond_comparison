# first argument is output dir,
# second is base blast name, third is blast name to be compared to base

OUT_DIR=$1
compBlastDataFile=$OUT_DIR/$2.tab
baseBlastDataFile=$OUT_DIR/$3.tab

# basic data on blast
blastNumMatches=$(wc -l $baseBlastDataFile | awk '{print $1}')
blastUniqQuery=$(awk '{print $1}' $baseBlastDataFile | sort -u | wc -l)

# ----Comparisons----

#Query Sensitivity
#This sensitivity is the number of reads for which Blast and Diamond find at least
#+	one common alignment divided by the number of reads for which Blast finds 
#+	at least one alignment (percentage of queries mapped)
# sorted queries and accessions
cut -d\| -f2 $compBlastDataFile > temp/acc && cut -f1 $compBlastDataFile >\
	 temp/seq && paste -d: temp/seq temp/acc | sort -u >\
	 temp/compBlastSeqAcc.temp
cut -d\| -f2 $baseBlastDataFile > temp/acc && cut -f1 $baseBlastDataFile >\
	 temp/seq && paste -d: temp/seq temp/acc | sort -u >\
	 temp/baseBlastSeqAcc.temp

# join on entire line, then select the query sequence (awk),
# then count unique sequences
# Queries Mapped by Both Methods
commonSeq=$(join temp/compBlastSeqAcc.temp temp/baseBlastSeqAcc.temp |\
	awk -F ":" '{print $1}' | sort -u | wc -l)

# Percentage of Queries Mapped
percQueryMapped=$(echo "scale=3; $commonSeq/$blastUniqQuery" | bc ) 

# Match Sensitivity
# Measure of sensitivity based on number of alignments found both by Blast and Diamond
#+	divided by the total # of alignments found by Blast 
#+ 	(percentage of matches recovered)

# Alignments Found by Both Methods
commonAlign=$(join temp/baseBlastSeqAcc.temp temp/compBlastSeqAcc.temp | wc -l)

# Percentage of Blast's Alignments Mapped
percAlignMatch=$(echo "scale=3; $commonAlign/$blastNumMatches" | bc )

echo -e "$commonSeq\t$percQueryMapped\t$commonAlign\t$percAlignMatch"

exit 0
