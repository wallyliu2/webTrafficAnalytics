-- Demo on buiness coversion funnels

-- Business context
	-- We want to build a mini conversion funnel from /lander-2 to /cart
    -- We want to know how many people reach each step and also dropoff rates
    -- For simplicity of the demo, we're looking at /lander-2 traffic only
    -- For simplicity of the demo, we're looking at cusotmers who like Mr Fuzzy only
    
-- STEP 1: Select all pageviews for relevant sessions
-- STEP 2: Identify each relavant pageview as the specific funnel step
-- STEP 3: Create the session-level conversion funnel view
-- STEP 4: Aggreate the data to access funnel performance

SELECT website_session_id, pageview_url FROM website_pageviews WHERE pageview_url ='/the-original-mr-fuzzy' AND website_pageviews.created_at BETWEEN '2014-01-01' AND '2014-02-01';

SELECT DISTINCT website_session_id FROM website_pageviews WHERE pageview_url = '/lander-2';

CREATE TEMPORARY TABLE funnel_table_1
SELECT website_sessions.website_session_id, 
website_pageviews.pageview_url, 
website_pageviews.created_at AS pageview_created_at,
CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product_page,
CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
LEFT JOIN website_pageviews
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2014-01-01' AND '2014-02-01'
AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY website_sessions.website_session_id, website_pageviews.created_at; 

SELECT * FROM funnel_table_1;

CREATE TEMPORARY TABLE funnel_via_lander2_only_1
SELECT DISTINCT website_pageviews.website_session_id, 
funnel_table_1.pageview_url,
funnel_table_1.pageview_created_at,
funnel_table_1.product_page,
funnel_table_1.mrfuzzy_page,
funnel_table_1.cart_page
FROM website_pageviews 
LEFT JOIN funnel_table_1
ON funnel_table_1.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.pageview_url = '/lander-2' AND website_pageviews.created_at BETWEEN '2014-01-01' AND '2014-02-01'
ORDER BY website_pageviews.website_session_id, funnel_table_1.pageview_created_at;

SELECT * FROM funnel_via_lander2_only_1;

CREATE TEMPORARY TABLE session_flag_1
SELECT website_session_id,
MAX(product_page) AS to_products,
MAX(mrfuzzy_page) AS to_mrfuzzy,
MAX(cart_page) AS to_cart
FROM funnel_via_lander2_only_1
GROUP BY website_session_id;

SELECT * FROM session_flag_1;

SELECT COUNT(DISTINCT website_session_id) AS total_sessions,
COUNT(DISTINCT CASE WHEN to_products = 1 THEN website_session_id ELSE NULL END) AS product_sessions,
COUNT(DISTINCT CASE WHEN to_mrfuzzy = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_sessions,
COUNT(DISTINCT CASE WHEN to_cart = 1 THEN website_session_id ELSE NULL END) AS cart_sessions
FROM session_flag_1;

SELECT COUNT(DISTINCT website_session_id) AS total_sessions,
COUNT(DISTINCT CASE WHEN to_products = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_product,
COUNT(DISTINCT CASE WHEN to_mrfuzzy = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_mrfuzzy,
COUNT(DISTINCT CASE WHEN to_cart = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS ctr_to_cart
FROM session_flag_1;
