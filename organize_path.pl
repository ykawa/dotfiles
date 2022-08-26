use strict;
use warnings FATAL => 'all';

my @p = split( /:/, $ENV{"PATH"} );
my $a = [];
for my $path ( @p )
{
    next if !-d $path;
    push @$a, $path unless grep { $_ eq $path } @$a;
}
print "PATH=" . join( ':', @$a ) . "\n";
