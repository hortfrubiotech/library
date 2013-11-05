#!/usr/bin/perl --
#This script update the biblio table, matching a book with an user. 
use strict;
use warnings;

use CGI qw( :standard);
use CGI::Carp qw( fatalsToBrowser );
use CGI::Pretty;

use DBI;
use DBD::mysql;
use Scalar::MoreUtils qw(empty);

use Text::Unaccent;
use utf8;
use Unicode::Normalize;

my $ds = "DBI:mysql:library:localhost";
my $user;
my $password;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf", 
$user, $password) || die "Can't connect!";
my $charset= "UTF-8";
my $libro=();
my @libro_titulo=();
my @user_nombre=();
my @libro_id=();
my $user_id=();
my $libro_id=();
my $cgi= new CGI;

print $cgi->header,
$cgi->start_html('New loan'),
$cgi->h1('New loan'),
$cgi->p('Congratulations!');

##These are the values obtained from the form page. 
my $book=$cgi->param('book');
my $user=$cgi->param('user');

# The MySQL statements.
my $query_bookid=q(SELECT libro_id FROM libro WHERE titulo LIKE ?);
my $query_userid=q(SELECT user_id FROM usuario WHERE nombre LIKE ?);#That obtain the users name and will be used in the popup menu of the update form.
my $query_biblio=q(SELECT user_id FROM biblio WHERE libro_id LIKE ?);
my $query_update=q(UPDATE biblio SET user_id = ? WHERE libro_id = ?);
my $query_insert=q(INSERT INTO biblio (user_id, libro_id) VALUES (?, ?));
my $sth_bookid=$dbh->prepare($query_bookid);
my $sth_userid=$dbh->prepare($query_userid);
my $sth_biblio=$dbh->prepare($query_biblio);
my $sth_update=$dbh->prepare($query_update);
my $sth_insert=$dbh->prepare($query_insert);
$sth_bookid->execute($book);
$sth_userid->execute($user);

## Now  obtain the book_id and user_id. 
my $book_id=$sth_bookid->fetchrow_array();
my $user_id=$sth_userid->fetchrow_array();
$sth_biblio->execute($book_id);
my $user_biblio=$sth_biblio->fetchrow_array();

if (length $user_biblio > 0){ # This checks if there is any entry for a given book in the biblio table. 
$sth_update->execute($user_id, $book_id); # update user for a given book. 
print "The book: $book , had been updated and now is under the custody of: $user.\n";
} else { 
$sth_insert->execute($user_id, $book_id); # Create a new entry in the biblio table, and asign a book to an user.
print "You create a new entry, now the book: $book is under the custody of: $user.\n"; ##If book title doesn't match the book is also submited to the DB.
} 

print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page'));


$dbh->disconnect;
print $cgi->end_html;
exit;


 
