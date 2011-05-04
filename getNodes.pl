#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/Geo-IP2Location-4.00/lib/";
use strict;
use warnings;
use Switch;
# This is for ip2location
use Geo::IP2Location;

my $BASE_DIR=$FindBin::Bin; 
my $allNodes = "$BASE_DIR/all-tor.txt";
system("/usr/bin/wget http://128.31.0.34:9031/tor/status/all --output-document=$allNodes");

# open the file we just wrote
open FILE, "<", $allNodes or die $!;

# place to stick everything
my $tor_info = {};

# the below is a sample database update the path if you purchase a valid license
# used to find the ip's country 
my $ip2loc = Geo::IP2Location->open("$BASE_DIR/Geo-IP2Location-4.00/samples/IP-COUNTRY-SAMPLE.BIN");

while(<FILE>)
{
        chomp;
        my $line = $_;
        # line has the meat
        if($line =~ m/^r /)
        {
                # clear it out
                $tor_info = {};

                # start of a new node
                my @elements = split(' ', $line);
                my $count = 0;
                foreach my $val (@elements)
                {
                        switch ($count)
                        {
                                case 1 { $tor_info->{'name' } = $val; }
                                case 4 { $tor_info->{'date' } = $val; }
                                case 5 { $tor_info->{'time' } = $val; }
                                case 6 { $tor_info->{'ip' } = $val; }
                                case 7 { $tor_info->{'port1' } = $val; }
                                case 8 { $tor_info->{'port2' } = $val; }
                        }
                        $count++;
                }
        }
        elsif ( $line =~ m/^s / &&
                $line =~ m/Fast/ &&
                $line =~ m/Exit/ &&
                $line =~ m/Stable/ &&
                $line =~ m/Valid/
              )
        {
                my $ip = $tor_info->{'ip'};
                # look up ip in ip2Location
                print $ip2loc->get_country_long($ip) . "|";
                # Type of node, we want are Fast Exit Stable Valid
                print "$tor_info->{'name'}|";
                print "$tor_info->{'date'}|";
                print "$tor_info->{'time'}|";
                print "$tor_info->{'ip'}|";
                print "$tor_info->{'port1'}|";
                print "$tor_info->{'port2'}\n";

        }
        elsif ($line =~ m/^opt /)
        {
                # line has the version if we ever cared
        }
}
