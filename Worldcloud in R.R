#THis project was done by Payton Taylor, Tim Ryan, and Preney


slogan <- read.csv("sloganlist (1).csv")
library(tidyverse)
library(wordcloud)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(caTools)
install.packages("qdap")
library(qdap)


corpus= VCorpus(VectorSource(slogan$Slogan)) #Use the review colum for building the metaphorical bag of words from the reviews
corpus = tm_map(corpus, content_transformer(tolower)) #lowercase
corpus = tm_map(corpus, removeNumbers) #Removes Numbers
corpus = tm_map(corpus, removePunctuation) #Removes Punctuation
corpus = tm_map(corpus, removeWords, stopwords()) #stopwords(the, a, who, ...)
corpus = tm_map(corpus, stemDocument) #stem of the word
corpus = tm_map(corpus, stripWhitespace) #removing whitespaces (extra spaces)

#Creating the Bag of Words model
dtm = DocumentTermMatrix(corpus)
dtm = removeSparseTerms(dtm, 0.99) #reducing the sparsity ---> more info = slower

dataset = as.data.frame(as.matrix(dtm)) #dtm converted to dataframe
dataset$Liked = data$Liked #inserting Liked into dataset from data


TDM <- TermDocumentMatrix(corpus)
matrix <- as.matrix(TDM)
frq <- sort(rowSums(matrix), decreasing = TRUE)
dat = data.frame(word = names(frq), freq = frq)

#Wordcloud ----------------------------------------------------- #1
wordcloud(words = names(frq), freq = frq)

#2. --------------------------------------------------------------#2



install.packages("ngram")
library(ngram)
library(stringr)

slogan2 <- lengths(gregexpr("\\W+", slogan$Slogan)) # Counting the number of spaces in the slogans

#Citation
#https://stackoverflow.com/questions/8920145/count-the-number-of-all-words-in-a-string  



Average_word_per_slogan <- mean(slogan2)


