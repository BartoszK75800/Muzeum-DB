CREATE USER 'kustosz'@'localhost' IDENTIFIED BY 'kUst00$2Z';
GRANT ALL PRIVILEGES ON * . * TO 'kustosz'@'localhost';

CREATE USER 'klient'@'localhost';
GRANT SELECT ON bilety TO 'klient'@'localhost';
GRANT SELECT ON dzialy_tematyczne TO 'klient'@'localhost';
GRANT SELECT ON wystawy_stale TO 'klient'@'localhost';
GRANT SELECT ON wystawy_czasowe TO 'klient'@'localhost';
GRANT SELECT ON eksponaty TO 'klient'@'localhost';