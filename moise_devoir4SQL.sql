-- 1.Obtenir la liste des auteurs dont l’éditeur « Harmattan » n’a publié aucun livre

SELECT concat(au_fname, au_lname) as auteur
FROM authors
WHERE au_id NOT IN
(
SELECT pub_id
FROM publishers
WHERE pub_name='Harmattan'
);
-- 2. Obtenir la liste des auteurs dont l’éditeur «Eyrolles » a publié tous les livres
SELECT concat(au_fname, au_lname) as auteur
FROM authors
WHERE au_id IN
(
SELECT pub_id
FROM publishers
WHERE pub_name='Eyrolles'
);
-- 3. Obtenir la liste des noms d’auteurs ayant touché une avance supérieure à avances versées par l'éditeur "Harmattan".

select distinct a.au_fname, a.au_lname
from authors a
join titleauthor t on a.au_id = t.au_id
join titles ti on t.title_id = ti.title_id
where ti.advance > ( 
select max(ti.advance)
from titles ti
join publishers p on ti.pub_id= p.pub_id
where p.pub_name = "harmattan");