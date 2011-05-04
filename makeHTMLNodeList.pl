#!/usr/bin/perl

# all for the date
my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
$year = 1900 + $yearOffset;
$theTime = "Report Generated on: $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year at $hour:$minute:$second";

# open html file for writing/truncate old
open FILE, ">/var/www/torNodes.html" or die $!;
print FILE "<html><title>Tor Exit by Country</title><body>\n";
print FILE "<h3>Below is a list of TOR Exit Nodes listed as \"Fast Stable Valid\"<br>Report generated at $theTime<br>It is intended to be used with the Tor Tunnel configuration </h3>\n<table border=\"1\" width=\"100%\">";
while(<>)
{
        chomp;
        my $line = $_;
        my @values = split('\|', $line);
        print FILE "\t<tr>\n";
        foreach my $val (@values) {
                print FILE "\t\t<td>$val</td>\n";
        }
        print FILE "\t</tr>\n";
}
print FILE "</table></body></html>\n";
close(FILE);
