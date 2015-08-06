#!/bin/bash
appname=$1
shift
#docker run --rm  --name $appname -v /opt:/opt $* -it  desk51/appbase:1.0.1.0 /run/start.sh $appname
docker run -d  --name $appname -v /opt:/opt $* -it  desk51/appbase:1.0.1.1 /run/start.sh $appname

