#!/bin/bash

## sqoop commands

## list all databases 'list-databases'

sqoop list-databases --connect jdbc:mysql://10.100.22.217:3306 \
 --username root \
 --password root

sqoop list-databases --connect jdbc:mysql://10.100.22.217:3306 \
 --username root \
 --password root
 
## list all tables in a databases 'list-tables'
sqoop list-tables --connect jdbc:mysql://10.100.22.217:3306/sakila \
 --username root \
 --password root

## insert into table with 'eval'
sqoop eval --connect jdbc:mysql://10.100.22.217:3306 \
 --username root \
 --password root
 --query "insert into test values (3,'ddd')"
 




 
 
 
 
 

 
 