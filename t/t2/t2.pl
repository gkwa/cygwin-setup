# -*- perl -*-

my $infile=$ARGV[0];

open(F,"$infile");

while(<F>)
{
    s{CYGWIN_ROOT}{$ARGV[1]}i;
    print;
}

close F;
