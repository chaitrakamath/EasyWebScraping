#FileName:ChipotleTwitterAnalysis.R
#Author:Chaitra Kamath
#Description: Since Chipotle is embroiled E.Coli issues, I thought it would be worth looking at the 
#sentiments of folks on Twitter
#Reference: https://sites.google.com/site/miningtwitter/questions/sentiment/sentiment
#https://www.kaggle.com/ghassent/d/kaggle/hillary-clinton-emails/sentiments-text-mining-and-more/code
#Date: Jan 06th, 2016
#Applications: You can just plugin your object of interest(company / celebrity) in searchTwitter() function
#and you are good to go. You might want to add / delete text cleaning steps based on your need

#Load necessary packages
library(twitteR) #to extract tweets
library(ggplot2) #for plotting / data visualization
library(wordcloud) #to create wordcloud 
library(RColorBrewer) #to get the color palette
library(base64enc)
library(SnowballC)
library(tm) #for text mining purposes

#create app on twitter and feed all the information about keys to be able to extract tweets
api_key <- 'your_api_key'
api_secret <- 'your_api_secret' 
access_token <- 'your_access_token'
access_token_secret <- 'your_access_token_secret'
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

#collect some tweets of Chipotle
chipotleTweets <- searchTwitter('donaldtrump', n = 1500, lang = 'en')
chipotleTweetsText <- sapply(chipotleTweets, function(x) x$getText())

#clean text before doing sentiment analysis
#remove retweet entities
chipotleTweetsText <- gsub("(RT|via)(( ?:\\b\\W*@\\w+)+)", '', chipotleTweetsText)
#remove @ people
chipotleTweetsText <- gsub("@\\w+", '', chipotleTweetsText)
#remove html links
chipotleTweetsText <- gsub(' ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)', '', chipotleTweetsText)
#remove emojis
chipotleTweetsText <- gsub('[^ -~].*', '', chipotleTweetsText)
#remove punctuation
chipotleTweetsText <- gsub('[[:punct:]]', '', chipotleTweetsText)
#remove any control characters
chipotleTweetsText <- gsub('[[:cntrl:]]', '', chipotleTweetsText)
#remove any numbers
chipotleTweetsText <- gsub('[[:digit:]]', '', chipotleTweetsText)
#remove any extra whitespaces
chipotleTweetsText <- gsub('[ \t]{2,}', '', chipotleTweetsText)
#remove any starting or trailing spaces
chipotleTweetsText <- gsub('^\\s+|\\s+$', '', chipotleTweetsText)
#remove any NAs 
chipotleTweetsText <- chipotleTweetsText[!is.na(chipotleTweetsText)]
#convert all tweets to lowercase
chipotleTweetsText <- tolower(chipotleTweetsText)

#Create a corpus from all tweets
chipotleCorpus <- Corpus(VectorSource(chipotleTweetsText))
inspect(chipotleCorpus[1])

#do some more cleaning by removing punctuatios, stopwords and stemming words
chipotleCorpus <- tm_map(chipotleCorpus, PlainTextDocument)
chipotleCorpus <- tm_map(chipotleCorpus, removePunctuation)
wordsToRemove <- c('chipotle','the', 'this','shouldnt', 'rtchipotle','want', 'get', 
                   'still', 'dont', 'soon', 'time', 'now', 'like', 'led', 'food', 'eat')
chipotleCorpus <- tm_map(chipotleCorpus, removeWords, 
              c(wordsToRemove, stopwords('english')))
#chipotleCorpus <- tm_map(chipotleCorpus, stemDocument)

#create word cloud
wordcloud(chipotleCorpus, min.freq = 50, random.order = FALSE, 
          random.color = TRUE, max.words = 100, scale = c(3, 0.5),
          colors = rainbow(50))
