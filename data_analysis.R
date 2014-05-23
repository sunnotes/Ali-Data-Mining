#switch workspace
oldwd <- getwd();
setwd("/workspaces//git//Ali_Data_Mining")


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


#日期

range(as.Date(data$visit_datetime))


#install.packages("ggplot2")
#install.packages("reshape2")
library(reshape2)

#data2 <- acast(data, user_id ~ brand_id~visit_month~type, length) 
#head(data2)


data[which(data$user_id == 19500),]