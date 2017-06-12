#install.packages("gbm")
#install.packages("randomForest")
library(randomForest)
library(caret)
library(gbm)

train <- read.csv('train.csv', header = FALSE)
test <- read.csv('test_13.csv', header = FALSE)
test2 <- read.csv('test_14.csv', header = FALSE)
test3 <- read.csv('test_15.csv', header = FALSE)

temp1 <- read.csv('results.csv', header = FALSE)


Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

temp2 <- apply(temp1[1:1000,1:12], 1, Mode)

train <- cbind(train,temp2)

test <- cbind(test, temp1[1:1000,13])
test2 <- cbind(test2, temp1[1:1000,14])
test3 <- cbind(test3, temp1[1:1000,15])

names(train) <- c("Decay_0.25", "Decay_0.5", "Decay_0", "Decay_1", "optimal")

names(test) <- c("Decay_0.25", "Decay_0.5", "Decay_0", "Decay_1", "optimal")
names(test2) <- c("Decay_0.25", "Decay_0.5", "Decay_0", "Decay_1", "optimal")
names(test3) <- c("Decay_0.25", "Decay_0.5", "Decay_0", "Decay_1", "optimal")


############################ Logistic Regression ###############################

model <- glm(optimal ~ ., family = binomial(link = 'logit'), data = train)

summary(model)

LRpred_13 <- predict(model,newdata = test,type='response')
LRpred_14 <- predict(model,newdata = test2,type='response')
LRpred_15 <- predict(model,newdata = test3,type='response')


#fitted.results

LRpred_13 <- ifelse(LRpred_13 > 0.3,1,0)
LRpred_14 <- ifelse(LRpred_14 > 0.3,1,0)
LRpred_15 <- ifelse(LRpred_15 > 0.3,1,0)

confusionMatrix(LRpred_13, test$optimal)
confusionMatrix(LRpred_14, test2$optimal)
confusionMatrix(LRpred_15, test3$optimal)


####################### Gradient Boosting Method #################################

GBM.model <- gbm(optimal ~ ., train, distribution = "bernoulli", n.trees = 500, bag.fraction = 0.75, cv.folds = 5, interaction.depth = 3)


summary(GBM.model)

pred_13 <- predict(GBM.model,newdata = test,type='response')
pred_14 <- predict(GBM.model,newdata = test2,type='response')
pred_15 <- predict(GBM.model,newdata = test3,type='response')

pred_13 <- ifelse(pred_13 > 0.2,1,0)
pred_14 <- ifelse(pred_14 > 0.2,1,0)
pred_15 <- ifelse(pred_15 > 0.2,1,0)

confusionMatrix(pred_13, test$optimal)
confusionMatrix(pred_14, test2$optimal)
confusionMatrix(pred_15, test3$optimal)

####################### Random Forests #################################

RF.model <- randomForest(optimal ~ ., data=train, importance=TRUE, ntree=2000)

summary(model)

RFpred_13 <- predict(RF.model,newdata = test,type='response')
RFpred_14 <- predict(RF.model,newdata = test2,type='response')
RFpred_15 <- predict(RF.model,newdata = test3,type='response')


#fitted.results

RFpred_13 <- ifelse(RFpred_13 > 0.35,1,0)
RFpred_14 <- ifelse(RFpred_14 > 0.35,1,0)
RFpred_15 <- ifelse(RFpred_15 > 0.35,1,0)

confusionMatrix(RFpred_13, test$optimal)
confusionMatrix(RFpred_14, test2$optimal)
confusionMatrix(RFpred_15, test3$optimal)
