#!/bin/bash
source ./config.sh


echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- CREATE TABLES in ${Db2_DATABASE}"
echo "------------------------------------------------------------"

cp ../../tools/tpcds.sql .
cp ../../tools/tpcds_ri.sql .

db2 connect to ${Db2_DATABASE} user ${Db2_USER} using ${Db2_PASSWORD}

echo "Looking for existing schema"
schema_exist=$(db2 -tsox "select (cast(cast(count(*) as integer) as varchar(32))) from syscat.sysschemata where upper(name) = upper('"${Db2_SCHEMA}"');")
schema_exist=$(echo -e "${schema_exist}" | xargs)
if [[ ${schema_exist} == "0" ]]; then
   echo "  Creating Schema ${Db2_SCHEMA}"
   temp_file=$(mktemp)
   db2 -tsox "CREATE SCHEMA ${Db2_SCHEMA};"
fi


echo "Looking for existing tables"
tables_exist=$(db2 -tsox "select (cast(cast(count(*) as integer) as varchar(32))) from syscat.tables where upper(tabschema) = upper('"${Db2_SCHEMA}"');")
tables_exist=$(echo -e "${tables_exist}" | xargs)
echo "  Found ${tables_exist} tables already existing"
if [[ ${tables_exist} != "0" ]]; then
   
   echo "  Generating Drop Table statements"
   temp_file=$(mktemp)
   db2 -z ${temp_file} -tsox "SELECT 'DROP TABLE ' || '"${Db2_SCHEMA}"' || '.' || tabname || ';' || chr(10)   as stmt FROM syscat.tables where upper(tabschema) = upper('"${Db2_SCHEMA}"');"

   echo "  Dropping tables using ${temp_file}"
   db2 -tvsof "${temp_file}"
   retVal=$?
   if [ ${retVal} -ne 0 ]; then
      printf "Error in sql contained in ${temp_file}\nReturn Code : ${retVal}\nExiting..."
      exit ${retVal}
   fi
   
fi

echo "Creating Tables"

db2 -c "SET SCHEMA ${Db2_SCHEMA}"

files=( "tpcds.sql" "tpcds_ri.sql")
for file in "${files[@]}"
do
  db2 -tsof ${file}
  retVal=$?
  if [ ${retVal} -ne 0 ]; then
     printf "Error in sql contained in ${file}\nReturn Code : ${retVal}\nExiting..."
     exit ${retVal}
  fi
done

echo "------------------------------------------------------------"
echo "## End ${0}"