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
my $query_1= q(SELECT titulo FROM libro ORDER BY titulo ASC);
my $sth =  $dbh->prepare($query_1);
my $query_2= q(SELECT nombre FROM usuario ORDER BY nombre ASC);
my $sth_user=$dbh->prepare($query_2);
my $cgi= new CGI;

print
    $cgi->header,
$cgi->start_html('Request'),
$cgi->h1('Request for books and users'),
$cgi->h2('Who has this book?!'),
$cgi->p('The next popup menu show all books stored within the database, if you want to check who is  in charge of any of them, select the one you are looking for and click Submit.');


$sth->execute();
my @query_book;
while (my @results= $sth->fetchrow_array()){
       push (@query_book, @results);

}
  print $cgi->start_form(
        -name    => 'books',
        -method  => 'GET',
        -action => '/cgi-bin/book_query.pl',
),  
$cgi->popup_menu(
        -name    => 'book',
        -values  => \@query_book,           
	),
$cgi->submit(-value=>'Submit', -action=>'/cgi-bin/book_query.pl'),
$cgi->end_form;

print $cgi->h2('What books has this user?!'),
$cgi->p('The next popup menu show all users recorded in the database, if you want to check the books under the custody of any of them, select one and click Submit.');
$sth_user->execute();
my @query_user;
while (my @users= $sth_user->fetchrow_array()){
       push (@query_user, @users);

}
  print $cgi->start_form(
        -name    => 'main_form',
        -method  => 'GET',
        -action => '../cgi-bin/user_query.pl',
),
$cgi->popup_menu(
        -name    => 'user',
        -values  => \@query_user,
        ),
$cgi->submit(-value=>'Submit', -action=>'../cgi-bin/user_query.pl'),
$cgi->end_form;


print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page')
);

$sth->finish;
$dbh->disconnect;
print $cgi->end_html;
exit;

