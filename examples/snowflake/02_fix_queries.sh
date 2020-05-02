#!/bin/bash

python3 snowflakeFixes.py > query_0.sql.fixed
mv query_0.sql query_0.sql.orig
mv query_0.sql.fixed query_0.sql