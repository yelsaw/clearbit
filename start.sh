#!/bin/bash

set -e
cb=$(docker ps -qf name=clearbit)
im=$(docker images -q clearbit 2> /dev/null)

if [ $cb ]; then
  echo "clearbit is running under container id: $cb"
  echo "type a search string to query and press enter. Or type x to exit"
  echo ""
  read enter
  if [ $enter == 'x' ]; then
     exit 0
   else
    ./query.sh $enter
  fi
else
  if [ $im ]; then
    echo "starting clearbit container"
    docker run -it -d --name=clearbit clearbit
    exit 0;
  else
  echo "Building clearbit image"
  sleep 2
  docker build -t clearbit . &&
  echo "Starting clearbit container"
  docker run -it -d --name=clearbit clearbit
  fi;
fi;
