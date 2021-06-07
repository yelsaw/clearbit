#!/bin/bash

set -e

if [ -z $1 ] && [ -z $2 ]; then
  echo "Enter a docker container name and one arg to use this script"
  exit 0
fi

name=$1
query=$2
verbose=$3

cb=$(docker ps -qf name=$name)
if [ $cb ]; then
  docker exec -it $cb bin/query.pl $query $verbose
else
  echo "container doesn't exist, run './start.sh $name' to start or build and start"
fi
