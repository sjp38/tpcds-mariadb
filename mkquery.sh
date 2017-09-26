#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <scale factor>"
	exit 1
fi

SF=$1

BINDIR=`dirname $0`

pushd $BINDIR/tpcds-kit/tools

out_dir=queries_`printf %02d $SF`

mkdir -p queries_`printf %02d $SF`
./dsqgen -directory ../query_templates/ \
	-input ../query_templates/templates_for_mysql.lst \
	-verbose y -scale $SF -output_dir ./$out_dir/ -dialect mysql

awk -v prefix="$out_dir/query_" 'BEGIN {RS=";\n"} {print > (prefix NR ".sql")}' $out_dir/query_0.sql

for i in {1..9}
do
	mv $out_dir/query_$i.sql $out_dir/query-`printf %02d $i`.sql
done

popd
