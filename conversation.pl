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
my $tshark_command = "sudo tshark -i ".$interface." -nn -a duration:".$duration." -f "."\"".$filter."\" > conv";

if($filter==0)
{
$tshark_command = "sudo tshark -i ".$interface." -q -z conv,tcp"." -nn -a duration:".$duration." > conv";
}
print "\nNow running the command......\n\n";
print $tshark_command; 	
print "\n";
system($tshark_command);

system("sed '1,5d' conv > convtmp");
system("sed '\$d' convtmp > convtcp");

system("rm conv");
open (FILE, "+<convtcp");
open(DATA2, ">>conversations.csv");
my @array = <FILE>;
my $str = "";
foreach $str (@array)
{
	my @values = split(':',$str);
	my @ip1p2 = split('  <-> ',$values[1]);
	my @rest = split(' ',$values[2]);
	

	my $strrest = join "|",@rest;

 	my $output = $values[0]."|".$ip1p2[0]."|".$ip1p2[1]."|".$strrest;	
 
	print DATA2 $output."\n" ;
}


close(FILE);
close(DATA2);

system("rm convtcp convtmp");
print "\n\n The command to be executed for creating table is : \n";
my $hivecmd =  "CREATE TABLE conv (ipsrc STRING,srcport STRING,ipdst STRING,dstport STRING,framesbkd STRING,bytesbkd STRING,framesfrwd STRING,bytesfrwd STRING,framesttl STRING,bytesttl STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY '\|' LINES TERMINATED BY '\\n' STORED AS TEXTFILE;";
print $hivecmd;
