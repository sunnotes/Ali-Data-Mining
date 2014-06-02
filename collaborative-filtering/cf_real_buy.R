#switch workspace
oldwd <- getwd();
setwd("/mnt/hgfs/WorkSpaces/Ali-Data-Mining")

###########windows
#install.packages("RODBC")
#library(RODBC)
#conn <- odbcConnect('alidata')

########Linux
#install.packages("DBI")
#install.packages("RMySQL")
library(RMySQL)
con <- dbConnect(MySQL(),
                 user='root', 
                 password='root', 
                 dbname='ali', 
                 host="127.0.0.1") 
#列出所有数据库中的表
dbListTables(con) 

#查询数据库 train
real_buy <- dbGetQuery(con,'SELECT 
user_id,
GROUP_CONCAT(DISTINCT(brand_id))
                       FROM t_alibaba_data 
                       WHERE visit_datetime > "2014-07-15"
                       AND TYPE = 1
                       GROUP BY user_id
')
dim(real_buy)
head(real_buy)

real_buy$real_buy = 1
real_buy<- real_buy[,-3]
head(real_buy)

write.csv(real_buy,file ='collaborative-filtering/python/data/real_buy.csv',row.names = FALSE)


