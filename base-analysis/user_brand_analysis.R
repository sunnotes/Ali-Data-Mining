#switch workspace
oldwd <- getwd();
setwd("/mnt/hgfs/WorkSpaces/Ali-Data-Mining")

###########windows
#install.packages("RODBC")
#library(RODBC)
#conn <- odbcConnect('alidata')

########Linux
#install.packages("RMySQL")
#library(RMySQL)
con <- dbConnect(MySQL(),
                 user='root', 
                 password='root', 
                 dbname='ali', 
                 host="127.0.0.1") 
#列出所有数据库中的表
dbListTables(con) 

#活跃数
active <- dbGetQuery(con,'SELECT user_id,brand_id,
 COUNT(1)AS active_num 
 FROM t_alibaba_data 
 GROUP BY user_id, brand_id  ')
dim(active)
head(active)

#月数
month <- dbGetQuery(con,' SELECT user_id,
 brand_id,
 COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num 
                    FROM t_alibaba_data 
                    GROUP BY user_id,brand_id  ')
dim(month)
head(month)


#点击数
click <- dbGetQuery(con,'SELECT user_id,brand_id,
                    COUNT(1)AS click_num 
                    FROM t_alibaba_data 
                    WHERE TYPE =0
                    GROUP BY user_id,brand_id  ')
dim(click)
head(click)

#购买
buy <- dbGetQuery(con,'SELECT user_id,brand_id,
                    COUNT(1)AS buy_num 
                    FROM t_alibaba_data 
                    WHERE TYPE =1
                    GROUP BY user_id,brand_id  ')
dim(buy)
head(buy)


#收藏
collect <- dbGetQuery(con,'SELECT user_id,brand_id,
                    COUNT(1)AS collect_num 
                    FROM t_alibaba_data 
                    WHERE TYPE =2
                    GROUP BY user_id,brand_id  ')
dim(click)
head(click)

#购物车
cart <- dbGetQuery(con,'SELECT user_id,brand_id,
                    COUNT(1)AS cart_num 
                    FROM t_alibaba_data 
                    WHERE TYPE =3
                    GROUP BY user_id,brand_id  ')
dim(cart)
head(cart)

#合并

user_brand <- merge(active,merge(month,merge(click,merge(collect,merge(cart,buy,all=TRUE),all=TRUE),all=TRUE),all=TRUE),all=TRUE)

dim(user_brand)
head(user_brand)

user_brand$click_buy_ratio <-  user_brand$buy_num/user_brand$click_num
user_brand$collect_buy_ratio <-  user_brand$buy_num/user_brand$collect_num
user_brand$cart_buy_ratio <-  user_brand$buy_num/user_brand$cart_num


user_brand[is.na(user_brand)] = 0

#user_brand <- user_brand[-c(5,6,7)]

dim(user_brand)
head(user_brand)


save(user_brand,file ='data/user_brand.RData')

write.csv(user_brand,file="data/user_brand.csv")