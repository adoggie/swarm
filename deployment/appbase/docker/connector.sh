#!/bin/bash
pwd=$(cd `dirname $0`;pwd)
$pwd/docker_run.sh connector -p 16003:16003 -p 8443:8443

