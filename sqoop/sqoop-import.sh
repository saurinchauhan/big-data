#!/bin/bash

####	SQOOP IMPORT 
 
##
#	sqoop-import
#		CREATE TABLE movies(movieId INT PRIMARY KEY, name varchar(500), dateofrelease varchar(500), nodata varchar(500), location varchar(500),C1 INT, C2 INT, C3 INT, C4 INT, C5 INT, C6 INT, C7 INT, C8 INT, C9 INT, C10 INT, C11 INT, C12 INT, C13 INT, C14 INT, C15 INT, C16 INT, C17 INT, C18 INT, C19 INT);
# 
##

sqoop import --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items \
 --m 3
 
## sqoop-import target directory

sqoop import --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/any-dir

## --delete-target-dir :- will remove target dir. if already exists

sqoop import --connect jdbc:mysql://10.100.22.217:3306/saurin \
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
 
sqoop import --connect jdbc:mysql://10.100.22.217:3306/saurin \
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
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
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
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies_nopk \
 --target-dir movies/import-items-nopk \
 --autoreset-to-one-mapper
 
 
## sqoop-import warehouse directory

sqoop import --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --warehouse-dir movies/warehouse 

## sqoop-import overwriting existing directory


## sqoop-import append to existing directory

## --append :- appends data into existing directory
 
sqoop import --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/any-dir \
 --append 

####	Import different file formats

#	--as-textfile	Imports data as plain text (default)

sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-as-textfile \
 --as-textfile
 
#	--as-avrodatafile	Imports data to Avro Data Files

sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-as-avrodatafile \
 --as-avrodatafile
 

#	--as-sequencefile	Imports data to SequenceFiles

sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import-items-as-sequencefile \
 --as-sequencefile
 

#	--as-parquetfile	Imports data to Parquet Files

sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import_items_as_parquetfile \
 --as-parquetfile

 ####	Compression
 
# -z / --compress :- enable compression
# this will take default compression algorithm as gzip

sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import_items_compress_z \
 -z

 ## --compress-codec:- to use different algorithm for compression other than gzip
 #	You must enable snappycodec from configuration to enable below command
sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --target-dir movies/import_items_compress_z \
 -z \
 --compression-codec org.apache.hadoop.io.compress.SnappyCodec
 
 
 ## Boundary query 
 # --boundary-query :- used to select data from within specific range/boundary of data
 
 sqoop import \
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
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
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
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
 --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --target-dir movies/query \
 --query "SELECT m.name,r.rating,r.userid from movie_ratings r join movies m on r.movieId = m.movieId and \$CONDITIONS where 1=1" \
 --split-by userid
 
 
 