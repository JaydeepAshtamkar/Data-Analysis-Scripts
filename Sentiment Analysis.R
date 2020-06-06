# Importing necessary libraries
library(janeaustenr)
library(stringr)
library(tidytext)
library(dplyr)
library(tidyr)
library(ggplot2)
library(reshape2)
library(wordcloud)

# Converting text into tidy format
tidy_data <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(), chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", ignore_case = TRUE)))) %>%
ungroup() %>%
unnest_tokens(word, text)

# Filtering for positive words
# Using book Emma by Jane Austen to implement sentiment analysis model
positive_senti <- get_sentiments("bing") %>%
  filter(sentiment == "positive")

tidy_data %>%
  filter(book == "Emma") %>%
  semi_join(positive_senti) %>%
  count(word, sort = TRUE)
  
# Segregating positive and negative words
# Calculating difference between positive adn negative sentiments
bing <- get_sentiments("bing")
Emma_sentiment <- tidy_data %>%
  inner_join(bing) %>%
  count(book = "Emma", index = linenumber %/% 80, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

# Visualizing words present in book Emma based on sentiments
ggplot(Emma_sentiment, aes(index, sentiment, fill = book)) + geom_bar(stat = "identity", show.legend = TRUE) + facet_wrap(~book, ncol = 2, scales = "free_x")

# Counting most common sentiments present in the novel
counting_words <- tidy_data %>%
  inner_join(bing) %>%
  count(word, sentiment, sort = TRUE)
head(counting_words)

# Visualizing sentiment score
counting_words %>%
  filter(n > 150) %>%
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) + geom_col() + coord_flip() + labs(y = "Sentiment Score")

# Plotting sentiments in a world cloud
tidy_data %>%
  inner_join(bing) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("red", "dark green"), max.words = 100)
