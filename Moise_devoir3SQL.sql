-- 1. La liste des paires (auteur, éditeur) demeurant dans la même ville
SELECT au_fname as auteur  , pub_name as editeur
FROM   authors , publishers
WHERE authors.city = publishers.city;

-- 2. La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant
-- aussi les auteurs qui ne répondent pas à ce critère.
SELECT au_fname as auteur  , pub_name as editeur
FROM   authors  left join publishers
on  authors.city = publishers.city;

-- 3. La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant
-- aussi les editeurs qui ne répondent pas à ce critère.
SELECT au_fname as auteur  , pub_name as editeur
FROM   authors  right join publishers
on  authors.city = publishers.city;

-- 4. La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant les
-- auteurs et les éditeurs qui ne répondent pas à ce critere.
SELECT au_fname as auteur  , pub_name as editeur
FROM   authors  left join publishers
on  authors.city = publishers.city
UNION 
SELECT au_fname as auteur  , pub_name as editeur
FROM   authors  right join publishers
on  authors.city = publishers.city;

-- 5.Effectif(nombre) d'employes par niveau d'experience
select COUNT(emp_id) as nombre ,job_lvl as niveau_experience 
from employees
group by job_lvl;

-- 6.Liste des employes par maison d'edition
-- ou SELECT CONCAT(fname,lname) as employes, pub_name from employees,publishers where employ.pub_id=publishers.pub_id
SELECT   e.fname, p.pub_id
FROM employees e , publishers p 
where e.pub_id = p.pub_id;

-- 7. Salaires horaires moyens des employes par maison d'edition
-- select pub_name, avg(salary).....
SELECT AVG(salary),  e.fname, p.pub_id
FROM employees e , publishers p 
where e.pub_id = p.pub_id group by e.pub_id ;

-- 8. Effectif(nombre) d'employées de niveau SEINIOR par maison d'edition
 select pub_name, count(emp_id) as effectif 
 from publishers join employees on publishers.pub_id=employees.pub_id 
 where employees.job_lvl="seinior" group by (pub_name);

