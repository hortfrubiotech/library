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
$cgi->start_html('Update loan'),
$cgi->h1('Update or insert a new loan'),
$cgi->p('The next popup menu show all books and users present in the database, to make a loan,  assign a book to an user and click submit.');


$sth->execute();
my @query_book;
my @query_user;
while (my @results= $sth->fetchrow_array()){
	push (@query_book, @results);
}
$sth_user->execute();
while (my @users= $sth_user->fetchrow_array()){
        push (@query_user, @users);
}

print $cgi->start_form(
        -name    => 'books',
        -method  => 'GET',
        -action => '/cgi-bin/update_biblio.pl',
),  
$cgi->popup_menu(
        -name    => 'book',
        -values  => \@query_book,           
	),
$cgi->br,
$cgi->popup_menu(
        -name    => 'user',
        -values  => \@query_user,
        ),
$cgi->br,
$cgi->submit(-value=>'Submit', -action=>'/cgi-bin/update_biblio.pl'),
$cgi->end_form;



print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page')
);

$sth->finish;
$dbh->disconnect;
print $cgi->end_html;
exit;

