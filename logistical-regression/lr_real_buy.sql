

##############是否购买


#############

SELECT 
user_id,
brand_id,
COUNT(1) AS buy_times
FROM t_alibaba_data 
WHERE visit_datetime > "2014-07-15"
AND TYPE = 1
GROUP BY user_id,brand_id