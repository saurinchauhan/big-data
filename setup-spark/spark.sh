#!/bin/bash

##
#
#	https://www.linode.com/docs/databases/hadoop/install-configure-run-spark-on-top-of-hadoop-yarn-cluster/
#	jar cv0f spark-libs.jar -C $SPARK_HOME/jars/ .
#
#	spark-shell --master yarn --deploy-mode cluster
#	spark-submit --class com.sa.Main --master yarn --deploy-mode cluster SparkYarn-0.0.1-SNAPSHOT.jar
#	spark-submit --class com.sa.Main --master yarn --deploy-mode client SparkYarn-0.0.1-SNAPSHOT.jar
#	spark-submit --class com.sa.Main --master yarn SparkYarn.jar
##

setup_spark_path_to_bashrc() {
	echo "export PATH=/opt/spark/bin:\$PATH" >> ~/.bashrc
}

integrate_spark_with_yarn() {
	echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> ~/.bashrc
	echo "export SPARK_HOME=/opt/spark" >> ~/.bashrc
	echo "export LD_LIBRARY_PATH=\$HADOOP_HOME/lib/native:$\LD_LIBRARY_PATH" >> ~/.bashrc
}

update_spark_default_conf_with_yarn() {
	source ~/.bashrc &
	wait
	cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
	echo "spark.master    yarn" >> $SPARK_HOME/conf/spark-defaults.conf
}


setup_spark_path_to_bashrc
integrate_spark_with_yarn
update_spark_default_conf_with_yarn



