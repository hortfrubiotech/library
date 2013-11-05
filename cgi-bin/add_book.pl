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
$cgi->start_html('Book added'),
$cgi->h1('New book');

##These are the values obtained from the form page. 
my $title_accent=$cgi->param('title');
my $title=unac_string($charset, $title_accent);
my $pub_year=$cgi->param('pub_year');
my $author_accent=$cgi->param('author');
my $author=unac_string($charset, $author_accent);
my $pub_accent=$cgi->param('pub');
my $pub=unac_string($charset, $pub_accent);
my $isbn_10=$cgi->param('isbn_10');
my $isbn_13=$cgi->param('isbn_13');
my $order=$cgi->param('order');
my @data=("$title", "$pub_year", "$author", "$pub", "$isbn_13", "$isbn_10", "$order");
for my $datum(@data){ ## Clean for unwanted symbols or white spaces. 
$datum=~ s/^\s+|\s+$//g;
$datum=~ s/[-]//g;
}

if (length $title==0){
print "You did not submit a valid book title, please go back an complete correctly the form.\n";
print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page'));
}else{
## The MySQL statements.
my $query_id=q(SELECT libro_id FROM libro WHERE titulo LIKE ?);
my $query_year=q(SELECT year_pub, year_order  FROM libro WHERE libro_id LIKE ?);
my $query_user=q(SELECT nombre FROM usuario ORDER BY nombre ASC);#That obtain the users name and will be used in the popup menu of the update form.
my $sth_year=$dbh->prepare($query_year);
my $sth_id=$dbh->prepare($query_id);
my $sth_user=$dbh->prepare($query_user);
$sth_id->execute($title);

## Now it's obtained the book_id to check if there is already a book with the same title in the database. 
my $book_id=$sth_id->fetchrow_array();
my @years;

if (length $book_id > 0){ # This is the first control point. 
$sth_year->execute($book_id); # Get the publication year and the order year of the book, to check if the new entry is a new edition or order. 
@years=$sth_year->fetchrow_array();
	if (($years[0]=$pub_year) && ($years[1]=$order)){
print "There is already a book stored in the database with the same title, year of publication and year of order, probably, it is the same book that you are trying to submit, if you are sure that it is a different book, please go back to the form page, change the order year, and indicate in the title that this is a different copy.\n";  
	print $cgi->p(a({ href=> '../library/add_book.html'}, 'Go back to add book page'));
	}else { print "Congratulations! you create a new book entry.\n"; ## If the pub year and/or the order year doesn't match with the values within the DB, the book is inserted. 
	insert(); }
} else { print "Congratulations! you create a new book entry.\n"; ##If book title doesn't match the book is also submited to the DB.
insert();

} 

sub insert {
my $insert= q(INSERT INTO libro (titulo, year_pub, autores, editorial, ISBN_13, ISBN_10, year_order) VALUES (?, ?, ?, ?, ?, ?, ?));
my $sth_ins =  $dbh->prepare($insert);
$sth_ins->execute(@data);

print  $cgi->p('These are the values that you submited for the new book:');
my @data_table;
 
for my $_(@data){
push (@data_table, $cgi->td($_) );
}
print $cgi->table(
{ -border => '1', cellpadding => '3', cellspacing=> '3' },
$cgi->Tr([
    $cgi->th([
	'Book title', 'pub. year', 'author',
        'publisher', 'isbn 13', 'isbn 10', 'order year'
])
]),
@data_table
);
print $cgi->p('If these data are not correct, you can undo your changes by',a({ href=> '../cgi-bin/delete_last_book.pl'}, 'clicking here.')),
$cgi->p('To assign the new book to an user you can use the', a({ href=> '../cgi-bin/form_update_biblio.pl'},'the update form.'));


print $cgi->p(a({ href => '../library/index.html'}, 'Go to home page'));
}
}
$dbh->disconnect;
print $cgi->end_html;
exit;


 
