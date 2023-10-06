#!/bin/env perl
use strict;
use warnings;
use JSON::PP;

# "https://api.github.com/repos/Perl/perl5/tags" のレスポンスjsonからマイナーバージョンが偶数で最新のものを取得する
my $json_text  = join '', <>;
my ( $latest ) = grep { $_->{name} =~ /^v(\d+)\.(\d+)\.(\d+)$/ && $2 % 2 == 0 } @{ decode_json( $json_text ) };

# $latest->{name} から先頭の"v"を除去して出力
print substr( $latest->{name}, 1 ) . "\n";
