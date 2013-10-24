#!/usr/bin/perl -w
use strict;

schema();
sub schema {
  # code to create and print your SQL table definition (DDL)
  # for example...
  print <<END;
DROP TABLE IF EXISTS usuario;
CREATE TABLE usuario(
    user_id   INT NOT NULL AUTO_INCREMENT,
    nombre    VARCHAR(50) NOT NULL,
    mail      VARCHAR(50) NOT NULL,
    tlf       SMALLINT,
    localizacion TEXT,
    PRIMARY KEY (user_id)
    )ENGINE=InnoDB;

END
;
}

