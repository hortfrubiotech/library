#!/usr/bin/perl -w
#tabla_biblio_net.pl
use strict;

schema();
sub schema {
  # code to create and print your SQL table definition (DDL)
  # for example...
  print <<END;
DROP TABLE IF EXISTS biblio;
CREATE TABLE biblio(
    ID           INT NOT NULL AUTO_INCREMENT,  
    user_id   INT NOT NULL,
    libro_id      INT NOT NULL REFERENCES libro(libro_id), 
    PRIMARY KEY (ID),
    FOREIGN KEY(user_id)    
    REFERENCES usuario(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(libro_id)    
    REFERENCES libro(libro_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
	) ENGINE=InnoDB;


END
;
}
