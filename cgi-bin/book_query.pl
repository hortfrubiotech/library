#!/usr/bin/perl --
#book_query.pl
#The next script takes a book name (provided by the request_book_user.pl form)
#and return the user in charge of that book.
#At first, the libro_id is obtained from the 'libro' table within the DB.
#After that, the user is obtained joining the 'biblio' table and the 'user' table. 
use strict;
use warnings;

use CGI qw( :standard);
use CGI::Carp qw( fatalsToBrowser );
use CGI::Pretty;

use DBI;
use DBD::mysql;
use Scalar::MoreUtils qw(empty);
my $ds = "DBI:mysql:library:localhost";
my $user;
my $password;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf", $user, $password) || die "Can't connect!";
my $libro=();
my $user=();
my $user_id=();
my $libro_id=();
my $query_1= q(SELECT libro_id FROM libro WHERE titulo LIKE ?);
my $query_2= q(SELECT nombre FROM usuario JOIN biblio ON usuario.user_id=biblio.user_id WHERE libro_id LIKE ?);
my $sth =  $dbh->prepare($query_1);

my $cgi= new CGI;

print
   $cgi->header,
$cgi->start_html('Book search'),
$cgi->h1('Search results:');
    
#Get the book_id from the DB with query_1. 
$sth->execute($cgi->param('book'));
my @query_results;
my $libro_id= $sth->fetchrow_array();

#Get the user name with query_2.     
my $sth_final = $dbh->prepare($query_2);
$sth_final->execute($libro_id);
my $query_results = $sth_final->fetchrow_array();

#Print the results. 
if (length $query_results > 0){
print "The book resquested is under the custody of $query_results.\n";
} else { 
print "What a pity! this book is not assigned to anybody.\n";
print $cgi->p('If you know who is in charge of this book, you can update it in the', a({ href => '../cgi-bin/form_update_biblio.pl'}, 'in the update form page.'));
}

print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page')
);


$sth->finish;
$dbh->disconnect;
print $cgi->end_html;
exit;


