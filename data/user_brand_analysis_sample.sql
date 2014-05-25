

##############用户 品牌分析
 
 #cnmame <- c("brand_id","active_num","month_num","user_num","uer_active_ratio","buy_convert")
 
 #次数 
 SELECT user_id,brand_id,
 COUNT(1)AS active_num 
 FROM t_alibaba_data 
 WHERE visit_datetime < "2014-06-15"
 GROUP BY user_id, brand_id 
 LIMIT 100;
  
 #用户数
 SELECT brand_id,
 COUNT(DISTINCT(user_id))AS user_num 
 FROM t_alibaba_data 
 WHERE visit_datetime < "2014-06-15"
 GROUP BY brand_id LIMIT 100;
 
 #月数
 SELECT user_id,
 brand_id,
 COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num 
 FROM t_alibaba_data
 WHERE visit_datetime < "2014-06-15" 
 GROUP BY user_id,brand_id 
 LIMIT 100;
 
 #活跃次数
SELECT user_id,brand_id,
 COUNT(1) AS active_num 
 FROM t_alibaba_data 
 WHERE visit_datetime < "2014-06-15"
 GROUP BY user_id,brand_id 
 LIMIT 100;

#购买次数
SELECT user_id,brand_id,
 COUNT(1)AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =1 
 AND visit_datetime < "2014-06-15"
 GROUP BY user_id,brand_id 
 LIMIT 100;
 
 #点击数
SELECT user_id,brand_id,
 COUNT(1)AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =0
  AND visit_datetime < "2014-06-15"
 GROUP BY user_id,brand_id 
 LIMIT 100;
 
 #收藏数
SELECT user_id,brand_id,
 COUNT(1)AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =2
  AND visit_datetime < "2014-06-15"
 GROUP BY user_id,brand_id 
 LIMIT 100;
 
 #购物车数
SELECT user_id,brand_id,
 COUNT(1)AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =3 
 AND visit_datetime < "2014-06-15"
 GROUP BY user_id,brand_id 
 LIMIT 100;

