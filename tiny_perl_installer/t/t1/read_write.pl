# -*- perl -*-

# In your program
use Config::Tiny;

# Create a config
my $Config = Config::Tiny->new();

# Open the config
$Config = Config::Tiny->read( 'file.conf' );

# Reading properties
my $rootproperty = $Config->{_}->{rootproperty};
my $one = $Config->{section}->{one};
my $Foo = $Config->{section}->{Foo};

# Changing data
$Config->{newsection} = { this => 'that' }; # Add a section
$Config->{section}->{Foo} = 'Not Bar!';     # Change a value
delete $Config->{_};                        # Delete a value or section

# Save a config
$Config->write( 'file.conf' );
