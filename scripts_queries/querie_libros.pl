#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;

while (my $line = <>) {
    chomp $line;

 my $isbn = $line;

my $ds = "DBI:mysql:library:localhost";
my $user;
my $password;
my $dbh = DBI->connect($ds.";mysql_read_default_file=$ENV{HOME}/.my.cnf", $user, $password) || die "Can't connect!"; 

my $sth_libro_id = $dbh->prepare("SELECT libro_id FROM libro WHERE ISBN_13 LIKE ?");
$sth_libro_id->execute ($isbn);
my @libro_id = $sth_libro_id->fetchrow_array;

my $sth_libro_titulo = $dbh->prepare("SELECT titulo FROM libro WHERE ISBN_13 LIKE ?");
$sth_libro_titulo->execute ($isbn);
my @libro_titulo = $sth_libro_titulo->fetchrow_array;

my $sth_name = $dbh->prepare("SELECT nombre, mail FROM usuario  JOIN biblio ON biblio.user_id=usuario.user_id WHERE biblio.libro_id LIKE ?");
$sth_name->execute (@libro_id);
my @name = $sth_name->fetchrow_array;
print "El libro @libro_titulo está bajo custodia de $name[0], email: $name[1] \n";
$dbh->disconnect;
}
