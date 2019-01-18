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

sqoop export --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movies \
 --export-dir movies/items \
 --columns "movieId , name , dateofrelease , nodata , location ,C1 , C2 , C3 , C4 , C5 , C6 , C7 , C8 , C9 , C10 , C11 , C12 , C13 , C14 , C15 , C16 , C17 , C18 , C19" \
 --fields-terminated-by '|'

 
 ## CREATE TABLE movie_ratings (userId INT, movieId INT, rating INT, timings VARCHAR(100));
sqoop export --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table movie_ratings \
 --export-dir movies/movie_ratings \
 --columns "userId,movieId,rating,timings" \
 --fields-terminated-by '\t'
 -m 1
 
 ## CREATE TABLE users(userid INT, age INT, gender VARCHAR(100), job VARCHAR(100),timings VARCHAR(100));
 sqoop export --connect jdbc:mysql://localhost/saurin \
 --username root \
 --password root \
 --table users \
 --export-dir movies/users \
 --columns "userId,age,gender,job,timings" \
 --fields-terminated-by '|'
 -m 1
 
 
 
 ###########################
 
 ## export
 
 sqoop export \
  --connect jdbc:mysql://localhost/retail_db_export \
  --username root \
  --password cloudera \
  --export-dir /user/hive/warehouse/retail_db.db/categories \
  --table categories \
  --input-fields-terminated-by "\001"
  
  
 ## columns
sqoop export \
 --connect jdbc:mysql://localhost/retail_db_export \
 --username root \
 --password cloudera \
 --export-dir /user/hive/warehouse/retail_db.db/categories \
 --table categories_custom \
 --columns category_id,category_name \
 --input-fields-terminated-by "\001" \
 -m 2
 
 ## update 
 # --update-key
 # Expected to be the primary key, otherwise query might have performance issues
 #
 
 sqoop export \
 --connect jdbc:mysql://localhost/retail_db_export \
 --username root \
 --password cloudera \
 --export-dir /user/hive/warehouse/retail_db.db/categories \
 --table categories_custom \
 --columns category_id,category_name \
 --update-key category_id \
 --update-mode allowinsert \
 --input-fields-terminated-by "\001" \
 -m 2
 
 
 
 
## stored procedure
#
#
# DROP PROCEDURE IF EXISTS GET_TOTAL_SELL_BY_DATE;
# 
# DELIMITER //
# CREATE PROCEDURE GET_TOTAL_SELL_BY_DATE ()
# BEGIN
#         SELECT  SUM(oi.order_item_subtotal) AS total_sell
#         FROM order_items oi
#         JOIN orders o
#         ON oi.order_item_order_id = o.order_id
#         WHERE (o.order_status='COMPLETE' OR o.order_status='CLOSED');
# 
# END //
# DELIMITER ;

#	Below command is not working with stored procedure

sqoop export \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --export-dir /all/retail_db/order_items \
 --call retail_db.GET_TOTAL_SELL_BY_DATE \
 --fields-terminated-by "," \
 -m 1

## 
#	DROP PROCEDURE IF EXISTS GET_TOTAL_SELL;
#	 DELIMITER //
#	 CREATE PROCEDURE GET_TOTAL_SELL ()
#	 BEGIN
#		DECLARE total_sum VARCHAR(100) DEFAULT '0';
#		SELECT	SUM(order_item_subtotal) AS total_sell INTO total_sum
#		FROM order_items;
#	
#		INSERT
#		INTO total
#		VALUES(total_sum);
#	
#	 END //
#	 DELIMITER ;
##


sqoop export \
 --connect jdbc:mysql://localhost/retail_db \
 --username root \
 --password cloudera \
 --export-dir /all/retail_db/order_items \
 --call retail_db.GET_TOTAL_SELL \
 --fields-terminated-by "," \
 -m 1
 
 ## update 
#
# create table categories ( 
#	category_id int(11)     primary key,
#	category_department_id  int(11) ,
#	category_name            varchar(45) 
#	);
#
#


sqoop export \
 --connect jdbc:mysql://localhost/retail_db_update \
 --username root \
 --password cloudera \
 --export-dir /all/retail_db/categories \
 --query


sqoop export \
 --connect jdbc:mysql://localhost/retail_db_update \
 --username root \
 --password cloudera \
 --export-dir /all/retail_db/categories \
 --table categories \
 --fields-terminated-by "," \
 --update-key category_id
 
 
 
 
 
 
 
 
 
 