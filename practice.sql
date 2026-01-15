--FWGHO--
--from->where->group by ->having->order by

--Revenue Analysis by Industry. Find the total revenue and average budget for each industry, but only include movies released after 2010. Convert all currencies to a common unit for fair comparison.--
SELECT SUM(
 IF(f.currency="INR", f.revenue*0.01, f.revenue)
 )AS total_revenue , AVG(IF(f.currency = "INR",f.budget * 0.01,f.budget)) as average_budget, m.industry FROM financials as f LEFT JOIN movies as m
ON m.movie_id = f.movie_id
WHERE m.release_year>2010
GROUP BY m.industry;

--  Actor Collaboration Network. Find all pairs of actors who have worked together in at least 2 movies. Show their names and the count of collaborations. --
SELECT a.name, COUNT(*) from actors as a
JOIN movie_actor as ma ON a.actor_id = ma.actor_id
JOIN movies as m ON m.movie_id = ma.movie_id
GROUP BY a.name
HAVING COUNT(*) > 2;



-- Most Profitable Movies. Calculate profit (revenue - budget) for each movie, accounting for different units (Millions, Billions, etc.). Rank the top 10 most profitable movies.--
SELECT SUM(IF(f.currency="INR", f.revenue*0.01, f.revenue)-IF(f.currency="INR", f.budget*0.01, f.budget)) as profit,m.title FROM financials as f JOIN movies as m
ON f.movie_id = m.movie_id
GROUP BY m.title
ORDER BY profit DESC
LIMIT 0,10;


-- Studio Performance. Find studios that have produced at least 3 movies and calculate their average IMDB rating. Identify which studio has the most consistent ratings (lowest standard deviation).--
SELECT COUNT(movie_id) as number_of_movies, studio, AVG(imdb_rating) as average_rating,stddev(imdb_rating) as std FROM movies
GROUP BY studio
HAVING COUNT(movie_id) >=3
ORDER BY std ASC
LIMIT 1;

--based on release year--
SELECT * FROM movies
ORDER BY release_year DESC;


--on specific year having ratings greater than 8--
SELECT * FROM movies
WHERE release_year  > 2020
HAVING imdb_rating>8;

--movies from specific studios--
SELECT * FROM movies
WHERE studio IN ("Marvel Studios" , "Hombale Films");

--specific movie--
SELECT title,release_year FROM movies
WHERE title LIKE "%THOR%"
ORDER BY release_year;


--max year and min year--
SELECT MIN(release_year) as oldest_date,MAX(release_year) as latest_date  FROM movies

--counting the number of movies released in the specific year, ordering from the latest release year--
select release_year,count(movie_id) from movies
GROUP BY release_year
ORDER BY release_year DESC
LIMIT 10;

--more than 2 movies released in a specific year--
select release_year,count(movie_id) as released_movies from movies
GROUP BY release_year
HAVING released_movies>=2
ORDER BY release_year DESC
LIMIT 10;


--Highest box office winning movie--
select m.title, IF(f.currency='INR',f.revenue*0.01,f.revenue) -IF(f.currency='INR',f.budget*0.01,f.budget) as highest_boxoffice FROM financials as f JOIN movies as m
ON m.movie_id=f.movie_id
WHERE (IF(f.currency='INR',f.revenue*0.01,f.revenue) -IF(f.currency='INR',f.budget*0.01,f.budget)) = (
SELECT MAX(IF(currency='INR',revenue*0.01,revenue) -IF(currency='INR',budget*0.01,budget)) FROM financials
);


--calculating the total profit of movies in unit million--
SELECT title,F.total_profit_in_million FROM movies as m JOIN
(SELECT movie_id,
CASE
	WHEN f.unit="billions" THEN (IF(f.currency='INR',f.revenue*0.01,f.revenue) -IF(f.currency='INR',f.budget*0.01,f.budget))*1000
    WHEN f.unit = "thousands" THEN (IF(f.currency='INR',f.revenue*0.01,f.revenue) -IF(f.currency='INR',f.budget*0.01,f.budget))/1000
    ELSE IF(f.currency='INR',f.revenue*0.01,f.revenue) -IF(f.currency='INR',f.budget*0.01,f.budget)
END AS total_profit_in_million
FROM financials AS f) AS F
ON m.movie_id = F.movie_id;

--the feature of offset is that from which position to start--


--FULL OUTER JOIN--
(SELECT m.title,m.industry,f.unit FROM movies as m LEFT JOIN financials as f
ON m.movie_id = f.movie_id)
UNION
(SELECT m.title,m.industry,f.unit FROM movies as m RIGHT JOIN financials as f
ON m.movie_id = f.movie_id);


--MOVIES BASED ON THEIR LANGUAGES--
SELECT title,name FROM movies JOIN languages
USING (language_id);

--MOVIE BASED ON SPECIFIC LANGUAGE --
SELECT title,name FROM movies JOIN languages
USING (language_id)
WHERE name = 'Telugu'
;

--counting the number of movies released per language--
SELECT count(m.title) as Total,l.name  FROM movies as m JOIN languages as l
ON m.language_id = l.language_id
GROUP BY l.name;

--using concat method--
SELECT name,price,variant_name,variant_price, CONCAT(name,' ',variant_name) as final_name, ROUND((price + variant_price),2) as total_price  FROM variants CROSS JOIN items;