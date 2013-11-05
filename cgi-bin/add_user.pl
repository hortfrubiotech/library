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
my $userdb;
my $password;
my $dbh = DBI->connect($ds. ";mysql_read_default_file=/home/.my.cnf", 
$userdb, $password) || die "Can't connect!";
my $charset= "UTF-8";
my $libro=();
my @libro_titulo=();
my @user_nombre=();
my @libro_id=();
my $user_id=();
my $libro_id=();
my $cgi= new CGI;

print $cgi->header,
$cgi->start_html('Add users'),
$cgi->h1('New user');

##These are the values obtained from the form page. 
my $name_accent=$cgi->param('name');
my $name=unac_string($charset, $name_accent);
my $mail=$cgi->param('mail');
my $local_accent=$cgi->param('local');
my $local=unac_string($charset, $local_accent);
my $tlf=$cgi->param('tlf');
my @data=("$name", "$mail", "$tlf", "$local");
for my $datum(@data){ ## Clean for unwanted symbols or white spaces. 
$datum=~ s/^\s+|\s+$//g;
$datum=~ s/[-]//g;
}
if (length $name==0){
print "You did not submit a valid name for the new user, please go back and complete correctly the form.\n";
print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page.'));
}else{
;
## The MySQL statements.
my $query_id=q(SELECT user_id FROM usuario WHERE nombre LIKE ?);
my $query_data=q(SELECT mail, tlf,localizacion   FROM usuario WHERE user_id LIKE ?);
my $query_user=q(SELECT nombre FROM usuario ORDER BY nombre ASC);#That obtain the users name and will be used in the popup menu of the update form.
my $sth_data=$dbh->prepare($query_data);
my $sth_id=$dbh->prepare($query_id);
my $sth_user=$dbh->prepare($query_user);
$sth_id->execute($name);

## Now it's obtained the book_id to check if there is already a book with the same title in the database. 
my $user_id=$sth_id->fetchrow_array();
if (length $user_id > 0){ # This is the first control point. 
$sth_data->execute($user_id); # Get the publication year and the order year of the book, to check if the new entry is a new edition or order. 
my @user_data=$sth_data->fetchrow_array();
print "You have submit an user that is already stored in the database, do you want to update some values? Click here [link needed]\n" 
} else { print "Congratulations! you create a new user entry.\n"; ##If book title doesn't match the book is also submited to the DB.
insert();

} 

sub insert {
my $insert= q(INSERT INTO usuario (nombre, mail, tlf, localizacion) VALUES (?, ?, ?, ?));
my $sth_ins =  $dbh->prepare($insert);
$sth_ins->execute(@data);

print  $cgi->p('This are the values that you entered for the new user:');
my @data_table;
 
for my $_(@data){
push (@data_table, $cgi->td($_) );
}
print $cgi->table(
{ -border => '1', cellpadding => '3', cellspacing=> '3' },
$cgi->Tr([
    $cgi->th([
	'User name', 'mail', 'extenssion',
        'location'
])
]),
@data_table
);
print $cgi->p('If you made a mistake, you can undo your changes by',a({ href=> '../cgi-bin/delete_last_user.pl'}, 'clicking here.')),

$cgi->p('To assign books to the new user you can use the', a({ href=> '../cgi-bin/form_update_biblio.pl'}, 'update form page.'));
}

print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page.'));
}

$dbh->disconnect;
print $cgi->end_html;
exit;


 
