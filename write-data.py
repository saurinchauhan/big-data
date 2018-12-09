#	Write data into different file formats pyspark
##	csv
##	sequence
##	json
##	parquet
##	avro
##	orc


###	write

rdd = sc.parallelize([(1,"saurin"),(2,"chauhan"),(3,"a"),(4,"bb"),(5,"ccc")])
############################### text,csv

rdd\
.saveAsTextFile("/files/text")

rdd\
.saveAsTextFile("/files/text-gzip",\
	compressionCodecClass="org.apache.hadoop.io.compress.GzipCodec")

rdd\
.saveAsTextFile("/files/text-snappy",\
	compressionCodecClass="org.apache.hadoop.io.compress.SnappyCodec")

######################### sequence

rdd\
.saveAsSequenceFile("/files/sequence")

rdd\
.saveAsSequenceFile("/files/sequence-gzip",\
	compressionCodecClass="org.apache.hadoop.io.compress.GzipCodec")


rdd\
.saveAsSequenceFile("/files/sequence-snappy",\
	compressionCodecClass="org.apache.hadoop.io.compress.SnappyCodec")

############################# json

sqlContext\
.setConf("spark.sql.json.compression.codec","uncompressed")
rdd\
.toDF(schema=["id","name"])\
.toJSON()\
.saveAsTextFile("/files/json")


rdd\
.toDF(schema=["id","name"])\
.toJSON()\
.saveAsTextFile("/files/json-gzip",\
	compressionCodecClass="org.apache.hadoop.io.compress.GzipCodec")


rdd\
.toDF(schema=["id","name"])\
.toJSON()\
.saveAsTextFile("/files/json-snappy",\
	compressionCodecClass="org.apache.hadoop.io.compress.SnappyCodec")


####################	parquet

sqlContext\
.setConf("spark.sql.parquet.compression.codec","uncompressed")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.parquet("/files/parquet")

sqlContext\
.setConf("spark.sql.parquet.compression.codec","snappy")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.parquet("/files/parquet-snappy")

sqlContext.setConf("spark.sql.parquet.compression.codec","gzip")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.parquet("/files/parquet-gzip")


#######################	avro
sqlContext\
.setConf("spark.sql.avro.compression.codec","uncompressed")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.format("com.databricks.spark.avro")\
.save("/files/avro")

sqlContext\
.setConf("spark.sql.avro.compression.codec","gzip")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.format("com.databricks.spark.avro")\
.save("/files/avro-gzip")

sqlContext\
.setConf("spark.sql.avro.compression.codec","snappy")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.format("com.databricks.spark.avro")\
.save("/files/avro-snappy")

###################	orc
sqlContext\
.setConf("spark.sql.orc.compression.codec","uncomrepssed")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.format("orc")\
.save("/files/orc")

sqlContext\
.setConf("spark.sql.orc.compression.codec","gzip")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.format("orc")\
.save("/files/orc-gzip")

sqlContext\
.setConf("spark.sql.orc.compression.codec","snappy")
rdd\
.toDF(schema=["id","name"])\
.write\
.mode("overwrite")\
.format("orc")\
.save("/files/orc-snappy")

###########################################################################