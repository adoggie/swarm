#!/bin/bash

if [ $# -lt 1 ];then
	echo 'error: parameter insufficient, please specify output dir'
	exit 1
fi

dest_dir=$1
build_dir=$dest_dir/build

if  [ -d $dest_dir ];then
	echo > /dev/null 
else
	mkdir -p $dest_dir
fi

current=`pwd`
dest_dir=$(cd $dest_dir;pwd)
cd $current

services=( $(ls) )

for entry in "${services[@]}"; do
	if [ -d $entry  -a -e $entry/make_dist.sh ]; then
		echo 'enter service:' $entry
		echo '---------------------------'
		$entry/make_dist.sh $dest_dir
	
	else
		echo > /dev/null
	fi
done


