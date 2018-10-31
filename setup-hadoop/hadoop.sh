#!/bin/bash

## hadoop configuration steps
#
#	create a new group named "hadoop" and a user under that group "hduser" with password "hduser" in master and slave both
#	sudo addgroup hadoop
#	sudo adduser --ingroup hadoop hduser
#	add above user in sudoers
#		sudo usermod -aG sudo hduser 
#
#	https://www.edureka.co/blog/setting-up-a-multi-node-cluster-in-hadoop-2.X
#
#	Edit /etc/sysctl.conf, and append below lines to disable ipv6
#	net.ipv6.conf.all.disable_ipv6 = 1
#	net.ipv6.conf.default.disable_ipv6 = 1
#	net.ipv6.conf.lo.disable_ipv6 = 1
#	
#	generate ssh-key in master named, id_rsa
#		ssh-keygen -t rsa -P ""
#	and add id_rsa.pub to authorized_keys
#	cat id_rsa.pub >> authorized_keys
#	after that copy id_rsa.pub to slave node and add id_rsa.pub value  to its authorized_keys
#		ssh-copy-id -i $HOME/.ssh/id_rsa.pub hduser@slave
#	
#	Need to change  JAVA_HOME VALUE in hadoop-2.8.5/etc/hadoop => hadoop-env.sh
#	You must make above change in both master and slave
#
#	Format namenode
#	hadoop namenode -format
#
#	logs path		/opt/hadoop-2.8.5/logs/
#
#	sudo chown hduser:hadoop -R /data/hadoop-data/
#	sudo chmod 777 -R /data/hadoop-data/
#
#	login => using ssh localhost
#	Modify hadoop-2.8.5/etc/hadoop/slaves
#	for  master 
##


add_env_var_to_bashrc() {
	if [ ! 'grep "### HADOOP" ~/.bashrc' ]; then
        	echo "### HADOOP Variables ###" >> ~/.bashrc
       		echo "export HADOOP_HOME=/home/hduser/hadoop" >> ~/.bashrc
        	echo "export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.bashrc
        	echo "export HADOOP_MAPRED_HOME=\$HADOOP_HOME" >> ~/.bashrc
        	echo "export HADOOP_COMMON_HOME=\$HADOOP_HOME" >> ~/.bashrc
        	echo "export HADOOP_HDFS_HOME=\$HADOOP_HOME" >> ~/.bashrc
        	echo "export YARN_HOME=\$HADOOP_HOME" >> ~/.bashrc
        	echo "export HADOOP_COMMON_LIB_NATIVE_DIR=\$HADOOP_HOME/lib/native" >> ~/.bashrc
        	echo "export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin" >> ~/.bashrc
			
			if [ ! 'grep "JAVA_HOME" ~/.bashrc' ]; then
				echo "### JAVA HOME ###" >> ~/.bashrc
				echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" >> ~/.bashrc
				echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc
			fi
			
			source ~/.bashrc
	fi
}

cerate_data_dir() {
        mkdir -p ~/data/nn
        mkdir -p ~/data/snn
        mkdir -p ~/data/dn
        mkdir -p ~/data/mapred/system
        mkdir -p ~/data/mapred/local
}

setup_config_xml() {
	echo $HADOOP_HOME
	sudo cp ./*.xml $HADOOP_HOME/etc/hadoop/
}



if [ -e ~/hadoop ]; then
        echo "Adding environment variables"
        add_env_var_to_bashrc

        echo "creating data directories"
        cerate_data_dir

        echo "setting up configuration xml"
        setup_config_xml
else
        echo "Download hadoop and copy hadoop-2.8.5/ at /opt/ location"
        exit 0
fi



