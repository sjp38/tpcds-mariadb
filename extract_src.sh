#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <src tarball path>"
	exit 1
fi

unzip $1
mv v2.5.0rc2 tpcds-kit
