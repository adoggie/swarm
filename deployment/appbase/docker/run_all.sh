#!/bin/bash

pwd=$(cd `dirname $0`;pwd)
$pwd/acs.sh
$pwd/connector.sh
$pwd/jobserver.sh
$pwd/mobileserver.sh
