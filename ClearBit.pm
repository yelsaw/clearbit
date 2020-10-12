package WebService::ClearBit;

use Moo;
use JSON::XS qw(decode_json);
use URI::Fast qw(uri_encode);
use URI::Fetch;
use Types::Standard qw(Str HashRef Bool);
# Implement memcache for production
use Cache::File;
use Try::Tiny;

has query_path => (
  is => 'rw',
  isa => Str,
  default => 'https://autocomplete.clearbit.com/v1/companies/suggest?query=',
);

has search_path => (
  is => 'rw',
  isa => Str,
  default => '',
);

has cache_prefix => (
  is => 'rw',
  isa => Str,
  default => 'clearbit',
);

has cache_for => (
  is => 'rw',
  default => '1800 sec',
);

has results => (
  is => 'rw',
  isa => HashRef,
  default => sub {
    +{
      rows  => 0,
      data  => [],
      query => "",
      cached => 0,
    };
  }
);

has cache => (
  is => 'lazy',
  builder => '_build_cache',
);

sub _build_cache {
  my $self = shift;
  my $prefix = $self->cache_prefix;
  return Cache::File->new(
    cache_root => "/tmp/${prefix}-cache",
  );
}

sub query {
  my $self    = shift;
  my $string  = shift;

  die(__PACKAGE__ . "->query() requires an argument") unless $string;

  # Construct full query URL, uri encode string input
  $string = uri_encode $string;
  my $query   = $self->query_path . $string;
  # Set full search_path for debugging and testing
  $self->search_path($query);
  # Query constructed endpoint
  try {
    # Get cache object
    my $cache = $self->cache();
    # Check for data
    my $payload = $cache->get($string);
    my $cached = 1;
    unless($payload) {
      my $res = URI::Fetch->fetch($query);
      if($res->is_success) {
        $payload = $res->content;
        $cache->set($string, $res->content, $self->cache_for);
      }
      # No cached hit
      $cached = 0;
    }
    if($payload) {
      my $data = decode_json($payload);
      $self->results({
        rows => scalar @{$data},
        data => $data,
        json => $payload,
        cached => $cached,
      });
    }

  }
  catch {
    my $error = URI::Fetch->errstr // $_;
    warn $error;
  };
  return $self;
}

1;

# Test
my $cb = __PACKAGE__->new->query($ARGV[0]);
# Force cache clear
# $cb->cache->clear();

print qq/
JSON: @{[ $cb->results->{json} ]}
Path: @{[ $cb->search_path ]}
Cached: @{[ $cb->results->{cached} ]}
Rows: @{[ $cb->results->{rows} ]}
_________________________
/;
  for my $r (@{$cb->results->{data}}) {
    print "$_: $r->{$_}\n" for keys %{$r};
    print "_________________________\n";
  }

=head1 NAME

WebService::ClearBit - A FREE company information service provided by ClearBit

=head1 SYNOPSIS

  my $cb = __PACKAGE__->new->query($ARGV[0]);
  # Force cache clear
  # $cb->cache->clear();

print qq/
JSON: @{[ $cb->results->{json} ]}
Path: @{[ $cb->search_path ]}
Cached: @{[ $cb->results->{cached} ]}
Rows: @{[ $cb->results->{rows} ]}
_________________________
/;
  for my $r (@{$cb->results->{data}}) {
    print "$_: $r->{$_}\n" for keys %{$r};
    print "_________________________\n";
  }

  Results should look similar to the following when I<google> is the search query
  rows: 5,
  cached: 1|0,
  json: [{"name":"Google","domain":"google.com","logo":"https://logo.clearbit.com/google.com"},{"name":"Google Design","domain":"design.google","logo":"https://logo.clearbit.com/design.google"},{"name":"Google Local Guides","domain":"localguidesconnect.com","logo":"https://logo.clearbit.com/localguidesconnect.com"},{"name":"GoogleWatchBlog","domain":"googlewatchblog.de","logo":"https://logo.clearbit.com/googlewatchblog.de"},{"name":"GChromecast Hub","domain":"googlechromecast.com","logo":"https://logo.clearbit.com/googlechromecast.com"}],
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

=head1 DESCRIPTION

  Calls ClearBit's Open Company API and returns an HashRef as shown in
  the L</SYNOPSIS> for partial and complete company string matches. If there
  are no results or an error occurs querying the web service an empty
  HashRef will be returned for consistency.

=head1 ATTRIBUTES

=head2 query_path

  Full URL to endpoint that returns partial / complete
  company data from API.
  Default: https://autocomplete.clearbit.com/v1/companies/suggest?query=

=head2 search_path

  Used for testing and debugging, should contain the full URL
  with L<URI::Fast/uri_encode> encoded search string.

=head2 cache_for

  Default I<1800 sec> 30 minutes

=head2 cache_prefix

  Prefix added to the beginning of the cache key,
  Default: 'clearbit'

=head2 results

  Contains sentential data structure or populated if query is successful.

  Example L</results>
  {
    rows => 0 or Int,
    data => [] or [{ name => '', domain => '', logo => '' }],
    json => {},
    cached => 1|0
  }

=head2 cache

  Contains lazy built L<Cache::File> object with L</cache_for>
  B<default_expires> passed to constructor.

=head1 METHODS

=head2 query(required $string)

  Main method used to query ClearBit endpoint for company information.
  L<Cache::File> will be checked and results will be populated.

  Returns reference of package for chaining.

=head1 AUTHOR

ClearBit <clearbit@yelsaw.com>

=cut

=head1 SEE ALSO

API documentation
L<https://clearbit.com/docs#autocomplete-api>

=cut
