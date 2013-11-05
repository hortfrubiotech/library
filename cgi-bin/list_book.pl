#!/usr/bin/perl --

use strict;
use warnings;

use CGI qw( :standard);
use CGI::Carp qw( fatalsToBrowser );
use CGI::Pretty;

use DBI;
use DBD::mysql;
my $ds = "DBI:mysql:library:localhost";
my $user;
my $password;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf",
                $user, $password) || die "Can't connect!";

my $libro=();
my $user=();
my @libro_titulo=();
my @user_nombre=();
my @libro_id=();
my $user_id=();
my $libro_id=();
my $query_1= q(SELECT titulo, autores, year_pub, year_order, ISBN_13 FROM libro ORDER BY titulo ASC);
my $sth =  $dbh->prepare($query_1);

my $cgi= new CGI;

print
    $cgi->header,
$cgi->start_html('Book list'),
$cgi->h1('Book list'),
    $cgi->p('A complete lists of all the books stored in the database:');


$sth->execute();
my @query_results;
while (my $results= $sth->fetchrow_arrayref()){
       push (@query_results, $cgi->Tr($cgi->td($results)) );
}

print $cgi->table(
{ -border => '1', cellpadding => '3', cellspacing=> '3' },
$cgi->Tr([
    $cgi->th([
'Book', 'autores', 'pub year', 'order_year', 'ISBN 13'
])
]),
@query_results
);

print $cgi->p(
a({ href => '../library/index.html'}, 'Go to home page')
);
$sth->finish;
$dbh->disconnect;
print $cgi->end_html;
exit;

