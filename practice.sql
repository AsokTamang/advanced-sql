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



