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


brand1 <- dbGetQuery(con,'SELECT brand_id,
 COUNT(1)AS active_num , 
 COUNT(DISTINCT(user_id))AS user_num , 
 COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num,
 COUNT(DISTINCT(user_id))/COUNT(1) AS user_active_ratio
 FROM t_alibaba_data GROUP BY brand_id   ')
dim(brand1)
head(brand1)

#有购买行为的品牌
brand2 <- dbGetQuery(con,'SELECT brand_id,
 COUNT(DISTINCT(user_id))AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =1 
 GROUP BY brand_id  ')
dim(brand2)
head(brand2)

#合并
brand3 <- merge(brand1,brand2,all=TRUE)
dim(brand3)
head(brand3)

#购买率
brand3$buy_convert <- brand3$buy_num/user3$active_num
dim(brand3)
head(brand3)
brand3<- brand3[-6]
brand3[is.na(brand3)]=0

brand <- brand3


dim(brand)
head(brand)

save(brand,file ='data/brand.RData')

write.csv(brand,file="data/brand.csv")