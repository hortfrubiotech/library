#!/usr/bin/perl --
#query.pl
#This script retrieve the data present in 'biblio' table, that is, the loan distribution.
#Both user_id and book_id, are used to get their respective information in 'libro' and 'usuario' tables. 
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
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf", $user, $password) || die "Can't connect!";
my $user_id=();
my $libro_id=();
my $query_1= q(SELECT libro_id, user_id  FROM biblio);
my $query_2= q(SELECT titulo, nombre, mail, tlf FROM libro, usuario WHERE user_id LIKE ? AND libro_id LIKE ? ORDER BY titulo ASC);
my $sth =  $dbh->prepare($query_1);

my $cgi= new CGI;

print
    $cgi->header,
$cgi->start_html('Books distribution'),
$cgi->h1('Books distribution'),
    $cgi->p('This is the actual state of lent books:');


$sth->execute();
my @query_results;
#Get the user and book id.
while (my @id= $sth->fetchrow_array()){
   my $libro_id = $id[0];
   my $user_id = $id[1];
   my $sth_final = $dbh->prepare($query_2);
   $sth_final->execute($user_id, $libro_id);
#Get usernames, book titles, dates ans ISBN. Prepare all of the in html table format.
   while (my $final = $sth_final->fetchrow_arrayref()){
       push (@query_results, $cgi->Tr($cgi->td($final)) );
}
}
#Show results in a table. 
·print $cgi->table(
{ -border => '1', cellpadding => '3', cellspacing=> '3' },
$cgi->Tr([
    $cgi->th([
'book', 'user', 'mail', 'tlf'
])
]),
@query_results
);
print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page')
);

$sth->finish;
$dbh->disconnect;
print $cgi->end_html;
exit;

