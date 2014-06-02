

##############用户&品牌分析

SELECT 
a.user_id,
a.brand_id,
lastday,
last_3_day_click_times,
last_3_day_buy_times,
last_3_day_collect_times,
last_3_day_cart_times,
last_7_day_click_times,
last_7_day_buy_times,
last_7_day_collect_times,
last_7_day_cart_times,
last_15_day_click_times,
last_15_day_buy_times,
last_15_day_collect_times,
last_15_day_cart_times,
last_30_day_click_times,
last_30_day_buy_times,
last_30_day_collect_times,
last_30_day_cart_times,
total_click_times,
total_buy_times,
total_collect_times,
total_cart_times
FROM 
 (SELECT user_id,brand_id,DATEDIFF("2014-06-15",MAX(visit_datetime))
AS lastday 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
GROUP BY user_id,brand_id)
AS a 
LEFT JOIN
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_3_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_3_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_3_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_3_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-06-11"
GROUP BY user_id,brand_id )
AS b 
ON a.user_id = b.user_id AND a.brand_id = b.brand_id
LEFT  JOIN
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_7_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_7_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_7_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_7_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-06-07"
GROUP BY user_id,brand_id )
AS c
ON a.user_id = c.user_id AND a.brand_id = c.brand_id
LEFT JOIN
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_15_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_15_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_15_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_15_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-05-30"
GROUP BY user_id,brand_id )
AS d 
ON a.user_id = d.user_id AND a.brand_id = d.brand_id
LEFT JOIN 
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_30_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_30_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_30_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_30_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-05-15"
GROUP BY user_id,brand_id )
AS e 
ON a.user_id = e.user_id AND a.brand_id = e.brand_id
LEFT JOIN 
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS total_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS total_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS total_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS total_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
GROUP BY user_id,brand_id )
AS f 
ON a.user_id = f.user_id AND a.brand_id = f.brand_id





#########################################分步实现 
 
#最后一次活动时间
SELECT user_id,brand_id,DATEDIFF("2014-06-15",MAX(visit_datetime))
AS lastday 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
GROUP BY user_id,brand_id 
LIMIT 100;

#近3天的活跃次数
SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_3_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_3_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_3_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_3_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-06-11"
GROUP BY user_id,brand_id 
LIMIT 100;

#近7天的活跃次数
SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_7_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_7_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_7_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_7_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-06-07"
GROUP BY user_id,brand_id 
LIMIT 100;

#近15天的活跃次数
SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_15_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_15_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_15_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_15_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-05-30"
GROUP BY user_id,brand_id 
LIMIT 100;

#近30天的活跃次数
SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_30_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_30_day_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS last_30_day_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS last_30_day_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
AND visit_datetime > "2014-05-15"
GROUP BY user_id,brand_id 
LIMIT 100;

#所有
SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS total_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS total_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS total_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS total_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-06-15"
GROUP BY user_id,brand_id 
LIMIT 100;
