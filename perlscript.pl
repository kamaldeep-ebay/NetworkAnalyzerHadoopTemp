#! usr/bin/perl
use warnings;
use strict;
=pod
my $num_runs =0;
print "If you want to add data to exisitng table captures then enter press 1";
if($tempinput==1)

if($temp2==1)

	
}
}
=cut

#print "The captures are stored in ~/captures";

#if (!(-d "~/captures")) {
    # directory called cgi-bin exists

 #       system("mkdir ~/captures");
#}

#system("cd captures");

print "Enter the duration of the capture";
my $duration=<>;

print "Enter the CAPTURE filter eg tcp port 23 and not [src/dst] host www.google.com or port 80 or for search strings http://www.wireshark.org/tools/string-cf.html or\n if you don't want any filter press 0 ";

my $filter=<>;

my @colnames=qw/\t frame.time ip.src ip.dst ip.proto ip.len ip.flags ip.id tcp.flags ip.ttl udp.dstport udp.srcport udp.port /;

print "The possible columns or DISPLAY FILTERS(remeber these colnames are equi to your display filters) are ...   ";
foreach (@colnames)
{
   print "$_\n";
}

print "Enter the column numbers you want separated by comma FIRST COL IS 1 - ";
my $temp=<>;
my @colnumbers = split(',',$temp);

print "If you want any columns not from list press 1 else press anythig else";
my $tempinput=<>;

my $input="";
if($tempinput==1)
{
print "enter filter";
$input =<>;
push(@colnames, $input);
}

my @input_filter_names = @colnames[@colnumbers];
#print @

#foreach (@input_filter_names)
#{
#   print "$_\n";
#}

### this is just for a run check ####
open (MYFILE, "+<runs.txt");

my $num_run = <MYFILE>;
close(MYFILE);
$num_run ++;

system("rm runs.txt");
system("touch runs.txt");

open (MYFILE1, ">>runs.txt");
print MYFILE1 $num_run;

close(MYFILE1);

### run chk over#####

my $input_filter1 = join " -e ",@input_filter_names;
my $input_filter = " -e ".$input_filter1;

chomp($duration);chomp($filter);chomp($input_filter);

print "\nChoose the interface ... specify the name\n";

system("sudo tshark -D");

my $interface=<>;
chomp ($interface);
my $tshark_command = "sudo tshark -i ".$interface." -nn -a duration:".$duration." -f "."\"".$filter."\""." ".$input_filter." -Tfields -E separator\=\"\|\" \> dump".$num_run;

if($filter==0)
{
$tshark_command = "sudo tshark -i ".$interface." -nn -a duration:".$duration." ".$input_filter." -Tfields -E separator\=\"\|\" \> dump".$num_run;
}

print "\nNow running the command......\n\n";
print $tshark_command; 	
print "\n";
system($tshark_command);

#system($HADOOP_HOME/bin/hadoop dfs -rmr input);

#system($HADOOP_HOME/bin/hadoop dfs -mkdir input);

#system($HADOOP_HOME/bin/hadoop dfs -copyFromLocal ~/project/captures/capture input);
print "the command of tshark was ..";
print $tshark_command;
print "We are now ready to start hive...\n ";
print "The commands you need to execute on Hive CLI are a follows ..... \n";


#print  "CREATE TABLE captures (Time STRING, Source STRING, Destination STRING, Protocol STRING, Length STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\\n' STORED AS TEXTFILE;";

foreach  $a (@input_filter_names)
{
	$a =~ s/[^a-zA-Z0-9]*//g;
}

my $hivecols = join " STRING,",@input_filter_names;

print "\n This command is in case you need to create a new  table name else skip to LOAD DATA \n\n";

my $hivecmd =  "CREATE TABLE captures (".$hivecols." STRING".") ROW FORMAT DELIMITED FIELDS TERMINATED BY '\|' LINES TERMINATED BY '\\n' STORED AS TEXTFILE;";

print $hivecmd;

print "\n The above command was in case you need to add data to same table else change the table name ";

print "\n";

my $loadcmd = "cp ./dump".$num_run." \$HIVE_HOME";

system($loadcmd);
print "\n\nLOAD DATA LOCAL INPATH \'"."./dump".$num_run."\' INTO TABLE captures\n\n";

print  "\nNow Starting Hive .....";
#system($HIVE_HOME/bin/hive);



=pod
if($colnumbers[1]==1)#this is to check if frame.time has been asked for a filter
{
shift(@colnumbers);
my $extract = join ",",@colnumbers;
my $extract1 = $extract."$colnumbers-1";
system("cut -d \"\,\" -f ".$extract1." dump >dump1");

system("cut -d \"\ \" -f 3 dump1 > dump_final");

system("rm dump1");
my $flag=1;

}
open(DATA,"+<dump") or die ("Unable to open file");

# removing the date parameter from frame time
my @lines = <DATA>;
	
foreach $line (@lines)
{
	chomp $line;
	


}
=cut



