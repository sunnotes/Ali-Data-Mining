---
layout: post
title: "使用R完成逻辑回归分类"
description: ""
category: statistics
tags: [ 逻辑回归 , R,分类 ]
---
{% include JB/setup %}

本文是R in action的学习笔记

## 准备数据

数据源自婚外情数据


```r
#install.packages("AER")
library(AER)
```

```
## Loading required package: car
## Loading required package: lmtest
## Loading required package: zoo
## 
## Attaching package: 'zoo'
## 
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
## 
## Loading required package: sandwich
## Loading required package: survival
## Loading required package: splines
```

```r
data(Affairs,package="AER")
summary(Affairs)
```

```
##     affairs         gender         age        yearsmarried    children 
##  Min.   : 0.00   female:315   Min.   :17.5   Min.   : 0.125   no :171  
##  1st Qu.: 0.00   male  :286   1st Qu.:27.0   1st Qu.: 4.000   yes:430  
##  Median : 0.00                Median :32.0   Median : 7.000            
##  Mean   : 1.46                Mean   :32.5   Mean   : 8.178            
##  3rd Qu.: 0.00                3rd Qu.:37.0   3rd Qu.:15.000            
##  Max.   :12.00                Max.   :57.0   Max.   :15.000            
##  religiousness    education      occupation      rating    
##  Min.   :1.00   Min.   : 9.0   Min.   :1.0   Min.   :1.00  
##  1st Qu.:2.00   1st Qu.:14.0   1st Qu.:3.0   1st Qu.:3.00  
##  Median :3.00   Median :16.0   Median :5.0   Median :4.00  
##  Mean   :3.12   Mean   :16.2   Mean   :4.2   Mean   :3.93  
##  3rd Qu.:4.00   3rd Qu.:18.0   3rd Qu.:6.0   3rd Qu.:5.00  
##  Max.   :5.00   Max.   :20.0   Max.   :7.0   Max.   :5.00
```

```r
table(Affairs$affairs)
```

```
## 
##   0   1   2   3   7  12 
## 451  34  17  19  42  38
```

## 抽取因变量 0-1化


```r
Affairs$ynaffair[Affairs$affairs > 0 ] <- 1

Affairs$ynaffair[Affairs$affairs == 0 ] <- 0

table(Affairs$ynaffair)
```

```
## 
##   0   1 
## 451 150
```

```r
Affairs$ynaffair <- factor(Affairs$ynaffair,levels=c(0,1),labels=c("No","Yes"))

table(Affairs$ynaffair)
```

```
## 
##  No Yes 
## 451 150
```
## 建模拟合

```r
fit.full <- glm(ynaffair ~ gender + age + yearsmarried + children + religiousness 
                + education + occupation + rating,
                data =  Affairs,
                family = binomial())

summary(fit.full)
```

```
## 
## Call:
## glm(formula = ynaffair ~ gender + age + yearsmarried + children + 
##     religiousness + education + occupation + rating, family = binomial(), 
##     data = Affairs)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -1.571  -0.750  -0.569  -0.254   2.519  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)     1.3773     0.8878    1.55   0.1208    
## gendermale      0.2803     0.2391    1.17   0.2411    
## age            -0.0443     0.0182   -2.43   0.0153 *  
## yearsmarried    0.0948     0.0322    2.94   0.0033 ** 
## childrenyes     0.3977     0.2915    1.36   0.1725    
## religiousness  -0.3247     0.0898   -3.62   0.0003 ***
## education       0.0211     0.0505    0.42   0.6769    
## occupation      0.0309     0.0718    0.43   0.6666    
## rating         -0.4685     0.0909   -5.15  2.6e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 675.38  on 600  degrees of freedom
## Residual deviance: 609.51  on 592  degrees of freedom
## AIC: 627.5
## 
## Number of Fisher Scoring iterations: 4
```

通过分析可知，性别等属性贡献不显著，可以去除

## 去掉不显著的属性


```r
fit.reduced <- glm(ynaffair ~  age + yearsmarried +  religiousness + rating,
                data =  Affairs,
                family = binomial())

summary(fit.reduced)
```

```
## 
## Call:
## glm(formula = ynaffair ~ age + yearsmarried + religiousness + 
##     rating, family = binomial(), data = Affairs)
## 
## Deviance Residuals: 
##    Min      1Q  Median      3Q     Max  
## -1.628  -0.755  -0.570  -0.262   2.400  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)     1.9308     0.6103    3.16  0.00156 ** 
## age            -0.0353     0.0174   -2.03  0.04213 *  
## yearsmarried    0.1006     0.0292    3.44  0.00057 ***
## religiousness  -0.3290     0.0895   -3.68  0.00023 ***
## rating         -0.4614     0.0888   -5.19  2.1e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 675.38  on 600  degrees of freedom
## Residual deviance: 615.36  on 596  degrees of freedom
## AIC: 625.4
## 
## Number of Fisher Scoring iterations: 4
```

## 方差分析


```r
anova(fit.reduced,fit.full,test="Chisq")
```

```
## Analysis of Deviance Table
## 
## Model 1: ynaffair ~ age + yearsmarried + religiousness + rating
## Model 2: ynaffair ~ gender + age + yearsmarried + children + religiousness + 
##     education + occupation + rating
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       596        615                     
## 2       592        610  4     5.85     0.21
```
卡方值为0.21 ，不显著，可以使用简单模型拟合

## 模型解析

```r
exp(coef(fit.reduced))
```

```
##   (Intercept)           age  yearsmarried religiousness        rating 
##        6.8952        0.9653        1.1059        0.7196        0.6304
```

## 预测

构造虚拟数据

```r
testdata <- data.frame(rating = c(1,2,3,4,5),age = mean(Affairs$age),
                       yearsmarried = mean(Affairs$yearsmarried),
                       religiousness = mean(Affairs$religiousness))
testdata
```

```
##   rating   age yearsmarried religiousness
## 1      1 32.49        8.178         3.116
## 2      2 32.49        8.178         3.116
## 3      3 32.49        8.178         3.116
## 4      4 32.49        8.178         3.116
## 5      5 32.49        8.178         3.116
```

```r
testdataprob <- predict(fit.reduced,newdata=testdata,type="response")
testdata
```

```
##   rating   age yearsmarried religiousness
## 1      1 32.49        8.178         3.116
## 2      2 32.49        8.178         3.116
## 3      3 32.49        8.178         3.116
## 4      4 32.49        8.178         3.116
## 5      5 32.49        8.178         3.116
```

## 过度离势overdispersion

判断方式  残差偏差/残差自由度

```r
#判断方式  残差偏差/残差自由度
t = 615.36/596 = 1.03
```

```
## Error: target of assignment expands to non-language object
```
没有过度离势
拟合2次进行检查

```r
fit <- glm(ynaffair ~  age + yearsmarried +  religiousness + rating,
                data =  Affairs,
                family = binomial())
fit.od <- glm(ynaffair ~  age + yearsmarried +  religiousness + rating,
                data =  Affairs,
                family = quasibinomial())

pchisq(summary(fit.od)$dispersion * fit$df.residual , fit$df.residual , lower = F)
```

```
## [1] 0.3401
```

0.34 显然不显著
没有出现过度离势
