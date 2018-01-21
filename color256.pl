use strict;

foreach my $i (0..255)
{
  printf("\e[48;5;${i}m\e[38;5;15m %03d", $i);
  printf("\e[33;5;0m\e[38;5;${i}m %03d", $i);
  printf "\n" if ($i+1) % 16 == 0;
}
print "\033[0m\n";

