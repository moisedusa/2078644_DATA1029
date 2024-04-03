use epharmacy;

-- Question2 Aquoi servent les instructions des lignes 12 et 440 dans le fichier epharmacy.sql?
-- La ligne 12 : La ligne SET FOREIGN_KEY_CHECKS = 0; dans un script SQL sert à désactiver temporairement la vérification des contraintes de clé étrangère dans la base de données. Lorsque cette instruction est exécutée, la base de données ne vérifiera pas la validité des clés étrangères lors des opérations comme les insertions, les mises à jour ou les suppressions de données.

-- La ligne 440 : La commande SET FOREIGN_KEY_CHECKS = 1; sert à réactiver la vérification des contraintes de clé étrangère dans une base de données. Lorsque cette instruction est exécutée, la base de données reprendra la vérification de l'intégrité référentielle lors des opérations telles que les insertions, les mises à jour ou les suppressions de données.

--  4-le nom complet des utilisateurs de la e_pharmacie et la duree moyenne de chacun une fois connecte dans l'application.
 
 SELECT CONCAT(u.firstname, ' ', u.lastname) AS full_name, 
       SEC_TO_TIME(AVG(TIME_TO_SEC(ch.onsite_time))) AS average_duration
FROM users u
JOIN connection_history ch ON u.id = ch.user_id
GROUP BY u.id;


-- 5- le role de l'utilisateur ayant passe le plus de temps etant connecte dans l'application 

SELECT r.name AS role_name
FROM users u
JOIN connection_history ch ON u.id = ch.user_id
JOIN roles r ON u.role_id = r.id
GROUP BY u.id
ORDER BY SUM(TIME_TO_SEC(ch.onsite_time)) DESC
LIMIT 1;

-- 6-les fournisseurs des 3 produits les plus commercialises 

SELECT p.name AS product_name, s.name AS supplier_name, COUNT(*) AS total_orders
FROM orders o
JOIN cart_product cp ON o.cart_id = cp.cart_id
JOIN products p ON cp.product_id = p.id
JOIN suppliers s ON p.supplier_id = s.id
GROUP BY p.id
ORDER BY total_orders DESC
LIMIT 3;

-- 7 les chiffres d'affaires par entrepots

SELECT w.name AS warehouse_name, COALESCE(SUM(op.quantity * p.price), 0) AS chiffre_affaires
FROM warehouses w
LEFT JOIN products p ON w.id = p.warehouse_id
LEFT JOIN stock_product sp ON p.id = sp.product_id
LEFT JOIN stocks s ON sp.stock_id = s.id
LEFT JOIN orders o ON s.id = o.cart_id
LEFT JOIN cart_product op ON o.cart_id = op.cart_id AND p.id = op.product_id
GROUP BY w.id;

-- 8-Modifier la table products de sorte a affecter l'image "medoc.jpg"comme image par defaut aux produits medicaux 

SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET image = 'medoc.jpg'
WHERE description LIKE '%médical%' OR description LIKE '%médecin%' OR description LIKE '%pharmacie%';

-- 9- ajouter une colonne gender specifiant le sexe des utilisateurs de l'application. cette colonne doit etre une enumeration contenant pour valeur :MALE ,FEMALE et OTHER.


ALTER TABLE users
ADD COLUMN gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL DEFAULT 'OTHER';

--  10-procedure stockee spprofileImage permettant  d'affecter une image de profil par defaut aux utilisateurs :   
--  a) Les utilisateurs Male auront pour image male.jpg   
--  b) les utilisateurs Female  auront pour image female.jpg 
-- c) les autres utilisateurs auront pour image other.jpg
-- NB: les utilisateurs ayant deja specifie leur image de profil ne sont donc pas affectes par l'execution de cette procedure .


DELIMITER //
CREATE PROCEDURE spprofileImage()
BEGIN
    UPDATE users
    SET profile_image = CASE
        WHEN gender = 'MALE' AND profile_image IS NULL THEN 'male.jpg'
        WHEN gender = 'FEMALE' AND profile_image IS NULL THEN 'female.jpg'
        WHEN profile_image IS NULL THEN 'other.jpg'
    END;
END //
DELIMITER ;



-- 11-Ajouter une contrainte a la table user afin de garantir l'unicite des adresses electronique (email) des utilisateurs de l'application.

ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);

