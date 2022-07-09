-- 1- Selezionare tutte le software house americane (3)
SELECT *
FROM software_houses
WHERE country = 'United States';

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT *
FROM players
WHERE city = 'Rogahnland';

-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT *
FROM players
WHERE name like '%a';

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT *
FROM reviews
WHERE player_id = 800;

-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT count(*)
FROM tournaments
WHERE year = 2015;

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT *
FROM awards
WHERE description like '%facere%';

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT videogame_id
FROM category_videogame
WHERE category_id = 2 OR category_id = 6;

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT *
FROM reviews
WHERE rating >= 2 and rating <= 4;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT *
FROM videogames
WHERE DATEPART(year,release_date) = 2020;

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id
FROM reviews
WHERE rating = 5;

-- *********** BONUS ***********
-- 
-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)
SELECT count(id), avg(rating)
FROM reviews
WHERE videogame_id = 412;

-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT count(id)
FROM videogames
WHERE software_house_id = 1 and DATEPART(year, release_date) = 2018;



-- ------ Query con group by
-- 
-- ```
-- 1- Contare quante software house ci sono per ogni paese (3)
SELECT country, count(*)
FROM software_houses
GROUP BY country;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, count(*)
FROM reviews
GROUP BY videogame_id;

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT pegi_label_id, count(videogame_id)
FROM pegi_label_videogame
GROUP BY pegi_label_id;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT count(*)
FROM videogames
GROUP BY DATEPART(year,release_date);

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT device_id, count(videogame_id)
FROM device_videogame
GROUP BY device_id;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, avg(rating) AS avg_rating
FROM reviews
GROUP BY videogame_id
ORDER BY avg_rating DESC;



-- ------ Query con join
-- 
-- ```
-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT p.id, p.name, p.lastname, p.nickname, p.city
FROM reviews r
INNER JOIN players p ON r.player_id = p.id;

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT v.id, v.name, v.release_date
FROM videogames v
INNER JOIN tournament_videogame tv ON v.id = tv.videogame_id
INNER JOIN tournaments t ON tv.tournament_id = t.id
WHERE t.year = 2016;

-- 3- Mostrare le categorie di ogni videogioco
-- SELECT v.id AS videogame_id, v.name AS videogame_name, v.release_date, c.id AS category_id, c.name AS category_name (1718)
SELECT v.id AS videogame_id, v.name AS videogame_name, v.release_date, c.id AS category_id, c.name AS category_name
FROM videogames v
INNER JOIN category_videogame cv ON v.id = cv.videogame_id
INNER JOIN categories c ON cv.category_id = c.id
ORDER BY videogame_id;

-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT sh.id, sh.name, sh.tax_id, sh.city, sh.country
FROM software_houses sh
INNER JOIN videogames v ON sh.id = v.software_house_id
WHERE YEAR(v.release_date) > 2020;

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT a.id, a.name, a.description
FROM awards a
INNER JOIN award_videogame av ON a.id = av.award_id;

-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT v.id as id_videogame, v.name as videogame_name, c.name as category_name, pl.name as pegi_label_name
FROM videogames v
INNER JOIN reviews r ON v.id = r.videogame_id
INNER JOIN pegi_label_videogame plv ON v.id = plv.videogame_id
INNER JOIN pegi_labels pl ON plv.pegi_label_id = pl.id
INNER JOIN category_videogame cv ON v.id = cv.videogame_id
INNER JOIN categories c ON cv.category_id = c.id
WHERE r.rating >= 4;

-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT v.name as videogames_name, v.id as videogame_id
FROM videogames v
INNER JOIN tournament_videogame tv ON v.id = tv.videogame_id
INNER JOIN tournaments t ON tv.tournament_id = t.id
INNER JOIN player_tournament pt ON t.id = pt.tournament_id
INNER JOIN players p ON pt.player_id = p.id
WHERE p.name like 'S%';

-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT t.city as city
FROM videogames v
INNER JOIN tournament_videogame tv ON v.id = tv.videogame_id
INNER JOIN tournaments t ON tv.tournament_id = t.id
INNER JOIN award_videogame av ON v.id = av.videogame_id
INNER JOIN awards a ON av.award_id = a.id
WHERE av.year = 2018 and a.name = 'Gioco dell''anno';

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT p.id as player_id, p.name as player_name
FROM videogames v
INNER JOIN tournament_videogame tv ON v.id = tv.videogame_id
INNER JOIN tournaments t ON tv.tournament_id = t.id
INNER JOIN award_videogame av ON v.id = av.videogame_id
INNER JOIN awards a ON av.award_id = a.id
INNER JOIN player_tournament pt ON t.id = pt.tournament_id
INNER JOIN players p ON pt.player_id = p.id
WHERE a.name = 'Gioco più atteso' and av.year = 2018 and t.year = 2019;

-- *********** BONUS ***********
-- 
-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)

-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)

-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)

-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)
