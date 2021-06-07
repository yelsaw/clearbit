#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WebService::ClearBit;

my $cb = WebService::ClearBit->new->query($ARGV[0]);
# Force cache clear
# $cb->cache->clear()

# Print verbose info
if($ARGV[1] // "" eq "verbose") {
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
exit;
}

# Print JSON
print $cb->results->{json};