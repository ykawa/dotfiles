#!/usr/bin/perl -w
use strict;
use warnings FATAL => 'all';
use Term::ANSIColor;

# my @ct = map { ( substr( $_, 3 ), $_ ) }
#     grep { /^ON_/ && !/^ON_BRIGHT_/ && /WHITE|BLACK|BLUE|RED|MAGENTA|GREEN/ }
#     @{ ${ Term::ANSIColor::EXPORT_TAGS {"constants"} } };
my @ct = qw(
    RESET
    RED
    BLUE
    GREEN
    RGB533
    RGB225
    RGB040
);
my $cn = @ct;    # count of color table

while ( <> )
{
  my $i = 0;
  while ( /([\s,;:\.\/]*)([^(\s|,|;|:|\.\/)]+)/g )
  {
    print( colored( $1, 'reset' ) );
    print( colored( $2, $ct[ $i++ % $cn ] ) );
  }
  if ( /[\s,;:\.\/]*$/ )
  {
    print( colored( $&, 'reset' ) );
  }
}
