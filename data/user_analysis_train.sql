

##############品牌分析
 
 #cnmame <- c("brand_id","active_num","month_num","user_num","uer_active_ratio","buy_convert")
 
 #次数 
 SELECT brand_id,COUNT(1)AS active_num FROM t_alibaba_data GROUP BY brand_id LIMIT 100;
  
 #用户数
 SELECT brand_id,COUNT(DISTINCT(user_id))AS user_num FROM t_alibaba_data GROUP BY brand_id LIMIT 100;
 
 #月数
 SELECT brand_id,COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num FROM t_alibaba_data GROUP BY brand_id LIMIT 100;
 
 #用户数/次数
user_active_ratio

#购买
SELECT brand_id,
 COUNT(DISTINCT(user_id))AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =1 
 AND visit_datetime < "2014-06-15"
 GROUP BY brand_id 
 LIMIT 100;


#整体
SELECT brand_id,
 COUNT(1)AS active_num , 
 COUNT(DISTINCT(user_id))AS user_num , 
 COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num,
 COUNT(DISTINCT(user_id))/COUNT(1) AS user_active_ratio
 FROM t_alibaba_data  
 WHERE visit_datetime < "2014-06-15"
 GROUP BY brand_id
LIMIT 100


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