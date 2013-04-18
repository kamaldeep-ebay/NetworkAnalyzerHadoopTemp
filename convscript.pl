#! usr/bin/perl
use warnings;
use strict;

#print "If you want just ip conv press 1 else press 0";
#my input=<>;


print "Enter the duration of the capture";
my $duration=<>;

print "Enter the CAPTURE filter eg tcp port 23 and not [src/dst] host www.google.com or port 80 or for search strings http://www.wireshark.org/tools/string-cf.html or\n if you don't want any filter press 0 ";

my $filter=<>;

my @colnames=qw/Source_IP Source_Port ip.dst ip.proto ip.len ip.flags ip.id tcp.flags ip.ttl udp.dstport udp.srcport udp.port /;

