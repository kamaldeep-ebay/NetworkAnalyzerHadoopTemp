use strict;
use warnings;

system("sed '1d' query_result.csv > tmp");

open (FILE, "+<tmp");
open (FILE2, ">>features_complete.csv");

my @array = <FILE>;
my $str = "";my $div=0;
foreach $str (@array)
{
	my @values = split(',',$str);

	foreach $a (@values)
	{
	$a =~ tr/"//d;
	}

	#my $output = @values."|".$div;
	
#	my @framelens = split(',',$values[1]);

#	foreach $fl (@framelens)
#	{
#		$fl/$values[0];
#	}

        #$values[5] =~ s/\^M//g;
	$values[5] =~ s/\r//g;

	my $div = $values[0]/$values[4];
	my $output = join "|",@values;
	chomp($div);chomp($output);
	my $outputfinal = $output."|".$div;        
	
	
	print FILE2 $outputfinal."\n" ;

}
	close(FILE);
	close(FILE2);
	system("rm tmp");
