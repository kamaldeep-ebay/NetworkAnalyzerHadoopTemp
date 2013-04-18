use strict;
use warnings;

#print "Enter the duration of the script";
#my $duration=<>;
print "Enter the number of files";
my $files=<>;

#chomp($duration);
chomp($files);

my $tshark_command = "sudo tshark -i any -b filesize:102400 -b files:".$files." -w packets.pcap";

system($tshark_command);
