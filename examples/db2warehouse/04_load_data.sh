#!/bin/bash
source ./config.sh


datadir=/tmp/data

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- LOADING DATA from ${datadir} to ${Db2_DATABASE}.${Db2_SCHEMA} "
echo "------------------------------------------------------------"

db2 connect to ${Db2_DATABASE} user ${Db2_USER} using ${Db2_PASSWORD}

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

    db2 "load client from ${f} of DEL modified by coldel| insert into ${Db2_SCHEMA}.${tablename}"
	
done

echo "------------------------------------------------------------"
echo "  Generating RunStat statements"
temp_file=$(mktemp)
  db2 -z ${temp_file} -tsox "SELECT 'RUNSTATS ON TABLE ' || '"${Db2_SCHEMA}"' || '.' || tabname || ' AND DETAILED INDEXES ALL;' || chr(10)   as stmt FROM syscat.tables where upper(tabschema) = upper('"${Db2_SCHEMA}"');"
  echo "  Running Runstats from ${temp_file}"
  db2 -tsoxf ${temp_file}

echo "------------------------------------------------------------"
  echo "Generating Count SQL"
  temp_file=$(mktemp)
  db2 -z ${temp_file} -tsox "select 'select a.tbl, coalesce(b.cnt,0) as cnt from (select ''' || tabname || ''' as tbl from sysibm.sysdummy1) a left join (select ''' || tabname || ''' as tbl, coalesce(count(*),0) as cnt from ' || '"${Db2_SCHEMA}"' || '.' || tabname || ' group by 1) b on a.tbl = b.tbl ;' || chr(13) || chr(10) as stmt FROM syscat.tables where upper(tabschema) = upper('"${Db2_SCHEMA}"') order by tabschema, tabname"
  echo "  Running SQL Counts ${temp_file}"
  db2 -tsoxf ${temp_file}
  
echo "------------------------------------------------------------"
echo "## End ${0}"  

