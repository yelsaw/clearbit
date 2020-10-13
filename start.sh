#!/bin/bash

set -e
cb=$(./container-id running)
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
    docker run -it -d clearbit
    exit 0;
  else
  echo "Building clearbit image"
  sleep 2
  docker build -t clearbit . &&
  echo "Starting clearbit container"
  docker run -it -d -v$PWD/app:/app:ro clearbit
  fi;
fi;
