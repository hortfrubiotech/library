#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;
use utf8;
use Unicode::Normalize;
use Text::Unaccent;
my $charset= "UTF-8";

my @id_libro = ();
my @id_user = ();
my @keys = ();
my $book_field=();
my $user_field=(); 


my $file = "/home/biblioteca/raw_data/prestamo.txt";
open (FILE, $file) or die("Can't open $file: $!\n");
my @lines = <FILE>;
close FILE;


for my $line(@lines) {
    chomp $line;

    if ($line =~ /^libro/)  {
	@keys = split ("\t", $line);#obtiene las keys de la lineas que las contiene
    next;
}
my @data = split ("\t", $line);#obtiene el libro y el usuario de la tabla y los separa en dos variables. 
   for my $datum (@data){
	$datum =~ s/^\s+|\s+$//g;#remove leading and ending whitespaces.
       	$datum =unac_string($charset, $datum);
	
   }

   my $book = $data[0];
    $book=~ s/[-]//g;## quita el símbolo "-" del ISBN.
   if ($book =~ /\d{6}/)  {
     $book_field = "ISBN_13";
   }
    else {
     $book_field= "titulo";

}
my $ds = "DBI:mysql:library:localhost";
my $user_sql;
my $password;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf",
                $user_sql, $password) || die "Can't connect!";

my $sth_libro = $dbh->prepare("SELECT libro_id FROM libro WHERE $book_field LIKE ?"); 
   $sth_libro->execute ($book);
   @id_libro = $sth_libro->fetchrow_array;
   
my $user = $data[1];

if ($user=~ /@/) {
    $user_field = "mail";
}
else { 
    $user_field = "nombre";
}

my $sth_user = $dbh->prepare("SELECT user_id FROM usuario WHERE $user_field LIKE ?");
$sth_user->execute ($user."%");
@id_user = $sth_user->fetchrow_array;
my $keys = join (",", @keys);
my $sth=$dbh->prepare("INSERT INTO biblio ($keys) VALUES (?, ?)");
   $sth->execute(@id_libro, @id_user);

}

