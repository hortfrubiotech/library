#!/usr/bin/perl --

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
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf", $user, $password) || die "Can't connect!";
my $charset= "UTF-8";
my $libro=();
my @libro_titulo=();
my @user_nombre=();
my @libro_id=();
my $user_id=();
my $libro_id=();
my $cgi= new CGI;
my $query_1=q(DELETE FROM usuario ORDER BY user_id DESC LIMIT 1);
my $sth =  $dbh->prepare($query_1);
$sth->execute();

print
   $cgi->header,
	$cgi->start_html('Delete user'),
$cgi->h1('Delete a new user entry'),
$cgi->p('You have delete your changes'), 
$cgi->p(a({ href =>'../library/add_book.html'}, 'go to the add user page and restart the process'));
print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page')
);


$dbh->disconnect;
print $cgi->end_html;
exit;


 
