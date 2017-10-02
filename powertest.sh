#!/bin/bash

# Do Power Test of TPC-DS

BINDIR=`dirname $0`

USER=root

# Usage: $0 [user [password] ]

if [ $# -eq 2 ]
then
	USER=$1
	PASSWORD=$2
fi

function msecs() {
	echo $((`date +%s%N` / 1000000))
}

function msec_to_sec() {
	MSECS=$1
	SECS=$(($MSECS / 1000))
	MSECS=$(($MSECS - $SECS * 1000))
	printf %d.%03d $SECS $MSECS
}

MYSQL="/usr/local/mysql/bin/mysql -u $USER"
if [ ! -z $PASSWORD ]
then
	MYSQL="$MYSQL -p $PASSWORD"
fi

MYSQL="$MYSQL tpcds"

TOTAL_MSECONDS=0
# We use only 50 queries
for q in {1..48}
do
	START=`msecs`
	./runquery.sh $q > /dev/null
	END=`msecs`
	DURATION=$(( $END - $START))
	printf "%d: \t%16s secs\n" $q `msec_to_sec $DURATION`
	TOTAL_MSECONDS=$(($TOTAL_MSECONDS + $DURATION))
done

printf "Total: \t%16s secs\n" `msec_to_sec $TOTAL_MSECONDS`
