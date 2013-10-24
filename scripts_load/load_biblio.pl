#!/usr/bin/perl -w
use strict;


my @keys = ();
while (my $line = <>) {
    chomp $line;

    if ($line =~ /^libro/)  {
	@keys = split (" ", $line);
    next;
}

    my @data = split ("\t", $line);
    for my $datum (@data){
	$datum = "'$datum'";
        $datum =~ s/ /_/g; } #esto cambia los espacios en blanco por _ ...
    my $keys = join (", ",@keys);
    my $data = join (", ", @data);
 
    print "INSERT INTO biblio ($keys) VALUES ($data);\n";
}


