#!/bin/bash
source ./config.sh


datadir=/tmp/data

echo "## Start ${0}"
echo "------------------------------------------------------------"
echo "-- LOADING DATA from ${datadir} to ${PGDATABASE} "
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
    
	/usr/local/bin/aws s3 cp ${f} s3://${S3Landing}/${filename}
	
	psql -c "copy ${tablename} from 's3://${S3Landing}/${filename}' iam_role '${iamrole}';"
	
done

echo "------------------------------------------------------------"
echo "  Running Analyze"
#psql -c "ANALYZE VERBOSE;"

echo "------------------------------------------------------------"
echo "Generating Count SQL"
temp_file=$(mktemp)
sql="select 'select a.tbl, coalesce(b.cnt,0) as cnt from (select ''' || table_name || ''' as tbl) a left join (select ''' || table_name || ''' as tbl, coalesce(count(*),0) as cnt from ' || table_name || ' group by 1) b on a.tbl = b.tbl ;' as stmt FROM information_schema.tables WHERE table_type = 'BASE TABLE' and upper(table_schema) = upper('PUBLIC') and upper(table_catalog) = upper('"${PGDATABASE}"') order by table_name"
psql -t -o ${temp_file} -c "${sql}"
echo "  Running SQL Counts ${temp_file}"
psql -t -f ${temp_file}
  
echo "------------------------------------------------------------"
echo "## End ${0}"  

