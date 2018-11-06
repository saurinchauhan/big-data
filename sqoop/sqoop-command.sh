#!/bin/bash

MYSQL_LOCATION="jdbc:mysql://10.100.22.217:3306"
UNAME="root"
PWD="root"
DB_NAME="sqoop-db"


## sqoop import
#	connecting to database server

sqoop import --connect $MYSQL_LOCATION/$DB_NAME \
 --username $UNAME \
 --password $PWD

## sqoop commands

## list all databases 'list-databases'
sqoop list-databases --connect $MYSQL_LOCATION \
 --username $UNAME \
 --password $PWD
 
## list all tables in a databases 'list-tables'
sqoop list-tables --connect $MYSQL_LOCATION/sakila \
 --username $UNAME \
 --password $PWD


## insert into table with 'eval'
sqoop eval --connect $MYSQL_LOCATION \
 --username $UNAME \
 --password $PWD \
 --query "insert into test values (3,'ddd')"
