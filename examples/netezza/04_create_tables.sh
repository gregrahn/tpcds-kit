#!/bin/bash
source ./config.sh


echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- CREATE TABLES in ${Db2_DATABASE}"
echo "------------------------------------------------------------"

cp ../../tools/tpcds.sql .
cp ../../tools/tpcds_ri.sql .

echo "Looking for existing tables"
tables_exist=$(/usr/local/nz/bin/nzsql -t -c "select (cast(cast(count(*) as integer) as varchar(32))) from information_schema.tables where table_type = 'TABLE' and upper(table_catalog) = upper('"${NZ_DATABASE}"');")
tables_exist=$(echo -e "${tables_exist}" | xargs)
echo "  Found ${tables_exist} tables already existing"
if [[ ${tables_exist} != "0" ]]; then
   
   echo "  Generating Drop Table statements"
   temp_file=$(mktemp)
   /usr/local/nz/bin/nzsql -t -o ${temp_file} -c "SELECT 'DROP TABLE ' || table_name || ';' || chr(10)   as stmt from information_schema.tables where table_type = 'TABLE' and upper(table_catalog) = upper('"${NZ_DATABASE}"');"

   echo "  Dropping tables using ${temp_file}"
   /usr/local/nz/bin/nzsql -f "${temp_file}"
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
  /usr/local/nz/bin/nzsql -f ${file}
  retVal=$?
  if [ ${retVal} -ne 0 ]; then
     printf "Error in sql contained in ${file}\nReturn Code : ${retVal}\nExiting..."
     exit ${retVal}
  fi
done

echo "------------------------------------------------------------"
echo "## End ${0}"