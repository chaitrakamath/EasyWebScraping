#FileName:ChipotleTwitterAnalysis.R
#Author:Chaitra Kamath
#Description: Since Chipotle is embroiled E.Coli issues, I thought it would be worth looking at the 
#sentiments of folks on Twitter
#Reference: https://sites.google.com/site/miningtwitter/questions/sentiment/sentiment
#https://www.kaggle.com/ghassent/d/kaggle/hillary-clinton-emails/sentiments-text-mining-and-more/code
#Date: Jan 06th, 2016
#Extension: You can just plugin your object of interest(company / celebrity) in searchTwitter() function
#and you are good to go. You might want to add / delete text cleaning steps based on your need. I ran
#the same code for Tesla, which is doing really good now and the sentiments were far different if not
#exactly opposite. It was more positive and there was more trust, far less anticipation and anger. 

#Load necessary packages
library(twitteR) #to extract tweets
library(syuzhet) #to be able to analyze sentiments
library(ggplot2) #for plotting / data visualization
library(RColorBrewer) #to get the color palette
library(base64enc)

#create app on twitter and feed all the information about keys to be able to extract tweets
api_key <- 'your_api_key'
api_secret <- 'your_api_secret' 
access_token <- 'your_access_token'
access_token_secret <- 'your_access_token_secret'
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

#collect some tweets of Chipotle
chipotleTweets <- searchTwitter('chipotle', n = 1500, lang = 'en')
chipotleTweetsText <- sapply(chipotleTweets, function(x) x$getText())

#clean text before doing sentiment analysis
#remove retweet entities
chipotleTweetsText <- gsub("(RT|via)(( ?:\\b\\W*@\\w+)+)", '', chipotleTweetsText)
#remove @ people
chipotleTweetsText <- gsub("@\\w+", '', chipotleTweetsText)
#remove punctuation
chipotleTweetsText <- gsub('[[:punct:]]', '', chipotleTweetsText)
#remove any control characters
chipotleTweetsText <- gsub('[[:cntrl:]]', '', chipotleTweetsText)
#remove any numbers
#chipotleTweetsText <- gsub('[[:digit:]]', '', chipotleTweetsText)
#remove html links
chipotleTweetsText <- gsub(' ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)', '', chipotleTweetsText)
#remove any extra whitespaces
chipotleTweetsText <- gsub('[ \t]{2,}', '', chipotleTweetsText)
#remove any starting or trailing spaces
chipotleTweetsText <- gsub('^\\s+|\\s+$', '', chipotleTweetsText)
#remove any NAs 
chipotleTweetsText <- chipotleTweetsText[!is.na(chipotleTweetsText)]
#remove emojis
chipotleTweetsText <- gsub('[^ -~].*', '', chipotleTweetsText)
#convert all tweets to lowercase
chipotleTweetsText <- tolower(chipotleTweetsText)

#classify emotions - find raw emotions and then transform it to 
#frequency table of all emotions
rawEmotions <- get_nrc_sentiment(chipotleTweetsText)
t_rawEmotions <- data.frame(t(rawEmotions))
emotions <- data.frame(rowSums(t_rawEmotions))
names(emotions) <- 'count'
emotions <- cbind('sentiment' = rownames(emotions), emotions)
rownames(emotions) <- NULL

#plot emotions as bar graph
qplot(x = sentiment, data = emotions, weight = count, 
      geom = 'histogram', fill = sentiment) + ggtitle('Chipotle Sentiments')
