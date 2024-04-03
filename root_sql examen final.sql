use epharmacy;

SELECT user FROM mysql.user WHERE user = 'pharma' AND host = 'localhost';

DROP USER 'pharma'@'localhost';
--   3.creer l'utilisateur pharma avec pour mot de passe 1234
 CREATE USER 'pharma'@'localhost' IDENTIFIED BY '1234';
 
GRANT ALL PRIVILEGES ON epharmacy.* TO 'pharma'@'localhost';





