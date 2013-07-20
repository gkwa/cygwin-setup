# -*- mode: perl; tab-width:2; comment-start:"# "; comment-column:0  -*-

my $input_file=$ARGV[0];

local $/=undef;
open FILE, "<$input_file" or die "Couldn't open file $input_file: $!";
$_ = <FILE>;
close FILE;

# If I'm running a second time, comment out my first run
s{none / cygdrive binary 0 0}{}gmi;

# comment out default
s{^(none /cygdrive.*\r?\n)}{# $1}gmi;

# running multiple times accumulates too many newlines
s{\n\n\n*}{\n};

$pre = <<END

none / cygdrive binary 0 0

END
		;

$_ = "$pre" . $_ ;


my $tmp_file="$input_file.tmp";

$| = 1;  # make unbuffered

open FILE, ">$tmp_file" or die "Couldn't open file $tmp_file: $!";
my($oh) = select(FILE);
print;
select($oh);
close FILE;

unlink("$input_file");
rename("$tmp_file", "$input_file");
