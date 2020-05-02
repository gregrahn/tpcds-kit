#!/bin/bash
source ./config.sh


echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- CREATE TABLES in ${PGDATABASE}"
echo "------------------------------------------------------------"

cp ../../tools/tpcds.sql .
cp ../../tools/tpcds_ri.sql .

sed -i 's/dv_create_time            time                          ,/dv_create_time            varchar(32)                          ,/g' tpcds.sql

echo "Looking for existing tables"

tables_exist=$(psql -t --command="select (cast(cast(count(*) as integer) as varchar(32))) from information_schema.tables where table_type = 'BASE TABLE' and upper(table_schema) = upper('PUBLIC') and upper(table_catalog) = upper('"${PGDATABASE}"');")
tables_exist=$(echo -e "${tables_exist}" | xargs)
echo "  Found ${tables_exist} tables already existing"
if [[ ${tables_exist} != "0" ]]; then
   
   echo "  Generating Drop Table statements"
   temp_file=$(mktemp)
   psql -t  -o ${temp_file} --command="SELECT 'DROP TABLE ' || table_schema || '.' || table_name || ' CASCADE;'  as stmt from information_schema.tables where table_type = 'BASE TABLE' and upper(table_schema) = upper('PUBLIC') and upper(table_catalog) = upper('"${PGDATABASE}"');"

   echo "  Dropping tables using ${temp_file}"
   psql -f "${temp_file}"
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
  psql -f ${file}
  retVal=$?
  if [ ${retVal} -ne 0 ]; then
     printf "Error in sql contained in ${file}\nReturn Code : ${retVal}\nExiting..."
     exit ${retVal}
  fi
done

echo "------------------------------------------------------------"
echo "## End ${0}"