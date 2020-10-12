#!/bin/bash

set -e

cb=$(docker container ls -a  -q --filter "ancestor=clearbit" --filter "status=running" 2> /dev/null)
im=$(docker images -q clearbit 2> /dev/null)

if [ $cb ]; then
  echo clearit is running under container id: $cb
  echo type a search string to query and press enter. Or type x to exit
  read enter
  if [ $enter != 'x' ]; then
    ./query.sh $enter
   else
    exit 0
  fi
else
  if [ $im ]; then
    echo starting clearbit container
    docker run -it -d $im
    exit 0;
  else
  echo Building clearbit image
  sleep 2
  docker build -t clearbit . &&
  echo Starting clearbit container
  docker run -it -d $(docker images --format='{{.ID}}' | head -1)
  fi;
fi;
