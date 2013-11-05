#!/usr/bin/perl --
#user_query.pl
#The next script return a table with all the book in custody of 
#the user submited. The username come from the request_book_user.pl form.
#At first, the user_id is obtained from the 'usuario' table within the DB.
#After that, the book titles are obtained joining the 'biblio' table and the 'libro' table.  
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
my $query_1= q(SELECT user_id FROM usuario WHERE nombre LIKE ?);
my $query_2= q(SELECT titulo FROM libro JOIN biblio ON libro.libro_id=biblio.libro_id WHERE biblio.user_id LIKE ?);
my $sth =  $dbh->prepare($query_1);

my $cgi= new CGI;

print
   $cgi->header,
	$cgi->start_html('User search'),
	$cgi->h1('User search'),
    $cgi->p('Search results:');


$sth->execute($cgi->param('user'));
my @query_results;

#Get the user_id. 
my $user_id= $sth->fetchrow_array();

#Get the book list and prepare the data for the table html format. 
   my $sth_final = $dbh->prepare($query_2);
   $sth_final->execute($user_id);
   while (my $final = $sth_final->fetchrow_arrayref()){
       push (@query_results, $cgi->Tr($cgi->td($final)) );
}
#Print the table if the user has some books under his custody.
if (length $query_results[0] > 0){
print $cgi->p('The user requested has under his custody the following books:'),
$cgi->table(
{ -border => '1', cellpadding => '3', cellspacing=> '3' },
$cgi->Tr([
    $cgi->th([
'Book'
])
]),
@query_results
);
}else{
#Print that if the user_id return nothing. 
print $cgi->p('The user requested doesn\'t have any book under his custody.')
}
print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page')
);



$sth->finish;
$dbh->disconnect;
print $cgi->end_html;
exit;


