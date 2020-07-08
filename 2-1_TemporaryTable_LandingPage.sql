USE mavenfuzzyfactory;

-- Create a temperary table

CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY website_session_id; 

-- See how many times in landing pages

SELECT  website_pageviews.pageview_url AS landing_page,
	COUNT(DISTINCT first_pageview.website_session_id) AS session_hitting_this_lander
FROM first_pageview
LEFT JOIN website_pageviews
ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY website_pageviews.pageview_url;
