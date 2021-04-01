library(dslabs)
library(dplyr)
data <- read.csv("train-2.csv")

#1 - Proportion of Na's

sum(is.na(data$Age))/891 #891 is the total number of data entries
sum(is.na(data$Cabin))/891
sum(is.na(data$Embarked))/891

#Setting NA's
data[data == ""] <- NA
#Histogram
class(data$Age)
as.numeric(data$age)
age_dist <- hist(data$Age)

#Removing Passenger ID & Name
data <- data[, -1]
data <- data[, -3]


#Replace NA's w/ Median Age
agemedian <- median(data$Age, na.rm = TRUE)

data$Age[is.na(data$Age)] <- median(data$Age, na.rm = TRUE)

#Removing Empy Cabin and Embarked Data
data = data[ complete.cases(data$Cabin),]

data$Embarked[is.na(data$Embarked) == TRUE] <- "S"

#2 - Adding Fare per person and Age Group
library(dplyr)
fareper <- ifelse(data$SibSp > 0, data$Fare/data$SibSp + 1, data$Fare) #adding in +1 for the person themselves who payed the fare
data <- mutate(data, fareper)

hist(data$Age)
#AgeGroup - creating column first, then changing values of the column to the relating age group
data <- mutate(data, agegroup)

data$agegroup[data$Age <= 20] = "0-20"
data$agegroup[data$Age > 20 & data$Age <= 40] = "21-40"
data$agegroup[data$Age > 40 & data$Age <= 60] = "41-60"
data$agegroup[data$Age > 60] = "60+"

#3. Encoding Categorical Variables for passenger Sex and Embarked status

data$Sex <- factor(data$Sex,labels = 1:2)
data$Embarked <- factor(data$Embarked, labels = 1:3)

#4. Regression - Age & Survival - Survival is reponse variable
library(caTools)

split = sample.split(data$Survived, SplitRatio =  0.8)
training_set <- subset(data, split == TRUE)
test_set <- subset(data, split == FALSE)

#5 - classifier for Gender and survival
classifier_sex <- glm(Survived~Sex, family = binomial, data = training_set)

#Men had a much lower chance of surviving the titanic ------------------------RESULT - negative coefficient between sex and survival

#Classififer for Age and survival --------------------------------------------RESULT - Negative coefficient between age and survival
classifier_age <- glm(Survived~Age, family = binomial, data = training_set)

prob_survive_age <- predict(classifier_age, type = "response", test_set[,-1])
prob_survive_sex <- predict(classifier_sex, type = "response", test_set[,-1])

#Matrix
surviveornot_age <- ifelse(prob_survive_age >= 0.5 ,1 ,0)              
survival_matrix_age <- table(surviveornot_age, test_set[,1])
survival_matrix_age

surviveornot_sex <- ifelse(prob_survive_sex >= 0.5 ,1 ,0)              
survival_matrix_sex <- table(surviveornot_sex, test_set[,1])
survival_matrix_sex

#6. Accuracy
accuracy_age_v_survival <- 29/41

accuracy_sex_v_survival <- 29/41

#7. ----- Travelling Alone

#Creating a single categorical colum 
data <- mutate(data, AloneOrNot = ifelse(SibSp+Parch >= 1, 1, 0))
#Removiing Sibsp & Parch
data <- data[, -5]
data <- data[, -5]

#rebuilding Test and Training sets 
split = sample.split(data$Survived, SplitRatio =  0.8)
training_set2 <- subset(data, split == TRUE)
test_set2 <- subset(data, split == FALSE)

classifier_aloneornot <- glm(Survived~AloneOrNot, family = binomial, data = training_set2)


#8.
prob_survive_alone <- predict(classifier_aloneornot, type = "response", test_set2[,-1])

surviveornot_alone <- ifelse(prob_survive_alone >= 0.6 ,1 ,0)    #We needed a threshold for survival that was higher than 0.5          
survival_matrix_alone <- table(surviveornot_alone, test_set2[,1])
survival_matrix_alone

accuracy_survive_alone = 25/41

#8.--------------- Based on this we can determine that you were more likely to die traveling alone than if you have parents or siblings 

#9. Step 7 actually did improve our accuracy by quite a lot, so well in fact that we had to raise the threshold for probability of survival
#from 0.5 to 0.6 in order to retreive an accurate accuracy rating for surviving along or not.

#10.we did not do much else outside from what was assigned. The only thing I can think of was removing the Sibsp and Parch columns




