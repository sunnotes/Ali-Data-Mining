head(user_brand_score)

user_brand_score_min <- user_brand_score[which(user_brand_score$brand_id<10000),]
dim(user_brand_score_min)


save(user_brand_score_min,file ='data/user_brand_score_min.RData')

write.csv(user_brand_score_min,file="data/user_brand_score_min.csv")