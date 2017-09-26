#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <scale factor>"
	exit 1
fi

SF=$1

BINDIR=`dirname $0`

pushd $BINDIR/tpcds-kit/tools

bak_dir=queries_`printf %02d $SF`
out_dir=queries

mkdir -p $bak_dir
mkdir -p $out_dir
./dsqgen -directory ../query_templates/ \
	-input ../query_templates/templates_for_mysql.lst \
	-verbose y -scale $SF -output_dir ./$bak_dir/ -dialect mysql

awk -v prefix="$bak_dir/query-" \
	'BEGIN {RS=";\n"} {print > (prefix NR ".sql")}' \
	$bak_dir/query_0.sql

for i in {1..9}
do
	mv $bak_dir/query-$i.sql $bak_dir/query-`printf %02d $i`.sql
done
cp $bak_dir/*.sql $out_dir/

popd
