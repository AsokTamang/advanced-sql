SELECT SUM(
 IF(f.currency="INR", f.revenue*0.01, f.revenue)
 )AS total_revenue , AVG(IF(f.currency = "INR",f.budget * 0.01,f.budget)) as average_budget, m.industry FROM financials as f LEFT JOIN movies as m
ON m.movie_id = f.movie_id
WHERE m.release_year>2010
GROUP BY m.industry;
