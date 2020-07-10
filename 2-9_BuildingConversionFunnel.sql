SELECT DISTINCT pageview_url FROM website_pageviews WHERE created_at BETWEEN '2012-08-05' AND '2012-09-05' ORDER BY pageview_url;


-- STEP 1: Create a table only including '/lander-1','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order'
CREATE TEMPORARY TABLE funnel_table_4
SELECT website_sessions.website_session_id, 
website_pageviews.pageview_url, 
website_pageviews.created_at AS pageview_created_at,
CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM website_sessions
LEFT JOIN website_pageviews
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2012-08-05' AND '2012-09-05'
AND website_pageviews.pageview_url IN ('/lander-1','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
AND website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign = 'nonbrand'
ORDER BY website_sessions.website_session_id, website_pageviews.created_at; 

SELECT * FROM funnel_table_4;

-- STEP 2: Create a JOIN table only went through /lander-1
CREATE TEMPORARY TABLE funnel_via_lander1_only_2
SELECT DISTINCT website_pageviews.website_session_id, 
funnel_table_4.pageview_url,
funnel_table_4.pageview_created_at,
funnel_table_4.product_page,
funnel_table_4.mrfuzzy_page,
funnel_table_4.cart_page,
funnel_table_4.shipping_page,
funnel_table_4.billing_page,
funnel_table_4.thank_you_page
FROM website_pageviews 
LEFT JOIN funnel_table_4
ON funnel_table_4.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.pageview_url = '/lander-1' AND website_pageviews.created_at BETWEEN '2012-08-05' AND '2012-09-05'
ORDER BY website_pageviews.website_session_id, funnel_table_4.pageview_created_at;

SELECT * FROM funnel_via_lander1_only_2;

-- STEP 3: Create a flag table
CREATE TEMPORARY TABLE session_flag_3
SELECT website_session_id,
MAX(product_page) AS to_products,
MAX(mrfuzzy_page) AS to_mrfuzzy,
MAX(cart_page) AS to_cart,
MAX(shipping_page) AS to_shipping,
MAX(billing_page) AS to_billing,
MAX(thank_you_page) AS to_thank_you_page
FROM funnel_via_lander1_only_2
GROUP BY website_session_id;

SELECT * FROM session_flag_3;

-- STEP 4: 
SELECT COUNT(DISTINCT website_session_id) AS total_sessions,
COUNT(DISTINCT CASE WHEN to_products = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_product,
COUNT(DISTINCT CASE WHEN to_mrfuzzy = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_mrfuzzy,
COUNT(DISTINCT CASE WHEN to_cart = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_cart,
COUNT(DISTINCT CASE WHEN to_shipping = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_shipping,
COUNT(DISTINCT CASE WHEN to_billing = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_billing,
COUNT(DISTINCT CASE WHEN to_thank_you_page = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_thank_you_page
FROM session_flag_2;

SELECT COUNT(DISTINCT website_session_id) AS total_sessions,
COUNT(DISTINCT CASE WHEN to_products = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_product,
COUNT(DISTINCT CASE WHEN to_mrfuzzy = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_mrfuzzy,
COUNT(DISTINCT CASE WHEN to_cart = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_cart,
COUNT(DISTINCT CASE WHEN to_shipping = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_shipping,
COUNT(DISTINCT CASE WHEN to_billing = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_billing,
COUNT(DISTINCT CASE WHEN to_thank_you_page = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_thank_you_page
FROM session_flag_3;