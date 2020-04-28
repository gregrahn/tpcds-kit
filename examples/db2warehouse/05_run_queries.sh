#!/bin/bash
source ./config.sh

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- Connecting to database"
db2 connect to ${Db2_DATABASE} user ${Db2_USER} using ${Db2_PASSWORD}

echo "------------------------------------------------------------"
echo "-- Setting Schema"
db2 -c "SET SCHEMA ${Db2_SCHEMA}"

echo "------------------------------------------------------------"
echo "-- Running Queries"
db2 -tvsoxf query_0.sql  >query_0.txt 2>&1

echo "------------------------------------------------------------"
echo "## End ${0}"