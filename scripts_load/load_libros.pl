#!/usr/bin/perl -w
use strict;


my @keys = ();
while (my $line = <>) {
    chomp $line;

    if ($line =~ /^titulo/)  {
	@keys = split ("\t", $line);
	#print "@keys\n";    
next;
}

    my @data = split ("\t", $line);
    for my $datum (@data){
    	$datum = "'$datum'";}
    #    $datum =~ s/ /_/g; } #esto cambia los espacios en blanco por _. Es necesario??
	my $libro=$data[0];
	my $year=$data[1];
	my $autor=$data[2];
	my $ed=$data[3];
	my $ISBN13=$data[4];
        $ISBN13=~ s/[-]//g;## quita el símbolo "-" del ISBN.
 	$ISBN13=~ s/ //g;## quita posibles espacios en blanco.
	my $ISBN10=$data[5];
	$ISBN10=~ s/[-]//g;## quita el símbolo "-" del ISBN. 
	$ISBN10=~ s/ //g;## quita posibles espacios en blanco. 	
	my $pedido=$data[6];
    my $keys = join (", ",@keys);
	print "INSERT INTO libro (libro_id, $keys) VALUES ('', $libro, $year, $autor, $ed, $ISBN13, $ISBN10, $pedido);\n"

}

