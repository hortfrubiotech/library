#!/usr/bin/perl -w
#tabla_biblio_net.pl
use strict;

schema();
sub schema {
  # code to create and print your SQL table definition (DDL)
  # for example...
  print <<END;
DROP TABLE IF EXISTS libro;
CREATE TABLE libro(
    libro_id   INT NOT NULL AUTO_INCREMENT,
    titulo     VARCHAR (100) NOT NULL,
    year_pub   YEAR,
    autores    TEXT NOT NULL,
    editorial  VARCHAR (40),
    ISBN_13    VARCHAR (25) NOT NULL,
    ISBN_10    VARCHAR (25),
    year_order YEAR,
    PRIMARY KEY (libro_id)
	    ) ENGINE=InnoDB;

END
;
}
