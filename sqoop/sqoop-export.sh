#!/bin/bash
 
####	SQOOP EXPORT
 
## sqoop export from hdfs csv to mysql table
#	prerequisites:
#	database and table should be created in first place
#	--columns is used for maintaining the order of the columns otherwise data gets scatterred across all columns
#	--fields-terminated-by :- Need to mention column delimeter
#		
#
#
##

sqoop export --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movies \
 --export-dir movies/items \
 --columns "movieId , name , dateofrelease , nodata , location ,C1 , C2 , C3 , C4 , C5 , C6 , C7 , C8 , C9 , C10 , C11 , C12 , C13 , C14 , C15 , C16 , C17 , C18 , C19" \
 --fields-terminated-by '|'

 
 ## CREATE TABLE movie_ratings (userId INT, movieId INT, rating INT, timings VARCHAR(100));
sqoop export --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table movie_ratings \
 --export-dir movies/movie_ratings \
 --columns "userId,movieId,rating,timings" \
 --fields-terminated-by '\t'
 -m 1
 
 ## CREATE TABLE users(userid INT, age INT, gender VARCHAR(100), job VARCHAR(100),timings VARCHAR(100));
 sqoop export --connect jdbc:mysql://10.100.22.217:3306/saurin \
 --username root \
 --password root \
 --table users \
 --export-dir movies/users \
 --columns "userId,age,gender,job,timings" \
 --fields-terminated-by '|'
 -m 1
 
 
 