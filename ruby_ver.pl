#!/bin/env perl
use strict;
use warnings;
use JSON::PP;

# curl -s https://api.github.com/repos/ruby/ruby/tags のレスポンスjsonからv+数字と_のみで最新のものを取得する
my $json_text  = join '', <>;
my ( $latest ) = grep { $_->{name} =~ /^v(\d+)_(\d+)_(\d+)$/ } @{ decode_json( $json_text ) };

# $latest->{name} の"v"を除去して、"_"を"."に置換して出力
print substr( $latest->{name}, 1 ) =~ s/_/./gr . "\n";
