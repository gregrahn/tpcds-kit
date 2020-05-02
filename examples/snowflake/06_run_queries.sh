#!/bin/bash
source ./config.sh

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- Running Queries"
${SNOWSQL_BIN} --config=./snowsql.cfg  -f query_0.sql  >query_0.txt 2>&1

echo "------------------------------------------------------------"
echo "## End ${0}"