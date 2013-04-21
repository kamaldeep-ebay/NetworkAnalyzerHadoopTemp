#sudo tshark -i eth0 -nn -e frame.time_relative -r Kelihos-Hlux.pcap -e ip.src -e ip.dst -e ip.proto -e ip.len -e frame.len -e tcp.port -e udp.port -e tcp.flags.push -e tcp.flags.urg -Tfields -E separator="|" > kelihos

#hadoop fs -copyFromLocal kelihos 


my @colnames=qw/\t frame.time_relative ip.src ip.dst ip.proto ip.len frame.len tcp.port udp.port tcp.flags.push tcp.flags.urg ip.flags ip.id tcp.flags ip.ttl udp.dstport udp.srcport udp.port /;

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

#my $input="";

my @input_filter_names = @colnames[@colnumbers];

###run chk####
system("hadoop fs -get runs.txt");
open (MYFILE, "+<runs.txt");

my $num_run = <MYFILE>;
close(MYFILE);
$num_run ++;

system("rm runs.txt");system("hadoop fs -rm runs.txt");
system("touch runs.txt");

open (MYFILE1, ">>runs.txt");
print MYFILE1 $num_run;

close(MYFILE1);
system("hadoop fs -copyFromLocal runs.txt .");
### run chk over#####


### run chk over#####

my $input_filter1 = join " -e ",@input_filter_names;
my $input_filter = " -e ".$input_filter1;

chomp($input_filter);

print "Enter the file name .....\n";
my $filename = <>;
chomp($filename);
my $tshark_command = "sudo tshark "."-r ".$filename." ".$input_filter." -Tfields -E separator\=\"\|\" \> dump_from_pcap".$num_run;


print "\nNow running the command......\n\n";
print $tshark_command;
print "\n";
system($tshark_command);


print "the command of tshark was ..\n";
print $tshark_command;
print "\nWe are now ready to start hive...\n ";


print "\nThe commands you need to execute on Hive CLI are a follows ..... \n";


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

#my $loadcmd = "cp ./dump".$num_run." \$HIVE_HOME";
my $loadcmd = "hadoop fs -copyFromLocal dump_from_pcap".$num_run." ." ;
system($loadcmd);
print "\n\nLOAD DATA LOCAL INPATH \'"."/user/project/dump".$num_run."\' INTO TABLE captures\n\n";





