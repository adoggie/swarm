#!/bin/bash
pwd=$(cd `dirname $0`;pwd)
$pwd/docker_run.sh acs -p 16004:1234
