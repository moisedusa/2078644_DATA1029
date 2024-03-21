-- 1. Noms complets des employés de plus haut grade par employeurs
SELECT concat(e.fname,' ', e.lname) as noms_complet , e.job_lvl,p.pub_name AS employeur
FROM employees e
JOIN publishers p ON e.pub_id = p.pub_id
WHERE (e.pub_id, e.job_lvl) 
IN (SELECT pub_id, MAX(job_lvl) FROM employees GROUP BY  pub_id)
ORDER BY e.job_lvl DESC;

-- 2. Noms complets des employés ayant un salaire supérieur à celui de Norbert Zongo.
SELECT concat(e.fname,' ',e.lname) as noms_complet , e.salary
FROM employees e
WHERE e.salary > (SELECT salary FROM employees WHERE lname = 'Zongo' AND fname = 'Norbert');

-- 3.  Noms complets des employés des éditeurs canadiens.
SELECT concat(e.fname,' ', e.lname) as noms_complet 
FROM employees e JOIN publishers p 
ON e.pub_id = p.pub_id
WHERE p.country = 'Canada';

-- 4. Noms complets des employés qui ont un manager
SELECT concat(e.fname,' ', e.lname) as noms_complet
FROM employees e
WHERE e.job_lvl <> 'STAGIAIRE';

-- 5. Noms complets des employés qui ont un salaire au-dessus de la moyenne de salaire chez leur employeur.
SELECT concat(e.fname,' ',e.lname) as noms_complet, e.salary, p.pub_name AS employer
FROM employees e JOIN publishers p ON e.pub_id = p.pub_id
WHERE e.salary > (
SELECT AVG(e2.salary) FROM employees e2 WHERE e2.pub_id = e.pub_id);

-- 6. Noms complets des employés qui ont le salaire minimum de leur grade
SELECT distinct concat(e.fname,' ',e.lname) as noms_complet, e.salary, j.min_lvl as Grade
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE e.salary = (SELECT MIN(salary)
FROM employees WHERE job_id = e.job_id);

-- 7. De quels types sont les livres les plus vendus?
SELECT t.type AS type_de_livre, COUNT(*) AS nombre_de_ventes
FROM sales s JOIN titles t ON s.title_id = t.title_id
GROUP BY t.type
ORDER BY COUNT(*) DESC;

-- 8. Pour chaque boutique, les 2 livres les plus vendus et leurs prix.
SELECT s.stor_name AS boutique, t.title AS livre,t.price AS prix
FROM (SELECT s.stor_id, t.title_id, SUM(s.qty) AS total_qty
 FROM sales s JOIN titles t ON s.title_id = t.title_id
GROUP BY s.stor_id, t.title_id
ORDER BY s.stor_id, total_qty DESC) AS sq
    JOIN stores s ON sq.stor_id = s.stor_id
    JOIN titles t ON sq.title_id = t.title_id
GROUP BY s.stor_name, t.title HAVING COUNT(*) <= 2;

-- 9. Les auteurs des 5 livres les plus vendus.
SELECT concat( a.au_fname , a.au_lname) AS nom_auteur,
    t.title AS livre, SUM(s.qty) AS total_ventes
FROM
    titleauthor ta
    JOIN titles t ON ta.title_id = t.title_id
    JOIN sales s ON ta.title_id = s.title_id
    JOIN authors a ON ta.au_id = a.au_id
GROUP BY ta.au_id, ta.title_id
ORDER BY total_ventes DESC
LIMIT 5;

-- 10. Prix moyens des livres par maisons d’édition.
SELECT p.pub_name AS maison_edition, AVG(t.price) AS prix_moyen
FROM titles t
    JOIN publishers p ON t.pub_id = p.pub_id
GROUP BY t.pub_id;

-- 11. Les 3 auteurs ayant les plus de livres
SELECT  CONCAT(au_fname, ' ', au_lname) AS auteur, COUNT(title_id) AS nb_livres
FROM titleauthor ta
    JOIN authors a ON ta.au_id = a.au_id
GROUP BY ta.au_id
ORDER BY nb_livres DESC
LIMIT 3;




















