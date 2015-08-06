#!/bin/bash
pwd=$(cd `dirname $0`;pwd)
$pwd/docker_run.sh jobserver -p 16002:16002 

