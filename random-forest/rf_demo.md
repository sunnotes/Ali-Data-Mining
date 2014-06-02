---
layout: post
title: "使用R实现随机森林"
description: ""
category: statistics
tags: [ 随机森林 , R,分类 ]
---
{% include JB/setup %}



## 算法大概

### 决策树
决策树（decision tree）是一个树结构（可以是二叉树或非二叉树）。其每个非叶节点表示一个特征属性上的测试，每个分支代表这个特征属性在某个值域上的输出，而每个叶节点存放一个类别。使用决策树进行决策的过程就是从根节点开始，测试待分类项中相应的特征属性，并按照其值选择输出分支，直到到达叶子节点，将叶子节点存放的类别作为决策结果。
### 随机森林模型
随机森林是用随机的方式建立一个森林，森林里面有很多的决策树组成，随机森林的每一棵决策树之间是没有关联的。在得到森林之后，当有一个新的输入样本进入的时候，就让森林中的每一棵决策树分别进行一下判断，看看这个样本应该属于哪一类，然后看看哪一类被选择最多，就预测这个样本为那一类。
### 随机森林模型的注意点
设有N个样本，每个样本有M个features，决策树们其实都是随机地接受n个样本（对行随机取样）的m个feature（对列进行随机取样），每颗决策树的m个feature相同。每颗决策树其实都是对特定的数据进行学习归纳出分类方法，而随机取样可以保证有重复样本被不同决策树分类，这样就可以对不同决策树的分类能力做个评价。

## 加载数据


```r
#import the random forest library
#install.packages("randomForest")
#library( "randomForest" )
#the test dataset
data(iris)
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

```r
dim(iris)
```

```
## [1] 150   5
```

## 随机选择80%数据作为训练集，20%的数据作为测试集

```r
#set random situation, not for sure the purpose
set.seed(100)
#select traning data and prediction data
ind<-sample(2,nrow(iris),replace=TRUE,prob=c(0.8,02))
```

## 建模

```r
#constuct random forest training
library(randomForest)
```

```
## randomForest 4.6-7
## Type rfNews() to see new features/changes/bug fixes.
```

```r
iris.rf<-randomForest(Species ~.,iris[ind==1,],ntree=50,nPerm=10,mtry=3,proximity=TRUE,importance=TRUE)
#show the model
print(iris.rf)
```

```
## 
## Call:
##  randomForest(formula = Species ~ ., data = iris[ind == 1, ],      ntree = 50, nPerm = 10, mtry = 3, proximity = TRUE, importance = TRUE) 
##                Type of random forest: classification
##                      Number of trees: 50
## No. of variables tried at each split: 3
## 
##         OOB estimate of  error rate: 7.32%
## Confusion matrix:
##            setosa versicolor virginica class.error
## setosa         15          0         0     0.00000
## versicolor      0         11         1     0.08333
## virginica       0          2        12     0.14286
```

## 预测

```r
#predict
iris.pred<-predict( iris.rf,iris[ind==2,] )
#show the prediction result compare to original
table(observed=iris[ind==2,"Species"],predicted=iris.pred )
```

```
##             predicted
## observed     setosa versicolor virginica
##   setosa         35          0         0
##   versicolor      0         37         1
##   virginica       0          3        33
```


