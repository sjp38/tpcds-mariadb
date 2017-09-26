#!/bin/bash

BINDIR=`dirname $0`
pushd $BINDIR

pushd tpcds-kit/tools

if [ $# -ne 1 ]
then
	echo "Usage: $0 <scale factor>"
	exit 1
fi

SF=$1
DATADIR=data_`printf %02d $SF`

if [ ! -d $DATADIR ]
then
	echo "Data at $DATADIR not found"
	exit 1
fi

sudo /usr/local/mysql/bin/mysql -e "create database tpcds"
sudo /usr/local/mysql/bin/mysql tpcds < ./tpcds.sql

TOTAL_NSECS=0

echo "# Load data into table"
for f in `ls $DATADIR`
do
	t=`echo $f | sed -e "s/_[0-9]_[0-9]//"`
	t=`echo $t | sed -e "s/.dat//"`
	f="./$DATADIR/"$f
	START=`date +%s%N`
	sudo /usr/local/mysql/bin/mysql tpcds -e "LOAD DATA LOCAL INFILE '$f' INTO TABLE $t FIELDS TERMINATED BY '|';"
	END=`date +%s%N`
	if [ $? -ne 0 ]
	then
		echo "FAIL"
		exit 1
	fi
	printf "%23s: \t%16d nsecs\n" $t $(($END - $START))
	TOTAL_NSECS=$(($TOTAL_NSECS + $(($END - $START))))
done

echo "# Create index and constraints"
START=`date +%s%N`
sudo /usr/local/mysql/bin/mysql tpcds < ./tpcds_ri.sql
END=`date +%s%N`
printf "index: \t%16d nsecs\n" $(($END - $START))
TOTAL_NSECS=$(($TOTAL_NSECS + $(($END - $START))))

printf "Total: \t%16d nsecs\n" $TOTAL_NSECS


popd
popd
