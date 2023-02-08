-- WHERE : filtra le righe prima dell'agglomerazione dei dati per filtrare le righe sulla base di proprietà individuali.
-- HAVING : filtra le righe che hanno determinate proprietà aggregate, come la somma, il conteggio, la media, o comunque dati agglomerati.
	-- ma non è in grado di filtrare i singoli record come fa la clausola WHERE.

-- 1- Selezionare tutte le software house americane (3)
select * from software_houses where country like "United States";

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
select * from players where city like "Rogahnland";

-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
select * from players where name  like "%";

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
select * from reviews where player_id = 800;

-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
select count(*) from tournaments where `year` = 2015;

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
select * from awards where description like '%facere%';

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
select distinct videogame_id from category_videogame v where category_id = 2 or category_id = 6

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
select * from reviews r where rating >=2 and rating <=4;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
select * from videogames v where year(release_date) = 2020;

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 4 stelle, mostrandoli una sola volta (443)
select distinct videogame_id from reviews r where rating >4 ;

-- *********** BONUS ***********

-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3.16 circa)
SELECT COUNT(*) AS "review_number", AVG(rating) AS "avg_rating"
FROM reviews r 
WHERE videogame_id = 412;

-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
select count(id)
from videogames v 
where software_house_id = 1
and year(release_date) = 2018

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- GROUP BY

-- 1- Contare quante software house ci sono per ogni paese (3)
select count(*) as "count_software_houses", country  from software_houses sh  group by country ;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
select videogame_id , count(*) from reviews r  group by videogame_id ;

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
select pegi_label_id, count(videogame_id) as "count_videogame"
from pegi_label_videogame plv  
group by pegi_label_id;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
select year(release_date) as "Year", count(id) as "Count" from videogames v group by year(release_date);

select cast(year(release_date) as char(4)) as "year", count(id) as "count"
from videogames v
group by year;   -- CORRETTO
-- group by `year`; CORRETTO
-- group by "year"; ERRORE
-- group by 'year'; ERRORE

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
select count(videogame_id), device_id  from device_videogame dv group by device_id

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
select videogame_id , avg(rating) as "AVG"
from reviews r 
group by videogame_id 
order by "AVG" desc;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOIN

-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
select distinct p.*
from players p
inner join reviews r
on p.id = r.player_id;

select distinct p.*
from reviews r
inner join players p 
on p.id = r.player_id;

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

select distinct v.*
from tournaments t 
inner join tournament_videogame tv
on tv.tournament_id = t.id
inner join videogames v
on v.id = tv.videogame_id
where t.year = 2016;

select distinct v.name 
from videogames v 
inner join tournament_videogame tv 
on tv.videogame_id = v.id 
inner join tournaments t 
on tv.tournament_id = t.id
where t.year = 2016


-- 3- Mostrare le categorie di ogni videogioco (1718)

select v.id, v.name, c.name
from videogames v
inner join category_videogame cv
on v.id = cv.videogame_id
inner join categories c
on cv.category_id = c.id;

-- 3.1- Mostrare per ogni gioco tutte le categorie (500)

select v.id, v.name, group_concat(c.name separator ', ') as categories
from videogames v
inner join category_videogame cv
on v.id = cv.videogame_id
inner join categories c
on cv.category_id = c.id
group by v.id;

-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
select distinct sh.*
from software_houses sh 
inner join videogames v
on sh.id = v.software_house_id
where v.release_date >= '2020-01-01';

select sh.*
from videogames v
inner join software_houses sh 
on sh.id = v.software_house_id
where year(v.release_date) >= 2020
group by sh.id;

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)

select sh.id, sh.name, a.name as "Award"
from software_houses sh
inner join videogames v
on sh.id = v.software_house_id
inner join award_videogame av
on v.id = av.videogame_id
inner join awards a 
on av.award_id = a.id;

-- 5.1- Selezionare i videogames che hanno avuto dei premi ed elencarli (52) -- infatti solo 3 videogiochi hanno 2 premi (55-3)

select v.id, v.name, group_concat(a.name) as "Awards"
from awards a 
inner join award_videogame av
on av.award_id = a.id
inner join videogames v
on v.id = av.videogame_id
group by v.id;


-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

select distinct v.name, c.name, p.name
from categories c
join category_videogame cv
on c.id = cv.category_id
join videogames v
on cv.videogame_id = v.id
join reviews r
on v.id = r.videogame_id
join pegi_label_videogame pv
on pv.videogame_id = v.id
join pegi_labels p 
on pv.pegi_label_id = p.id
where r.rating = 4 or r.rating = 5;

-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
select distinct v.id, v.name
from players p
inner join player_tournament pt
on p.id = pt.player_id
inner join tournaments t
on pt.tournament_id = t.id
inner join tournament_videogame tv
on t.id = tv.tournament_id
inner join videogames v
on tv.videogame_id = v.id
where p.name like 'S%';

-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
select t.city
from tournaments t
inner join tournament_videogame tv
on t.id = tv.tournament_id
inner join videogames v
on tv.videogame_id = v.id
inner join award_videogame av
on v.id = av.videogame_id
inner join awards a
on av.award_id = a.id
where a.name like "gioco dell'anno" and av.year = 2018;

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
select p.*
from players p
inner join player_tournament pt
on p.id = pt.player_id
inner join tournaments t
on pt.tournament_id = t.id
inner join tournament_videogame tv
on t.id = tv.tournament_id
inner join videogames v
on tv.videogame_id = v.id
inner join award_videogame av
on v.id = av.videogame_id
inner join awards a
on av.award_id = a.id
where a.name like "Gioco pi%" and av.year = 2018 and t.year = 2019;

-- *********** BONUS ***********

-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
select sh.id as "sh_id", sh.name as "sh_name", v.id as "v_id", v.name as "v_name"
from software_houses sh
inner join  videogames v 
on v.software_house_id = sh.id
order by v.release_date
limit 1;

-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : potrebbe uscire 449 o 398, sono entrambi a 20)
select v.id as "v_id", v.name as "v_name", v.release_date, count(r.id) as "total_reviews"
from videogames v
inner join reviews r 
on v.id = r.videogame_id
group by v.id
order by total_reviews desc
limit 1;

-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : potrebbe uscire 3 o 1, sono entrambi a 3)
select sh.id as software_house_id, sh.name as software_house_name, COUNT(a.id) as total_awards
from software_houses sh 
inner join videogames v 
on sh.id = v.software_house_id 
inner join award_videogame av 
on v.id = av.videogame_id 
inner join awards a 
on av.award_id = a.id 
where av.year between 2015 and 2016
group by sh.id 
order by total_awards desc 
limit 1;

-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)
SELECT DISTINCT c.id AS category_id, c.name AS category_name 
FROM videogames v
INNER JOIN reviews r ON v.id = r.videogame_id
INNER JOIN category_videogame cv ON v.id = cv.videogame_id
INNER JOIN categories c ON cv.category_id = c.id
GROUP BY v.id, c.id, c.name
HAVING AVG(r.rating) < 2
-- Dennis's solution