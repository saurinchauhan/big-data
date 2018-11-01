#!/bin/bash


cd ~
wget http://mirrors.estointernet.in/apache/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
##	http://archive.apache.org/dist/sqoop/1.4.5/sqoop-1.4.5.bin__hadoop-0.20.tar.gz

tar -xzvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
mv sqoop-1.4.7.bin__hadoop-2.6.0 sqoop-1


# export to .bashrc

echo "export SQOOP_HOME=/home/hduser/sqoop" >> ~/.bashrc
echo "export PATH=\$PATH:\$SQOOP_HOME/bin" >> ~/.bashrc

source ~/.bashrc


cd $SQOOP_HOME/conf

cp sqoop-env-template.sh sqoop-env.sh
echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> $SQOOP_HOME/conf/sqoop-env.sh
echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> $SQOOP_HOME/conf/sqoop-env.sh

## download mysql connector
cd ~
wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz
tar -xzvf mysql-connector-java-5.1.47.tar.gz
cp mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar ~/sqoop/lib/

## verify sqoop
sqoop-version

## gives output like below

##
#	Warning: /home/hduser/sqoop/../hbase does not exist! HBase imports will fail.
#	Please set $HBASE_HOME to the root of your HBase installation.
#	Warning: /home/hduser/sqoop/../hcatalog does not exist! HCatalog jobs will fail.
#	Please set $HCAT_HOME to the root of your HCatalog installation.
#	Warning: /home/hduser/sqoop/../accumulo does not exist! Accumulo imports will fail.
#	Please set $ACCUMULO_HOME to the root of your Accumulo installation.
#	Warning: /home/hduser/sqoop/../zookeeper does not exist! Accumulo imports will fail.
#	Please set $ZOOKEEPER_HOME to the root of your Zookeeper installation.
#	18/11/01 17:24:07 INFO sqoop.Sqoop: Running Sqoop version: 1.4.7
#	Sqoop 1.4.7
#	git commit id 2328971411f57f0cb683dfb79d19d4d19d185dd8
#	Compiled by maugli on Thu Dec 21 15:59:58 STD 2017
##

## if above output is returned, then sqoop is ready to use


