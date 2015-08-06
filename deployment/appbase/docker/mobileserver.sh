#!/bin/bash
pwd=$(cd `dirname $0`;pwd)
$pwd/docker_run.sh mobileserver -p 16001:16001

