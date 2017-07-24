#!/bin/bash

# arguments:
# --fasta-in fasta infile
# --matrix matrix used
# --evalue 
# --diamond-out path to diamond outfile
# --block-size: this number times 6 is the amount of memory in GB
# --sens: default value is 0, other options are 1 (--sensitive)
#+ 	and 2 (--more-sensitive)


# default diamond db path; overwritten if parameter provided
DIAMONDDB=/home/griffint/easte080/nr_db/nr.dmnd
SENS=0

while [[ $# -gt 1 ]]
do 
key="$1"

case $key in
	--fasta-in)
	FASTA="$2"
	shift
	;;
	--matrix)
	MATRIX="$2"
	shift
	;;
	--evalue)
	EVALUE="$2"
	shift
	;;
	--diamond-out)
	DIAMONDOUT="$2"
	;;
	--block-size)
	BLOCKSIZE="$2"
	;;
	--diamond-db)
	DIAMONDDB="$2"
	;;
	--sens)
	SENS="$2"
	case $SENS in 
		0)
		SENS_PASS=
		;;
		1) 
		SENS_PASS=--sensitive
		;;
		2)
		SENS_PASS=--more-sensitive
		;;
		*) 
		echo "Incorrect sensitivity option: choose one of 0,1,2"
		;;
	esac	
	;;
	*)
	;;
esac
shift
done

## variables
##output format-read in from file
outputFmt=$(cat outputFmt.txt)


## run diamond
home/griffint/easte080/diamond blastp \
	-d "$DIAMONDDB" \
	-q "$FASTA" \
	-o "$DIAMONDOUT" \
	-b "$BLOCKSIZE" \
	--evalue "$EVALUE" \
	$SENS_PASS \
	--matrix "$MATRIX" \
	--outfmt $outputFmt \
	--comp-based-stats 1 \
	--max-target-seqs 100 
