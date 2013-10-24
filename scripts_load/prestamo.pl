#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;


my @keys = ();
while (my $line = <>) {
    chomp $line;

    if ($line =~ /^libro/)  {
	@keys = split (" ", $line);#obtiene las keys de la lineas que las contiene
    next;
}
my @data = split (" ", $line);#obtiene el libro y el usuario de la tabla y los separa en dos variables. 
my $isbn = $data[0];
   $isbn=~ s/[-]//g;## quita el símbolo "-" del ISBN.
my $user = $data[1];
my $keys = join (",", @keys);

my @id_libro = ();
my @id_user = ();
my $ds = "DBI:mysql:biblioteca:localhost";
my $user_sql = "hugo";
my $passwd = "pimiento+34";
my $dbh = DBI->connect($ds,$user_sql,$passwd) || die "Can't connect!"; 

my $sth_libro = $dbh->prepare("SELECT libro_id FROM libro WHERE ISBN_13 LIKE ?");
my $sth_user = $dbh->prepare("SELECT user_id FROM usuario WHERE mail LIKE ?");
$sth_libro->execute ($isbn);
$sth_user->execute ($user."%");
@id_libro = $sth_libro->fetchrow_array;
@id_user = $sth_user->fetchrow_array;

print "INSERT INTO biblio ($keys) VALUES (@id_libro, @id_user);\n";

}
#$dbh->disconnect;
