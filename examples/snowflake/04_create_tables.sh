#!/bin/bash
source ./config.sh


echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- CREATE TABLES in ${SNOWSQL_DATABASE}"
echo "------------------------------------------------------------"

cp ../../tools/tpcds.sql .
cp ../../tools/tpcds_ri.sql .

echo "Looking for existing tables"
tables_exist=$(${SNOWSQL_BIN} --config=./snowsql.cfg  -q "select (cast(cast(count(*) as integer) as varchar(32))) from information_schema.tables where table_type = 'BASE TABLE' and upper(table_catalog) = upper('"${SNOWSQL_DATABASE}"');")
tables_exist=$(echo -e "${tables_exist}" | xargs)
echo "  Found ${tables_exist} tables already existing"
if [[ ${tables_exist} != "0" ]]; then
   
   echo "  Generating Drop Table statements"
   temp_file=$(mktemp)
   ${SNOWSQL_BIN} --config=./snowsql.cfg -q "SELECT 'DROP TABLE ' || table_name || ';' as stmt from information_schema.tables where table_type = 'BASE TABLE' and upper(table_catalog) = upper('"${SNOWSQL_DATABASE}"');" > ${temp_file}

   echo "  Dropping tables using ${temp_file}"
   ${SNOWSQL_BIN} --config=./snowsql.cfg -f "${temp_file}"
   retVal=$?
   if [ ${retVal} -ne 0 ]; then
      printf "Error in sql contained in ${temp_file}\nReturn Code : ${retVal}\nExiting..."
      exit ${retVal}
   fi
   
fi

echo "Creating Tables"

files=( "tpcds.sql" "tpcds_ri.sql")
for file in "${files[@]}"
do
  ${SNOWSQL_BIN} --config=./snowsql.cfg -f ${file}
  retVal=$?
  if [ ${retVal} -ne 0 ]; then
     printf "Error in sql contained in ${file}\nReturn Code : ${retVal}\nExiting..."
     exit ${retVal}
  fi
done

echo "------------------------------------------------------------"
echo "## End ${0}"