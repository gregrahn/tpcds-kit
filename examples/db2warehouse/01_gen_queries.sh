#!/bin/bash


echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- GENERATING QUEIRIES"
echo "------------------------------------------------------------"

../../tools/dsqgen \
-DISTRIBUTIONS ../../tools/tpcds.idx \
-SCALE 1 \
-directory ../../query_templates \
-dialect db2 \
-input ../../query_templates/templates.lst \
-STREAMS 1 \
-COUNT 1


echo "------------------------------------------------------------"
echo "## End ${0}"