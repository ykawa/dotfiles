use strict;
use warnings FATAL => 'all';

my @p = split( /:/, $ENV{"PATH"} );
my $h = {};
my $a = [];
for my $path ( @p )
{
    next if !-d $path;
    next if $h->{$path};
    $h->{$path} = 1;
    push @$a, $path;
}
print "PATH=" . join( ':', @$a ) . "\n";
