-- 1. la liste des utilisateurs de l'application selon leur role.
select u.full_name as 'Nom complet', r.name as "Role" 
from user u join  role r  
ON u.role_id = r.id;

-- 2. Noms et quantités des produits achetés par Oumar Moussa
SELECT p.name AS Desigantion , ol.quantity as Quantite
FROM user u
JOIN invoice i ON u.id = i.customer_id
JOIN orders o ON i.order_id = o.id
JOIN OrderLine ol ON o.id = ol.order_id
JOIN product p ON ol.product_id = p.id
WHERE u.full_name = 'Oumar Moussa';

-- 3. Quel sont les noms de produits dont le fournisseur est basé à Moncton
SELECT p.name AS Nom_produit, city as Ville
FROM supplier s
JOIN product p ON s.id = p.supplier_id
WHERE s.city = 'Moncton';

-- 4.  Qui a passé le plus de temps une fois connecté dans l’application
SELECT u.full_name AS nom_utilisateur, SUM(ch.onsite_time) AS temps_connection
FROM user u
JOIN connection_history ch ON u.id = ch.user_id
GROUP BY u.full_name
ORDER BY  temps_connection DESC
LIMIT 1;

-- 5. Quel est le dernier utilisateur à se déconnecter
SELECT u.full_name AS nom_utilisateur, ch.logout_date as Deconnection
FROM user u
JOIN connection_history ch ON u.id = ch.user_id
ORDER BY ch.logout_date DESC
LIMIT 1;



