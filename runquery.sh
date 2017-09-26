#!/bin/bash

if [ $# -lt 2 ]
then
	echo "Usage: $0 <scale factor> <query number> [username [password]]"
	exit 1
fi

BINDIR=`dirname $0`

pushd $BINDIR/tpcds-kit/tools

USER=root

SF=$1
NUM_Q=$2

if [ $# -gt 2 ]
then
	USER=$3
	PASSWORD=$4
fi

MYSQL="/usr/local/mysql/bin/mysql -u $USER"
if [ ! -z $PASSWORD ]
then
	MYSQL="$MYSQL -p $PASSWORD"
fi

QPATH=queries_`printf %02d $SF`/query-`printf %02d $NUM_Q`.sql
$MYSQL tpcds < ./$QPATH
