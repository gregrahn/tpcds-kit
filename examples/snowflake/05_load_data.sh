#!/bin/bash
source ./config.sh


datadir=/tmp/data

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- LOADING DATA from ${datadir} to ${SNOWSQL_DATABASE}.${SNOWSQL_SCHEMA} "
echo "------------------------------------------------------------"
echo "Creating stage"
${SNOWSQL_BIN} --config=./snowsql.cfg  -q "create or replace file format my_csvfileformat TYPE = 'CSV' FIELD_DELIMITER = '|' VALIDATE_UTF8=false COMPRESSION = AUTO ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;"
${SNOWSQL_BIN} --config=./snowsql.cfg  -q "create or replace stage my_defaultstage FILE_FORMAT = my_csvfileformat;"

########################
# LOAD FROM LOCAL FILE #
########################

ls -al ${datadir}
echo "Looking in ${datadir} for files"
for f in ${datadir}/*; do
    echo "Running for     : ${f}"
	filename=$(basename -- "$f")
	echo "   base filename: ${filename}"
    tablename="${filename%.*}"
    tablename="${tablename%.*}"
    tablename="${tablename%.*}"
    tablename="${tablename%.*}"
	echo "   table name   : ${tablename}"

    ${SNOWSQL_BIN} --config=./snowsql.cfg  -q "put file://${f}  @my_defaultstage auto_compress=true;"
    ${SNOWSQL_BIN} --config=./snowsql.cfg  -q "copy into ${tablename}  from @my_defaultstage/${filename} file_format = (format_name = my_csvfileformat) on_error = 'skip_file';"
    ${SNOWSQL_BIN} --config=./snowsql.cfg  -q "list @my_defaultstage;"
    ${SNOWSQL_BIN} --config=./snowsql.cfg  -q "remove @my_defaultstage/${filename};"
	
done

echo "------------------------------------------------------------"
echo "  Running table counts"
temp_file=$(mktemp)
sql="select 'select a.tbl, coalesce(b.cnt,0) as cnt from (select ''' || table_schema || '.' || table_name || ''' as tbl from dual) a left join (select ''' || table_schema || '.' || table_name || ''' as tbl, coalesce(count(*),0) as cnt from ' || table_schema || '.' || table_name || ' group by 1) b on a.tbl = b.tbl ;' as stmt from information_schema.tables where upper(table_catalog) = upper('"${SNOWSQL_DATABASE}"') and upper(table_schema)  = upper('"${SNOWSQL_SCHEMA}"') order by table_catalog, table_schema"
${SNOWSQL_BIN} --config=./snowsql.cfg  -q "${sql}" > ${temp_file}
echo "  Running SQL Counts from ${temp_file}"
${SNOWSQL_BIN} --config=./snowsql.cfg  -f "${temp_file}"
  
echo "------------------------------------------------------------"
echo "## End ${0}"  

