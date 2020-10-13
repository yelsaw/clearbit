cb=$(./container-id running)
if [ $cb ]; then
  docker exec -it $cb bin/query.pl $1
else
  echo "container doesn't exist, run ./start.sh to start or build and start"
fi
