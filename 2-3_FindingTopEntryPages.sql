USE mavenfuzzyfactory;

-- See how many times by landing pages

SELECT * FROM website_pageviews LIMIT 1;

-- My solution
SELECT pageview_url AS landing_page, COUNT(DISTINCT website_session_id) AS visitors
FROM (SELECT *, RANK() OVER(PARTITION BY website_session_id ORDER BY website_pageview_id) rnk
FROM website_pageviews) a
WHERE a.created_at < '2012-06-12' AND rnk = 1
GROUP BY pageview_url;

-- Course solution
-- Step 1: Find the first pageview for each web session
-- Step 2: Find the url the customer saw on the first page

CREATE TEMPORARY TABLE first_viewpage__
SELECT website_session_id, MIN(website_pageview_id) AS first_pv
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT wpv.pageview_url AS landing_page, COUNT(DISTINCT fvp.website_session_id)
FROM first_viewpage__ as fvp
LEFT JOIN website_pageviews as wpv
ON fvp.first_pv = wpv.website_pageview_id
GROUP BY wpv.pageview_url;



