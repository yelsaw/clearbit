# ClearBit Docker API

### Build image and start container
To build the image and start a docker container run `./start.sh image-name`
Once the image is built the container will start.

### Query running container (VERBOSE MODE)
After the container is started, test with the provided script 
`./query.sh image-name duckduck verbose`

The first run will return `Cached: 0` subsequent runs for the 
same strings  will return `Cached: 1`.
The default cache is 30 minutes. 

Example output for the search string `duckduck`


```
JSON: [{"name":"DuckDuckGo","domain":"duckduckgo.com","logo":"https://logo.clearbit.com/duckduckgo.com"},{"name":"Duck Duck Cat","domain":"duckduckcat.com","logo":"https://logo.clearbit.com/duckduckcat.com"},{"name":"Duck Duck Goose","domain":"weareddg.com","logo":"https://logo.clearbit.com/weareddg.com"},{"name":"Duck Duck Booth","domain":"duckduckbooth.com","logo":"https://logo.clearbit.com/duckduckbooth.com"},{"name":"Duck Duck Farms","domain":"duckduckfarms.com","logo":"https://logo.clearbit.com/duckduckfarms.com"}]
Path: https://autocomplete.clearbit.com/v1/companies/suggest?query=duckduck
Cached: 1
Rows: 5
_________________________
domain: duckduckgo.com
name: DuckDuckGo
logo: https://logo.clearbit.com/duckduckgo.com
_________________________
name: Duck Duck Cat
domain: duckduckcat.com
logo: https://logo.clearbit.com/duckduckcat.com
_________________________
logo: https://logo.clearbit.com/weareddg.com
name: Duck Duck Goose
domain: weareddg.com
_________________________
logo: https://logo.clearbit.com/duckduckbooth.com
domain: duckduckbooth.com
name: Duck Duck Booth
_________________________
logo: https://logo.clearbit.com/duckduckfarms.com
domain: duckduckfarms.com
name: Duck Duck Farms
_________________________

```

### Query running container return JSON (DEFAULT MODE)
`./query.sh image-name duckduck`
```
[{"name":"DuckDuckGo","domain":"duckduckgo.com","logo":"https://logo.clearbit.com/duckduckgo.com"},{"name":"Duck Duck Cat","domain":"duckduckcat.com","logo":"https://logo.clearbit.com/duckduckcat.com"},{"name":"Duck Duck Goose","domain":"weareddg.com","logo":"https://logo.clearbit.com/weareddg.com"},{"name":"Duck Duck Booth","domain":"duckduckbooth.com","logo":"https://logo.clearbit.com/duckduckbooth.com"},{"name":"Duck Duck Farms","domain":"duckduckfarms.com","logo":"https://logo.clearbit.com/duckduckfarms.com"}]
```

# AUTHOR

Yelsaw (clearbit@yelsaw.com)

# SEE ALSO

API documentation
[https://clearbit.com/docs#autocomplete-api](https://clearbit.com/docs#autocomplete-api)
