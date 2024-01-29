-- 1. À partir de la table « titles », obtenir la liste des titres contenant le mot « computer » Afficher le
-- titre et le prix de chaque livre.
SELECT title, price
FROM titles
where title like "%computer%" ;
 
 -- 2. À partir de la table « titles », obtenir la liste des titres contenant le mot « computer » (au
-- singulier). Afficher le titre et le prix de chaque livre.
SELECT title, price
FROM titles
where title like "%computer%" and title not like "%computers%" ;
 -- 3. À partir de la table « titles », obtenir la liste des titres dont l’identifiant débute par SU ou BU.
-- Afficher le titre et le prix de chaque livre.
SELECT title, price
FROM titles
where title_id like "SU%" or title_id like "BU%";

-- 4. À partir de la table « titles », obtenir la liste des titres dont l’identifiant ne débute pas par SU ou
-- BU. Afficher le titre et le prix de chaque livre.
SELECT title, price
FROM titles
where title_id not like "SU%" or title_id not like "BU%";

-- 5. À partir de la table « titles », obtenir la liste des titres ne débutant ni par S, ni par B, mais dont la
-- seconde lettre est « o ». Afficher le titre et le prix.
SELECT title, price
FROM titles
where title not like "S%" and title not like  "B%" and title  like "_o%";

-- 6. À partir de la table « titles », obtenir la liste des titres ne débutant ni par S, ni par B, mais dont la
-- 3ème lettre est « f ». Afficher le titre et le prix.
SELECT title, price
FROM titles
where title not like "S%" and title not like  "B%" and title  like "__f%";

-- 7. À partir de la table « titles », obtenir la liste des titres débutant par l’une des 10 premières
-- lettres de l’alphabet. Afficher le titre et le prix. (commande simple qui a refuse : where title rlike "[A-J]%")
SELECT title, price
FROM titles
where   title like "a%"  or title like "b%" or title like "c%" or title like "d%" or title like "e%" or title like "f%"
or title like "g%" or title like "h%" or title like "i%" or title like "j%";


 