-- --12- Effectuez sous forme de transactions toutes les insertions nécessaires pour passer les ventes représentées par la capture suivante :
-- a. Insérer un nouvel utilisateur au nom de Alain Foka avec un mot de passe correspondant à la chaine vide. 
INSERT INTO users (firstname, lastname,country, email, password,image, role_id)
VALUES ('Alain', 'Foka', 'France', 'alain.foka@example.com', '','', 3);
-- -- b. La date de chaque commande doit être à l’instant auquel la commande est insérée 
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id, cart_id)  
VALUES (1, NOW(), 2, 2, 2, 1);
-- -- c. Ces commandes sont éditées par l’administrateur Abdoulaye Mohamed 
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id, cart_id)  
VALUES (2, NOW(), 2, 0, (SELECT user_id FROM users WHERE firstname = 'Abdoulaye' and lastname = 'Mohamed'), 1);
-- -- d. Calculez le total de chacune des commandes et insérer convenablement 

-- Total pour Advil : 4 unités à 43.87 chacune
SET @advil_total := 4 * 43.87;

-- Total pour Paracetamol2 : 4 unités à 12.19 chacune
SET @paracetamol_total := 4 * 12.19;

-- Total pour Gravol : 17 unités à 5.00 chacune
SET @gravol_total := 17 * 5.00;

-- Total pour Multivitamine : 1 unité à 15.00 chacune
SET @multivitamine_total := 1 * 15.00;

-- Total pour Bon Koga : 2 unités à 35.10 chacune
SET @bonkoga_total := 2 * 35.10;

-- Insérer les totaux dans la table cart_product
UPDATE cart_product SET total = @advil_total WHERE cart_id = 1 AND product_id = 3;
UPDATE cart_product SET total = @paracetamol_total WHERE cart_id = 1 AND product_id = 2;
UPDATE cart_product SET total = @gravol_total WHERE cart_id = 1 AND product_id = 6;
UPDATE cart_product SET total = @multivitamine_total WHERE cart_id = 1 AND product_id = 10;
UPDATE cart_product SET total = @bonkoga_total WHERE cart_id = 1 AND product_id = 4;


-- Total pour Ibuprofène : 5 unités à 28.50 chacune
SET @ibuprofene_total := 5 * 28.50;

-- Total pour Ducolax : 3 unités à 20.75 chacune
SET @ducolax_total := 3 * 20.75;

-- Total pour Tilenol : 4 unités à 23.40 chacune
SET @tilenol_total := 4 * 23.40;

-- Total pour Gravol : 7 unités à 5.00 chacune
SET @gravol_total_af := 7 * 5.00;

-- Insérer les totaux dans la table cart_product
UPDATE cart_product SET total = @ibuprofene_total WHERE cart_id = 2 AND product_id = 8;
UPDATE cart_product SET total = @ducolax_total WHERE cart_id = 2 AND product_id = 9;
UPDATE cart_product SET total = @tilenol_total WHERE cart_id = 2 AND product_id = 1;
UPDATE cart_product SET total = @gravol_total_af WHERE cart_id = 2 AND product_id = 6;


INSERT INTO orders (customer_id, order_date, total_amount, status, user_id, cart_id)
SELECT @customer_id, @now, (SELECT SUM(total) FROM cart_product WHERE cart_id = 1) * 1.10, 1, @admin_id, 1;
 

-- -- e. Le taux d’impôt pour chacune des factures s’élève a 10% 
UPDATE invoices SET tax = montant * 0.10;

--  13-Modifier les utilisateurs de l’application ainsi qu’il :
ALTER TABLE users ADD COLUMN address varchar(100) DEFAULT NULL;

UPDATE users 
SET 
    firstname = 'Ali',
    lastname = 'Sani',
    designation = 'Comptable',
    address = '415 Av. de l’Université',
    province = 'NB',
    postal_code = 'E1A3E9',
    phone = '4065954526',
    email = 'Ali@ccnb.ca'
WHERE 
    id = 3;
    
    UPDATE users 
SET 
    firstname = 'Oumar',
    lastname = 'Moussa',
    designation = 'RH',
    address = '1750 Rue Crevier',
    province = 'QC',
    postal_code = 'H4L2X5',
    phone = '5665954526',
    email = 'Oumar@gmail.com'
WHERE 
    id = 6;

UPDATE users 
SET 
    firstname = 'Dupon',
    lastname = 'Poupi',
    designation = 'Consultant',
    address = '674 Vanhorne',
    province = 'NS',
    postal_code = 'B4V4V5',
    phone = '7854665265',
    email = 'Foka@ccnb.ca'
WHERE 
    id = 5;




