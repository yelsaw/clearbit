#!/bin/bash

set -e

if [ -z $1 ]; then
  echo "Enter a docker image name to use this script"
  exit 0
fi

name=$1
cb=$(docker ps -qf name=$name)
im=$(docker images -q $name 2> /dev/null)

if [ $cb ]; then
  echo "$name is running under container id: $cb"
  echo "Provide arguments for ./query.sh. Or type x to exit"
  echo ""
  read enter
  if [ $enter == 'x' ]; then
     exit 0
   else
    ./query.sh $enter
  fi
else
  if [ $im ]; then
    echo "starting $name container"
    docker run -it -d --name=$name $name
    exit 0;
  else
  echo "Building $name image"
  sleep 2
  docker build -t $name . &&
  echo "Starting $name container"
  docker run -it -d --name=$name $name
  fi;
fi;
