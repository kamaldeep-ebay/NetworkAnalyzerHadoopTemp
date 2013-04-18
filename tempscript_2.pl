use strict;
use warnings;

print "Enter the duration of the capture";
my $duration=<>;

print "Enter the CAPTURE filter eg tcp port 23 and not [src/dst] host www.google.com or port 80 or for search strings http://www.wireshark.org/tools/string-cf.html or\n if you don't want any filter press 0 ";
my $filter=<>;
chomp($duration);chomp($filter);
print "\nChoose the interface ... specify the name\n";

system("sudo tshark -D");

my $interface=<>;
chomp ($interface);
my $tshark_command = "sudo tshark -i ".$interface." -nn -a duration:".$duration." -f "."\"".$filter."\" > convip";

if($filter==0)
{
$tshark_command = "sudo tshark -i ".$interface." -nn -a duration:".$duration." > convip";
}
print "\nNow running the command......\n\n";
print $tshark_command; 	
print "\n";
system($tshark_command);

system("sed '1,5d' conv|sed '\$d' conv|sed '/Filter/d' conv|sed '/Frames/d' conv > convip");

open (FILE, "+<convip");

my $num_run = <MYFILE>;

#parse the file using tab and <-> delimiter 
foreach $str (FILE)
{
	split(',',$FILE);
	join 
}


close(FILE);
