#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Usage: $0 <query number> [username [password]]"
	exit 1
fi

BINDIR=`dirname $0`

pushd $BINDIR/tpcds-kit/tools

USER=root

NUM_Q=$1

if [ $# -gt 1 ]
then
	USER=$2
	PASSWORD=$3
fi

MYSQL="/usr/local/mysql/bin/mysql -u $USER"
if [ ! -z $PASSWORD ]
then
	MYSQL="$MYSQL -p $PASSWORD"
fi

QPATH=queries/query-`printf %02d $NUM_Q`.sql
$MYSQL tpcds < ./$QPATH
