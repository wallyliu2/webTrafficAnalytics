SELECT *
FROM(
SELECT 
CASE WHEN created_at >= '2012-10-06' AND created_at <= '2013-01-05' THEN 'A.Pre_Product_2' 
	WHEN created_at >= '2013-01-06' AND created_at <= '2013-04-06' THEN 'B.Post_Product_2'
    ELSE NULL END AS time_period,
COUNT(CASE WHEN pageview_url = '/products' THEN website_session_id ELSE NULL END) AS w_next_pg,
COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' OR pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(CASE WHEN pageview_url = '/products' THEN website_session_id ELSE NULL END) AS pct_to_next_pg,
COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
COUNT(CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/
	COUNT(CASE WHEN pageview_url = '/products' THEN website_session_id ELSE NULL END) AS pct_to_mrfuzzy,
COUNT(CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_lovebear,
COUNT(CASE WHEN pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/
	COUNT(CASE WHEN pageview_url = '/products' THEN website_session_id ELSE NULL END) AS pct_to_lovebear
FROM website_pageviews
WHERE created_at >= '2012-10-06' AND created_at <= '2013-04-05'
GROUP BY 1) AS a
WHERE a.time_period IS NOT NULL;



