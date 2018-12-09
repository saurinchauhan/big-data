###########################################################################
#	Read data from  hdfs with different file formats 
##	csv
##	sequence
##	json
##	parquet
##	avro
##	orc


########### read

######### text
rdd = sc.textFile("/files/text")
for i in rdd.take(10): print(i)

rdd = sc.textFile("/files/text-gzip")
for i in rdd.take(10): print(i)

rdd = sc.textFile("/files/text-snappy")
for i in rdd.take(10): print(i)

############### sequence
rdd = sc.sequenceFile("/files/sequence")
for i in rdd.take(10): print(i)


rdd = sc.sequenceFile("/files/sequence-gzip")
for i in rdd.take(10): print(i)


rdd = sc.sequenceFile("/files/sequence-snappy")
for i in rdd.take(10): print(i)

####################### json
rdd = sc.textFile("/files/json")
for i in rdd.take(10): print(i)

df = sqlContext.read.format("json").load("/files/json")
df.show()

df = sqlContext.read.json("/files/json")
df.show()

rdd = sc.textFile("/files/json-gzip")
for i in rdd.take(10): print(i)

df = sqlContext.read.format("json").load("/files/json-gzip")
df.show()

df = sqlContext.read.json("/files/json-gzip")
df.show()


rdd = sc.textFile("/files/json-snappy")
for i in rdd.take(10): print(i)

df = sqlContext.read.format("json").load("/files/json-snappy")
df.show()

df = sqlContext.read.json("/files/json-snappy")
df.show()


################## parquet

dfParquet = sqlContext.read.parquet("/files/parquet")
dfParquet.show()

dfParquetGzip = sqlContext.read.parquet("/files/parquet-gzip")
dfParquetGzip.show()

dfParquetSnappy = sqlContext.read.parquet("/files/parquet-snappy")
dfParquetSnappy.show()

################## avro 
dfAvro = sqlContext\
.read\
.format("com.databricks.spark.avro")\
.load("/files/avro")
dfAvro.show()

dfAvroGzip = sqlContext\
.read\
.format("com.databricks.spark.avro")\
.load("/files/avro-gzip")
dfAvroGzip.show()


dfAvroSnappy = sqlContext\
.read\
.format("com.databricks.spark.avro")\
.load("/files/avro-snappy")
dfAvroSnappy.show()

############## orc

dfOrc = sqlContext.read.orc("/files/orc")
dfOrc.show()



