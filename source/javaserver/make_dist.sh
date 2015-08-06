#!/bin/bash

mkdir -p /tmp/build


tomcat_dir="/usr/java/apache-tomcat-7.0.63"

dest_dir=$1
build_dir=$dest_dir/build
dest_service_dir=$dest_dir/connector
pwd_dir=$(cd `dirname $0`;pwd)
webapp=desk

if  [ -d $dest_dir ];then
	echo > /dev/null
else
	mkdir -p $dest_dir
fi

if [ ! -d "connector" ];then
	mkdir -p $dest_service_dir
fi

alias cp="cp"
#copy tomcat libs 
cp -r $tomcat_dir "$dest_service_dir/tomcat"
cd $pwd_dir/build 
ant
cd $pwd_dir
cp  -r "$pwd_dir/build/$webapp" "$dest_service_dir/tomcat/webapps"



