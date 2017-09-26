#!/bin/bash

BINDIR=`dirname $0`

pushd $BINDIR/tpcds-kit/tools
make
popd
