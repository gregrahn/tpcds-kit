#!/bin/bash

export datadir=/tmp/data

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- GENERATING DATA INS ${datadir}"
echo "------------------------------------------------------------"

rm -rf $datadir
mkdir $datadir
../../tools/dsdgen \
-SCALE 1 \
-DIR $datadir \
-DISTRIBUTIONS ../../tools/tpcds.idx

echo "------------------------------------------------------------"
echo "## End ${0}"