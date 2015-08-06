#!/bin/bash

dest_dir=$1

build_dir=$dest_dir/build
pwd_dir=$(cd `dirname $0`;pwd)

if  [ -d $dest_dir ];then
	echo > /dev/null
else
	mkdir -p $dest_dir
fi

services=( $(ls $pwd_dir) )

function copy_files(){
# $1 - source dir 
# $2 - destination dir 
	alias cp="cp"	
	echo "Copy files from: $1 to $2"
	cp -r $1 $2	
	#rid of .svn
	find $2 | grep .svn | xargs rm -rf 
	#find $2 | grep make_dist | xargs rm -rf
}

for entry in "${services[@]}"; do
	if [ -d "$pwd_dir/$entry" ];then 
		if [ -e "$pwd_dir/$entry/make_dist.sh" ]; then
			"$pwd_dir/$entry/make_dist.sh" $dest_dir
		else
			echo $entry
			copy_files "$pwd_dir/$entry" $dest_dir 	
		fi	
	fi
done


