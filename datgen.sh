#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <scale factor>"
	exit 1
fi

SF=$1
DATA_DIR=data_`printf %02d $SF`

pushd tpcds-kit/tools

if [ -d $DATA_DIR ] && [ `ls $DATA_DIR | wc -l` == "25" ]
then
	echo "Data exists.  Skip."
	exit 0
fi

mkdir $DATA_DIR
./dsdgen -force Y -scale $SF -dir $DATA_DIR

# Convert blank cells to `\N` to be NULL in mysql rather than value zero
# https://github.com/gregrahn/tpcds-kit/issues/13#issuecomment-127006306
sed -i -e 's/^|/\\N|/' -e 's/||/|\\N|/g' -e 's/||/|\\N|/g' -e 's/|$/|/' $DATA_DIR/*.dat

popd
