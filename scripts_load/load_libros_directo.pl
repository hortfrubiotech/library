#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;
use utf8;
use Unicode::Normalize;
use Text::Unaccent;
my $charset= "UTF-8";
my @keys = ();
my $file = "/home/biblioteca/raw_data/libros.txt";
open (FILE, $file) or die("Can't open $file: $!\n");
my @lines = <FILE>;
close FILE;


for my$line(@lines) {
    chomp $line;

    if ($line =~ /^titulo/) {
        @keys = split ("\t", $line);
        #print "@keys\n";
next;
}

    my @data = split ("\t", $line);
    for my $datum (@data){
        $datum =~ s/^\s+|\s+$//g;         
        $datum =unac_string($charset, $datum);
    }
        my $libro_accent=$data[0];
        my $libro= unac_string($charset, $libro_accent); ##Quita las tildes (funciona con el mC3dulo Text::Unaccent)
        my $year=$data[1];
        $year=~ s/^\s+//g;
        my $autor=$data[2];
        my $ed=$data[3];
        my $ISBN13=$data[4];
        $ISBN13=~ s/[-]//g;## quita el sC-mbolo "-" del ISBN.
         $ISBN13=~ s/ //g;## quita posibles espacios en blanco.
        $ISBN13=~ s/^\s+//;        
        my $ISBN10=$data[5];
        $ISBN10=~ s/[-]//g;## quita el sC-mbolo "-" del ISBN.
        $ISBN10=~ s/ //g;## quita posibles espacios en blanco.
        $ISBN10=~ s/^\s+//;                
        my $pedido=$data[6];
        my $keys = join (", ",@keys);
        #print "INSERT INTO libro (libro_id, $keys) VALUES ('', $libro, $year, $autor, $ed, $ISBN13, $ISBN10, $pedido);\n";
#print "$ISBN10 \n";
my $ds = "DBI:mysql:library:localhost";
my $user_sql;
my $passwd;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf",$user_sql,$passwd) || die "Can't connect!";
my $sth=$dbh->prepare("INSERT INTO libro (titulo, year_pub, autores, editorial, ISBN_13, ISBN_10, year_order) VALUES (?, ?, ?, ?, ?, ?, ?)");
$sth->execute($libro, $year, $autor, $ed, $ISBN13, $ISBN10, $pedido);
$dbh->disconnect;
}
