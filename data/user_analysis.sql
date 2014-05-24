

##############用户分析
 
 #cnmame <- c("user_id","active_num","month_num","brand_num","brand_active_ratio","buy_convert")
 
 #次数 
 SELECT user_id,COUNT(1)AS active_num FROM t_alibaba_data GROUP BY user_id LIMIT 100;
  
 #品牌数
 SELECT user_id,COUNT(DISTINCT(brand_id))AS brand_num FROM t_alibaba_data GROUP BY user_id LIMIT 100;
 
 #月数
 SELECT user_id,COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num FROM t_alibaba_data GROUP BY user_id LIMIT 100;
 
 #品牌数/次数
brand_active_ratio

#购买转化率
SELECT user_id,
 COUNT(DISTINCT(brand_id))AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =1 
 GROUP BY user_id 
 LIMIT 100;


#整体
SELECT user_id,
 COUNT(1)AS active_num , 
 COUNT(DISTINCT(brand_id))AS brand_num , 
 COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num,
 COUNT(DISTINCT(brand_id))/COUNT(1) AS brand_active_ratio
 FROM t_alibaba_data GROUP BY user_id 
LIMIT 100