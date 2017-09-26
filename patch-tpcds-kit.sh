#!/bin/bash

BINDIR=`dirname $0`

pushd $BINDIR

TPCDSKIT=./tpcds-kit

if [ ! -d $TPCDSKIT ]
then
	echo "tpcds kit source code not found under $TPCDSKIT/."
	exit 1
fi

pushd $TPCDSKIT
patch -p1 < ../for-mariadb.patch
popd

popd
