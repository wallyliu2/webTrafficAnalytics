CREATE TEMPORARY TABLE product_website_session_1
SELECT website_session_id,
pageview_url
FROM website_pageviews
WHERE 
pageview_url IN ('/the-forever-love-bear','/the-original-mr-fuzzy') AND 
(created_at BETWEEN '2013-01-06' AND '2013-04-10');

SELECT * FROM product_website_session_1;

SELECT DISTINCT pageview_url FROM website_pageviews WHERE (created_at BETWEEN '2013-01-06' AND '2013-04-10') ORDER BY pageview_url ASC;

SELECT
CASE WHEN product_website_session_1.pageview_url = '/the-forever-love-bear' THEN 'lovebear'
	WHEN product_website_session_1.pageview_url = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
    ELSE NULL END AS product_seen,
COUNT(DISTINCT product_website_session_1.website_session_id) AS sessions,
COUNT(CASE WHEN website_pageviews.pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS to_cart,
COUNT(CASE WHEN website_pageviews.pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END) AS to_shipping,
COUNT(CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN website_pageviews.website_session_id ELSE NULL END) AS to_billing,
COUNT(CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order'  THEN website_pageviews.website_session_id ELSE NULL END) AS to_thankyou,
COUNT(CASE WHEN website_pageviews.pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END)/
	COUNT(DISTINCT product_website_session_1.website_session_id) AS product_page_click_rt,
COUNT(CASE WHEN website_pageviews.pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END)/
	COUNT(CASE WHEN website_pageviews.pageview_url = '/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS cart_click_rt,
COUNT(CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN website_pageviews.website_session_id ELSE NULL END)/
	COUNT(CASE WHEN website_pageviews.pageview_url = '/shipping' THEN website_pageviews.website_session_id ELSE NULL END) AS shipping_click_rt,
COUNT(CASE WHEN website_pageviews.pageview_url = '/thank-you-for-your-order'  THEN website_pageviews.website_session_id ELSE NULL END)/
	COUNT(CASE WHEN website_pageviews.pageview_url = '/billing-2' THEN website_pageviews.website_session_id ELSE NULL END) AS billing_rt
FROM product_website_session_1
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = product_website_session_1.website_session_id
GROUP BY 1;
