USE mavenfuzzyfactory;

SELECT w.utm_content AS LandPage, 
COUNT(DISTINCT w.website_session_id) AS Visitors,
COUNT(DISTINCT o.order_id) AS Orders,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS Conversion_Rate
FROM website_sessions w
LEFT JOIN orders o
ON w.website_session_id = o.website_session_id
WHERE w.website_session_id BETWEEN 1000 AND 2000 
GROUP BY 1
ORDER BY 2 DESC;