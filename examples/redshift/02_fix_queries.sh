#!/bin/bash

python3 redshiftFixes.py > query_0.sql.fixed
mv query_0.sql query_0.sql.orig
mv query_0.sql.fixed query_0.sql


echo "*********************************************************"
echo "*********************************************************"
echo "*  SOME QUERIES WILL FAIL "
echo "*"
echo "*  REDSHIFT DOES NOT SUPPORT GROUP BVY ROLLUP "
echo "*  SOME QUERIES WILL FAIL "
echo "*"
echo "*********************************************************"
echo "*********************************************************"