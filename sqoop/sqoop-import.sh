#!/bin/bash

####	SQOOP IMPORT 
 
##
#	sqoop-import
#		CREATE TABLE movies(movieId INT PRIMARY KEY, name varchar(500), dateofrelease varchar(500), nodata varchar(500), location varchar(500),C1 INT, C2 INT, C3 INT, C4 INT, C5 INT, C6 INT, C7 INT, C8 INT, C9 INT, C10 INT, C11 INT, C12 INT, C13 INT, C14 INT, C15 INT, C16 INT, C17 INT, C18 INT, C19 INT);
# 
##

sqoop import --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items \
 --m 3
 
## sqoop-import target directory

sqoop import --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/any-dir

## --delete-target-dir :- will remove target dir. if already exists

sqoop import --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/any-dir \
 --delete-target-dir

 
## --split-by :- if no primary key available in table use this command with a column through which data can be split
#	column should be indexed
#	column data should be sparse, and should be sequence generated/ evenly incremented
#	should not have null values
##
 
sqoop import --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies_nopk \
 --target-dir movies/import-items-nopk \
 --split-by movieid
 
 # --split-by with non-numeric column
 # use -Dorg.apache.sqoop.splitter.allow_text_splitter=true
 # Note: above command should be placed after 'import' statement, before any other statement.
 
sqoop import \
 -Dorg.apache.sqoop.splitter.allow_text_splitter=true \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies_nopk \
 --target-dir movies/import-items-nopk \
 --split-by name
 
 # --autoreset-to-one-mapper
 #	If no primary key is available it will directly select 1 mapper, when -m or --split-by not given
 #
sqoop import \
 -Dorg.apache.sqoop.splitter.allow_text_splitter=true \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies_nopk \
 --target-dir movies/import-items-nopk \
 --autoreset-to-one-mapper
 
 
## sqoop-import warehouse directory

sqoop import --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --warehouse-dir movies/warehouse 

## sqoop-import overwriting existing directory


## sqoop-import append to existing directory

## --append :- appends data into existing directory
 
sqoop import --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/any-dir \
 --append 

####	Import different file formats

#	--as-textfile	Imports data as plain text (default)

sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-as-textfile \
 --as-textfile
 
#	--as-avrodatafile	Imports data to Avro Data Files

sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-as-avrodatafile \
 --as-avrodatafile
 

#	--as-sequencefile	Imports data to SequenceFiles

sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-as-sequencefile \
 --as-sequencefile
 

#	--as-parquetfile	Imports data to Parquet Files

sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import_items_as_parquetfile \
 --as-parquetfile

 ####	Compression
 
# -z / --compress :- enable compression
# this will take default compression algorithm as gzip

sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import_items_compress_z \
 -z

 ## --compress-codec:- to use different algorithm for compression other than gzip
 #	You must enable snappycodec from configuration to enable below command
sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import_items_compress_z \
 -z \
 --compression-codec org.apache.hadoop.io.compress.SnappyCodec
 
 
 ## Boundary query 
 # --boundary-query :- used to select data from within specific range/boundary of data
 
 sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-boundary-qry \
 --boundary-query "select min(movieid),max(movieId) from movies where movieid < 700"
 
 ## Query
 # --columns if you want to select specific columns it can be mentioned with this command
 # 		with columns query will be created like this,
 #		 SELECT movieid,name,location FROM movies WHERE movieid >= ? AND movieid < ?
 
 
sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --columns movieid,name,location \
 --target-dir movies/import-items-query \
 --m 2
 
 
 # -e, --query
 # if want to import data with complex query or if you want to import data from multiple tables using joins
 #	along with --query you must use --split-by if num-mappers is grater than 1
 # can not use --warehouse-dir as no single  table is mentioned, have to use --target-dir
 # query must include \$CONDITIONS with condition exporession
 # table and/or columns is mutually exclusive with query, either you can have  table,columns or query but not both at same time
 
 
 sqoop import \
 --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --target-dir movies/query \
 --query "SELECT m.name,r.rating,r.userid from movie_ratings r join movies m on r.movieId = m.movieId and \$CONDITIONS where 1=1" \
 --split-by userid
 
