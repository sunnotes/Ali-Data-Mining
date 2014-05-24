#矩阵去交集


#install.packages("sqldf") 
library(sqldf)
x <- data.frame(a=c(1:3,3:1),b=LETTERS[c(1:3,3:1)],c=letters[c(3:1,1:3)])
x
sqldf("select * from x")
sqldf("select distinct * from x") # 关键是这里，使用 distinct 就能去掉重复了

