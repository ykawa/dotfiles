
my $a=['a','b'];

push @$a, 'c' unless grep { $_ eq 'c' } @$a;

print @$a;

