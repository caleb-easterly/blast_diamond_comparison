#!/bin/bash

# arguments:
# --fasta-in fasta infile
# --matrix matrix used
# --evalue 
# --out path to outfile
# --task blastp or blastp-short
# --proc number of processors

# default diamond db path; overwritten if parameter provided
BLASTDB=/home/griffint/easte080/blastdb/nr.blast

# default task
RUNTASK=blastp

# default evalue
EVALUE=10

# default # of processors is 1
PROCS=1
 
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
	--out)
	OUTFILE="$2"
	;;
	--blast-db)
	BLASTDB="$2"
	;;
	--task)
	RUNTASK="$2"
	;;
	--proc)
	PROCS="$2"
	;;
	*)
	;;
esac
shift
done

## variables
##output format-read in from file
outputFmt=$(cat src/outputFmt.txt)

## define num_threads based on arguments, for blast
## default is 1 (if num_threads is null, sub 1)
# decrement if num_threads > 1, because blast uses a master process thing
if [ $PROCS -gt 1 ]
	then
	PROCS=$(($PROCS-1))
fi

## run blast
blastp  -task "$RUNTASK" \
	-db "$BLASTDB" \
	-query "$FASTA" \
	-out "$OUTFILE" \
	-evalue "$EVALUE" \
	-matrix "$MATRIX" \
	-outfmt "$outputFmt" \
	-max_target_seqs 100 \
	-num_threads $PROCS
