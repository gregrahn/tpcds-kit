#!/bin/bash
source ./config.sh


datadir=/tmp/data

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- LOADING DATA from ${datadir} to ${NZ_DATABASE} "
echo "------------------------------------------------------------"

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
    
    /usr/local/nz/bin/nzload -delim "|" -t ${tablename} -df ${f}
	
done

echo "------------------------------------------------------------"
echo "  Generating RunStat statements"
temp_file=$(mktemp)
  /usr/local/nz/bin/nzsql -t -o ${temp_file} -c "SELECT 'GENERATE STATISTICS ON ' || table_name || ';' as stmt FROM information_schema.tables WHERE table_type = 'TABLE' and upper(table_catalog) = upper('"${NZ_DATABASE}"');"
  echo "  Running Runstats from ${temp_file}"
  /usr/local/nz/bin/nzsql -f ${temp_file}

echo "------------------------------------------------------------"
  echo "Generating Count SQL"
  temp_file=$(mktemp)
  /usr/local/nz/bin/nzsql -t -o ${temp_file} -c "select 'select a.tbl, coalesce(b.cnt,0) as cnt from (select ''' || table_name || ''' as tbl) a left join (select ''' || table_name || ''' as tbl, coalesce(count(*),0) as cnt from ' || table_name || ' group by 1) b on a.tbl = b.tbl ;' || chr(13) || chr(10) as stmt FROM information_schema.tables WHERE table_type = 'TABLE' and upper(table_catalog) = upper('"${NZ_DATABASE}"') order by table_name"
  echo "  Running SQL Counts ${temp_file}"
  /usr/local/nz/bin/nzsql -t -f ${temp_file}
  
echo "------------------------------------------------------------"
echo "## End ${0}"  

