library(tidyverse)
library(questionr)
library(tree)

uberlyft <- read.csv('rideshare_kaggle.csv')


tab <- freq.na(uberlyft)
tab

#initial cleaning 
str(uberlyft)

uberlyft <- na.exclude(uberlyft)

uberlyft$timezone <- as.numeric(uberlyft$timezone)
uberlyft$source <- as.numeric(uberlyft$source)
uberlyft$destination <- as.numeric(uberlyft$destination)
uberlyft$cab_type <- as.numeric(uberlyft$cab_type)
uberlyft$product_id <- as.numeric(uberlyft$product_id)
uberlyft$name <- as.numeric(uberlyft$name)
uberlyft$short_summary <- as.numeric(uberlyft$short_summary)
uberlyft$long_summary <- as.numeric(uberlyft$long_summary)
uberlyft$icon <- as.numeric(uberlyft$icon)
#removing overly large factors datetime and id because im too lazy to categorize datetime and id is useless
uberlyft <- uberlyft[,-6]
uberlyft <- uberlyft[,-1]

#Changing price to have 2 response variables
Pricing <- ifelse(uberlyft$price > 15, 1, 0)
#combining data frame
uberlyft <- data.frame(uberlyft,Pricing)
#uberlyft <- uberlyft[,-57]

#Making the treeeeeee
tree.uberlyft <- tree(Pricing~.-price, data = uberlyft)
#plotting the initial tree
plot(tree.uberlyft)
text(tree.uberlyft, pretty = 0)

#splitting the data
library(caTools)
split <- sample.split(uberlyft, SplitRatio = 0.75)
training_set <- subset(uberlyft, split == TRUE)
test_set <- subset(uberlyft, split == FALSE)

#Refitting our decision tree
tree.uberlyft <- tree(Pricing~.-price, data = training_set)
plot(tree.uberlyft)
text(tree.uberlyft, pretty = 10)
summary(tree.uberlyft)

#measuring the accuracy of the tree
library(ROSE)
prob_pred <- predict(tree.uberlyft, method = "vector", newdata = test_set)
y_pred <- ifelse(prob_pred > 0.5, 1, 0)
con_matrix <- table(y_pred, test_set[,56])
accuracy.meas(y_pred, test_set[,56])


#Doing a random forrest
#install.packages("randomForest")
library(randomForest)

#building the model
forest.uberlyft <- randomForest(Pricing~.-price, data = training_set)#whyyyyyyy does nothing ever work when I do it


#plotting the forest
plot(forest.uberlyft)
test(forest.uberlyft, pretty = 5)

#measuring accuracy
prob_pred <- predict(forest.uberlyft, method = "forest", new_data = test_set[,56])
y_pred <- ifelse(prob_pred > 0.5,1,0)
con_matrix <- table(y_pred, test_set[,56])
accuracy.meas(prob_pred, y_pred)

#Conclusion
#I was not able to run the random forest, the code and everything is correct, and the code line runs
# However it runs indefinitely and does not finish, this is after nearly 4+ hours of letting Rstudio try to fun the line.

# The decision tree however did work.But if you examine the accuracy for the decision tree its accuracy measures are extremely high
# with the measures nearly at 1, we can assume that the decision tree is overfilled. 