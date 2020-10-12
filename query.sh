docker exec -it $(docker container ls -a  -q --filter "ancestor=clearbit" --filter "status=running") bin/query.pl $1
