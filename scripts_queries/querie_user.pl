#!/usr/bin/perl -w
use strict;
use DBI;
use DBD::mysql;

while (my $line = <>) {
    chomp $line;

 my $mail = $line;

my $ds = "DBI:mysql:biblioteca:localhost";
my $user_sql = "hugo";
my $passwd = "pimiento+34";
my $dbh = DBI->connect($ds,$user_sql,$passwd) || die "Can't connect!"; 

my $sth_user_id = $dbh->prepare("SELECT user_id FROM usuario WHERE mail LIKE ?");
$sth_user_id->execute ($mail);
my @user_id = $sth_user_id->fetchrow_array;


my $sth_titulo = $dbh->prepare("SELECT titulo FROM libro  JOIN biblio ON biblio.libro_id=libro.libro_id WHERE biblio.user_id LIKE ?");
$sth_titulo->execute (@user_id);
my @titulo = $sth_titulo->fetchrow_array;
print "El usuario $mail tiene bajo custodia @titulo] \n";
}
