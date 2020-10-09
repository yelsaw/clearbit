# INFO

This is WiP module that uses ClearBit's public API to query for comapny data. If the proper modules are installed it currently has the executable added to the main file so it can simply be run by downloading it and running `perl ClearBit.pm`

# NAME

WebService::ClearBit - A FREE company information service provided by ClearBit

# SYNOPSIS

    use DDP;
    my $cb = __PACKAGE__->new->query($ARGV[0]);
    # Force cache clear
    # $cb->cache->clear();
    # Do something with results.
    print qq/
      Data: @{[ np $cb->results->{data} ]}
      Path: @{[ $cb->search_path ]}
      Cached: @{[ $cb->results->{cached} ]}
      Rows: @{[ $cb->results->{rows} ]}
    /;

    Results should look similar to the following when decode_json is used
    or the query proxies through a JSON view that consumes a HashRef
    rows: 5,
    cached: 1|0,
    data:{
      [
        {
          "name": "Google",
          "domain": "google.com",
          "logo": "https://logo.clearbit.com/google.com"
        },
        {
          "name": "Google Design",
          "domain": "design.google",
          "logo": "https://logo.clearbit.com/design.google"
        },
        {
          "name": "Google Local Guides",
          "domain": "localguidesconnect.com",
          "logo": "https://logo.clearbit.com/localguidesconnect.com"
        },
        {
          "name": "GoogleWatchBlog",
          "domain": "googlewatchblog.de",
          "logo": "https://logo.clearbit.com/googlewatchblog.de"
        },
        {
          "name": "GChromecast Hub",
          "domain": "googlechromecast.com",
          "logo": "https://logo.clearbit.com/googlechromecast.com"
        }
      ]
    }

# DESCRIPTION

    Calls ClearBit's Open Company API and returns an HashRef as shown in
    the L</SYNOPSIS> for partial and complete company string matches. If there
    are no results or an error occurs querying the web service an empty
    HashRef will be returned for consistency.

# ATTRIBUTES

## query\_path

    Full URL to endpoint that returns partial / complete
    company data from API.
    Default: https://autocomplete.clearbit.com/v1/companies/suggest?query=

## search\_path

    Used for testing and debugging, should contain the full URL
    with L<URI::Fast/uri_encode> encoded search string.

## cache\_for

    Default I<1800 sec> 30 minutes

## cache\_prefix

    Prefix added to the beginning of the cache key,
    Default: 'clearbit'

## results

    Contains sentential data structure or populated if query is successful.

    Example L</results>
    {
      rows => 0 or Int,
      data => [] or [{ name => '', domain => '', logo => '' }]

## cache

    Contains lazy built L<Cache::File> object with L</cache_for>
    B<default_expires> passed to constructor.

# METHODS

## query(required $string)

    Main method used to query ClearBit endpoint for company information.
    L<Cache::File> will be checked and results will be populated.

    Returns reference of package for chaining.

# AUTHOR

ClearBit (clearbit@yelsaw.com)

# SEE ALSO

API documentation
[https://clearbit.com/docs#autocomplete-api](https://clearbit.com/docs#autocomplete-api)
