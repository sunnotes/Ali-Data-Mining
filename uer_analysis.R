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


user1 <- dbGetQuery(con,'SELECT user_id,
 COUNT(1)AS active_num , 
 COUNT(DISTINCT(brand_id))AS brand_num , 
 COUNT(DISTINCT(MONTH(visit_datetime)))AS month_num,
 COUNT(DISTINCT(brand_id))/COUNT(1) AS brand_active_ratio
 FROM t_alibaba_data GROUP BY user_id   ')
dim(user1)
head(user1)

#有购买行为的用户
user2 <- dbGetQuery(con,'SELECT user_id,
 COUNT(DISTINCT(brand_id))AS buy_num 
 FROM t_alibaba_data 
 WHERE TYPE =1 
 GROUP BY user_id ')
dim(user2)
head(user2)

#合并
user3 <- merge(user1,user2,all=TRUE)
dim(user3)
head(user3)

#购买率
user3$buy_convert <- user3$buy_num/user3$active_num
dim(user3)
head(user3)
user3<- user3[-6]
user3[is.na(user3)]=0

user <- user3


dim(user)
head(user)

save(user,file ='data/user.RData')
