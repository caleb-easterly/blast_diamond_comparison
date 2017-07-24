#!/bin/bash

# output path for diagnostics
output=$1

# input for diamond 
diamond_in=$2

# input for blast
blast_in=$3

# input for fasta
fasta_in=$4

# temporary sequence files, as they're used twice
awk '{print $1}' $diamond_in | sort -u > dSeq.temp
awk '{print $1}' $blast_in | sort -u > bSeq.temp

echo > $output
echo "----General----" >> $output
echo "Number of Query Sequences" >> $output
grep '>' $fasta_in | wc -l >> $output

echo >> $output
echo "----Diamond----" >> $output
echo "Number of Matches " >> $output

# the awk command removes the file name in the wc output 
wc -l $diamond_in | awk '{print $1}'>> $output
echo "Number of Unique Query Sequences Matched" >> $output
cat dSeq.temp | wc -l >> $output
echo "Number of Unique Accessions Found" >> $output
awk '{print $2}' $diamond_in | sort -u | wc -l >> $output

echo >> $output
echo "----Blast----" >> $output
echo "Number of Matches " >> $output
blastNumMatches=$(wc -l $blast_in | awk '{print $1}')
echo $blastNumMatches >> $output
echo "Number of Unique Query Sequences Matched" >> $output
blastUniqQuery=$(cat bSeq.temp | wc -l)
echo $blastUniqQuery >> $output
echo "Number of Unique Accessions Found" >> $output
awk '{print $2}' $blast_in | sort -u | wc -l >> $output 
echo >> $output 

countStuff () {
	
	numMatches=$(wc -l $1 | awk '{print $1}')
	uniqQuery=$(cat bSeq.temp | wc -l)
	uniqAccessions=$(awk '{print $2}' $blast_in | sort -u | wc -l)

	awk '{printf %d\t%d\t%d\n}, $numMatches, $uniqQuery, $uniqAccessions}' /dev/null
}
export -f countStuff

echo "----Comparisons----" >> $output
echo -e "**Query Sensitivity**" >> $output
echo -e "This sensitivity is the number of reads for which Blast and Diamond find at least\none common alignment divided by the number of reads for which Blast finds at least\none alignment (percentage of queries mapped)\n*Common Alignments*">> $output
# sorted queries and accessions
awk '{printf "%s:%s\n", $1, $2}' $diamond_in | sort -u  > dSeqAcc.temp
awk '{printf "%s:%s\n", $1, $2}' $blast_in | sort -u  > bSeqAcc.temp

# join on entire line (-t''), then select the query sequence (awk),
# then count unique sequences
commonSeq=$(join dSeqAcc.temp bSeqAcc.temp | awk '{print $1}' | sort -u | wc -l)
echo $commonSeq >> $output
echo "*Percentage of Queries Mapped*" >> $output
awk "BEGIN {print $commonSeq/$blastUniqQuery}" >> $output

echo >> $output

echo -e "**Match Sensitivity**" >> $output
echo -e "Measure of sensitivity based on # of alignments found both by Blast and Diamond\ndivided by the total # of alignments found by Blast (percentage of matches recovered)" >> $output
echo "*Alignments Found by Both Methods*" >> $output
commonMatch=$(join dSeqAcc.temp bSeqAcc.temp | wc -l)
echo $commonMatch >> $output

echo "*Percentage of Blast's Alignments Mapped*" >> $output
awk "BEGIN {print $commonMatch/$blastNumMatches}" >> $output



# cleanup: remove tempfiles
rm *.temp
