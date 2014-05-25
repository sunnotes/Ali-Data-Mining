#switch workspace
oldwd <- getwd();
setwd("/mnt/hgfs/WorkSpaces/Ali-Data-Mining")


data <- read.csv(file="./data/t_alibaba_data.csv",head=TRUE)
#记录数
dim(data)

data$visit_datetime <- as.Date(data$visit_datetime )
data$visit_month <- months.Date(data$visit_datetime)
data$type <- as.factor(data$type )

#summary
head(data)
summary(data)

table(data$type,data$visit_month)

#用户数 品牌数 

totUser <- table(data$user_id)
totBrand <- table(data$brand_id)

length(totUser)
length(totBrand)

barplot(totUser,main='Records per User',names.arg='',xlab='Users',ylab='Amount')
barplot(totBrand,main='Records per Brand',names.arg='',xlab='Brands',ylab='Amount')

#行为数 天数

totType <- table(data$type)
totDate <- table(data$visit_datetime)

totType
length(totDate)

barplot(totType,main='Records per Type',names.arg='',xlab='Types',ylab='Amount')
barplot(totDate,main='Records per Date',names.arg='',xlab='Dates',ylab='Amount')

#缺失值
any(is.na(data))





#install.packages("ggplot2")
#install.packages("reshape2")
library(reshape2)

data2 <- acast(data, user_id + brand_id~type, length) 
head(data2,3)
tail(data2,3)




table(data$type)
table(data$type,data$visit_month)

#日期

range(as.Date(data$visit_datetime))

####################################################
#4-6月有行为的用户/7月购买的用户

#7月购买记录数 1365    2053总记录
records1 <- subset(data,type == 1  & visit_month == "July",select=c(1,2))
head(records1)
dim(records1)
dim(unique(records1))


#4-6 活跃数  18511    34907总记录
records2 <- subset(data,visit_month == c( "April","June" ,"May"),select=c(1,2))
head(records2)
dim(records2)
dim(unique(records2))

#合集 19696         36961总记录
records3 <- rbind(records1,records2)
dim(records3)
dim(unique(records3))

#交集 180
1365+18511-19696

180/1365


temp <- data[which(data$user_id == 71250),]
table(temp$type,temp$visit_month,temp$brand_id)

length(unique(temp$brand_id))
temp <- temp[which(temp$type == 1),]
temp
