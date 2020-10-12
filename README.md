# ClearBit Docker API

### Build image and launch container
To build the image and start the container run `./start.sh`

Once the image is built the container will start and you
can query the API from the command line to test.

From container's shell, run `./bin/query.pl google` to test the 
script. The first run will return `Cached: 0` subsequent
runs for the same strings will return `Cached: 1`.

Exiting the container will stop the container. The next time
`./start.sh` is executed the container will start as a daemon
and the `./query.sh` script can be used. Any previous caches
from the initial launch will be cleared but they'll cache again
every time a matching string is used more than once.

The default cache is 30 minutes. 

### Query the running container
Once the container is launched use `./query.sh google`

Example output for the search string `google`

```
JSON: [{"name":"Google","domain":"google.com","logo":"https://logo.clearbit.com/google.com"},{"name":"Google Design","domain":"design.google","logo":"https://logo.clearbit.com/design.google"},{"name":"Google Local Guides","domain":"localguidesconnect.com","logo":"https://logo.clearbit.com/localguidesconnect.com"},{"name":"GoogleWatchBlog","domain":"googlewatchblog.de","logo":"https://logo.clearbit.com/googlewatchblog.de"},{"name":"GChromecast Hub","domain":"googlechromecast.com","logo":"https://logo.clearbit.com/googlechromecast.com"}]
Path: https://autocomplete.clearbit.com/v1/companies/suggest?query=google
Cached: 0
Rows: 5
_________________________
logo: https://logo.clearbit.com/google.com
domain: google.com
name: Google
_________________________
logo: https://logo.clearbit.com/design.google
name: Google Design
domain: design.google
_________________________
logo: https://logo.clearbit.com/localguidesconnect.com
domain: localguidesconnect.com
name: Google Local Guides
_________________________
logo: https://logo.clearbit.com/googlewatchblog.de
name: GoogleWatchBlog
domain: googlewatchblog.de
_________________________
logo: https://logo.clearbit.com/googlechromecast.com
name: GChromecast Hub
domain: googlechromecast.com
_________________________

```

# AUTHOR

ClearBit (clearbit@yelsaw.com)

# SEE ALSO

API documentation
[https://clearbit.com/docs#autocomplete-api](https://clearbit.com/docs#autocomplete-api)