####	Delimeters :: 
#--fields-terminated-by :- to specify delimeter after each fields-terminated-by
#--lines-terminated-by :- to specify delimeter after  each lines-terminated-by
#--enclosed-by :- to enclose every field value i.e to enclose with double-quote ""
#--optionally-enclosed-by :- to enclose the field values which contains delimeter inside the value
#--escaped-by :- to set escape character  for special character
#--mysql-delimeters:- will use default mysql delimeters
#						like, 
#						lines : \n
#							  escaped-by : \
#							  optionally-enclosed-by : '
####

 sqoop import \
  --connect jdbc:mysql://localhost/saurin \
  --username root \
  --password root \
  --table movies \
  --target-dir movies/import-items-delimeters \
  --fields-terminated-by "\t" \
  --lines-terminated-by "\n" \
  --enclosed-by '\"'
  
 
 ####	Handling null
 sqoop import \
  --connect jdbc:mysql://localhost/saurin \
  --username root \
  --password root \
  --table movies \
  --target-dir movies/import-items-handle-nulls \
  --null-non-string -1
 
 ####	Incremental loads
 ## incremental import arguments
 #  --check-column			=>	Specifies the column to be examined when determining which rows to import 
 #  --incremental (mode)	=>	Mode = append / lastmodified
 #  --last-value (value)	=>	specify maximum value of check-column from previous import
 
 ## prerequisites
 sqoop import \
  --connect jdbc:mysql://localhost/retail_db \
  --username root \
  --password cloudera \
  --query "select * from orders where order_id<100 and \$CONDITIONS"
  --target-dir /temp/orders \
  -m 1
 ## END
 
# incremental commnad with --incremental append
sqoop import \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --table orders \
 --target-dir /temp/orders \
 --incremental append \
 --check-column order_id \
 --last-value 100

# incremental commnad with --incremental lastmodified

 ## prerequisites
sqoop import \
  --connect jdbc:mysql://localhost/retail_db \
  --username root \
  --password cloudera \
  --query "select * from orders where order_id<100 and \$CONDITIONS" \
  --target-dir /temp/orders_with_date \
  -m 1
 ## END

sqoop import \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --table orders \
 --target-dir /temp/orders_with_date \
 --incremental lastmodified \
 --check-column order_date \
 --last-value 2013-07-25 \
 --merge-key order_id	#	merge-key is required with --incremental lastmodified
 
 
 
 ##	CREATE SQOOP JOB
 
 
## prerequisites
sqoop import \
  --connect jdbc:mysql://localhost/retail_db \
  --username root \
  --password cloudera \
  --query "select * from orders where order_id<100 and \$CONDITIONS" \
  --target-dir /temp/orders_job \
  -m 1
 ## END
 
sqoop job \
 --create job1 \
 -- import \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --table orders \
 --target-dir /temp/orders_job \
 --incremental append \
 --check-column customer_id \
 --last-value 0
 
# execute job, needs password
 sqoop job --exec job1
 
 # delete job
 sqoop job --delete job1
 
####	Hive import
## default behaviour is every time below command is run it will append entire  table with existing data
## to view hive table describe formatted <table-name>
 
sqoop import \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --table categories \
 --hive-import \
 --hive-database retail_db \
 --hive-table categories \
 -m 1
 
## overwrite existing table
# --hive-overwrite :- will delete existing table and recreate new table with all the data
  
sqoop import \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --table categories \
 --hive-import \
 --hive-database retail_db \
 --hive-table categories \
 --hive-overwrite \
 -m 1
 
  
 
 ##	fail import if table is already created  in Hive
 # --create-hive-table :- this is mutually exclusive with --hive-overwrite
 
 sqoop import \
  --connect jdbc:mysql://localhost/retail_db \
  --username root \
  --password cloudera \
  --table categories \
  --hive-import \
  --hive-database retail_db \
  --hive-table categories \
  --create-hive-table \
  -m 1 
 
 ## specify data type of each column
 # --map-column-hive <map> :- override default mapping from sql type to Hive type for configured columns
 
sqoop import \
  --connect jdbc:mysql://localhost/retail_db \
  --username root \
  --password cloudera \
  --table categories \
  --hive-import \
  --hive-database retail_db_custom \
  --hive-table categories_custom \
  --map-column-hive category_id=string,category_department_id=string \
  -m 1

  
sqoop import \
  --connect jdbc:mysql://localhost/retail_db \
  --username root \
  --password cloudera \
  --hive-import \
  --hive-database retail_db_all \
  -m 1
  
  
#### import all tables
# import-all-tables 
# --warehouse-dir : must be used
# --autoreset-to-one-mapper : advisable to use in case of a table without primary key  
  
sqoop import-all-tables \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --warehouse-dir /all/retail_db \
 --autoreset-to-one-mapper

  
  
  
  
  
  
  