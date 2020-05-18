library(data.table)
library(bibliometrix)
source("word_functions.R")
exclude_terms <- readLines("exclude_terms.txt")
dict_synon <- dget("dictionary_synonyms.txt")
#recs <- convert2df(bibliometrix::readFiles("savedrecs_full.txt"))
#saveRDS(recs, "savedrecs.RData")
recs <- readRDS("recs_6653.RData")
#recs <- unique_recs
df <- lapply(recs$DE, function(x){strsplit(x, split = "; ")[[1]]})
df <- data.table(word = tolower(unlist(df)), doc = rep(1:length(df), times = sapply(df, length)))

#table(grep("disease", df$word, value = T))
exclude_these <- unique(unlist(lapply(exclude_terms, grep, x = df$word)))

df <- df[!exclude_these, ]

res_cat <- cat_words(df$word, dict_synon)
# head(sort(table(res_cat$words), decreasing = T), 20)
# res_cat$dup
# head(res_cat$unmatched)
# writeClipboard(names(res_cat$unmatched))

# Remove duplicate words per doc
df[, word := res_cat$words]
df[, id := paste0(word, doc)]
df <- df[!duplicated(id), ]
df[, id := NULL]
#head(df)
## Look at POS tags
library(lattice)

# What are these texts about? 
library(topicmodels)
library(udpipe)
library(slam)

nounbydoc <- df[, list(freq = .N), by = list(document = doc, term = word)]

dtm <- udpipe::document_term_matrix(document_term_frequencies(nounbydoc)) # document_frequency_matrix(x)
topterms <- col_sums(dtm)
topterms <- sort(topterms, decreasing = TRUE)
hist(topterms, breaks = 100)
tt <- table(topterms)
plot(1:10, tt[1:10], type = "l")
topterms <- topterms[topterms > .005*nrow(recs)]

topterms <- head(topterms, 250)
topterms <- names(topterms)
dtm_top <- dtm[, topterms]
dtm_top <- dtm_top[row_sums(dtm_top) > 0, ]

set.seed(43892)

topics <- LDA(x = dtm_top, k = 5, method = "VEM", control = list(alpha = 0.1, estimate.alpha = TRUE, seed = as.integer(10:1), verbose = FALSE, nstart = 10, save = 0, best = TRUE))
# What topics are there?
topic_terms <- predict(topics, type = "terms", min_posterior = 0.01)
topic_terms
scores <- predict(topics, newdata = dtm[, topterms], type = "topics")
# How many articles about each topic?
table(scores$topic)


# Wordcloud ---------------------------------------------------------------

## Word frequencies
word_freq <- df[, list(n = .N), by = list(word)]
word_freq <- word_freq[order(word_freq$n, decreasing = TRUE), ]
word_freq <- as.data.frame(word_freq)

## Visualise them with wordclouds
library(wordcloud)
wordcloud(words = word_freq$word, freq = word_freq$n, max.words = 150, random.order = FALSE, colors = brewer.pal(8, "Dark2"))


# Co-occurrence -----------------------------------------------------------

library(ggraph)
library(ggforce)
library(igraph)
library(tidytext)

#word_cooccurences <- pair_count(df_nouns, group="article.id", value="word.lemma", sort = TRUE)
create_cooc <- function(dtm){
  dtm_binary <- dtm > 0
  Matrix::t(dtm_binary) %*% dtm
}

#dtm <- document_term_frequencies(x = df_co, document = "doc", term = "word")
#dtm <- document_term_matrix(dtm)
cooc <- create_cooc(dtm_top)

word_cooccurences <- as_cooccurrence(cooc)
word_cooccurences <- word_cooccurences[!word_cooccurences$term1 == word_cooccurences$term2, ]
word_cooccurences <- word_cooccurences[order(word_cooccurences$cooc, decreasing = TRUE), ]

plot(1:length(word_cooccurences$cooc), word_cooccurences$cooc)

df_plot <- word_cooccurences[word_cooccurences$cooc > .01*nrow(recs), ]

#df_plot <- df_plot[!(df_plot$term1 == "youth" | df_plot$term2 == "youth"),]
df_plot$id <- apply(df_plot[, c("term1", "term2")], 1, function(x)paste0(sort(x), collapse = ""))
df_plot <- df_plot[!duplicated(df_plot$id), c("term1", "term2", "cooc")]
#word_cooccurences$cooc <- (word_cooccurences$cooc-min(word_cooccurences$cooc))+.1
set.seed(123456789)
df_plot %>%
  graph_from_data_frame() %>%
  ggraph(layout = "circle") +
  geom_edge_link(mapping = aes(edge_colour = cooc, edge_width = cooc)) +
  #geom_node_text(color = "lightblue", size = 5) +
  geom_node_label(aes(label = name), col = "darkgreen") +
  ggtitle(sprintf("\n%s", "CETA treaty\nCo-occurrence of nouns")) +
  theme_void()

table(word_cooccurences$cooc)



library(Matrix)
library(qgraph)
terms <- predict(topics, type = "terms", min_posterior = 0.08)
terms <- unique(unlist(sapply(terms, names)))
out <- dtm_top
out <- cor(as.matrix(out))
out <- nearPD(x=out, corr = TRUE)$mat
out <- as.matrix(out)

cor_mat <- dtm_cor(dtm_top)
m <- EBICglasso(cor_mat, n = 429, threshold = TRUE, returnAllResults = T)
m$optnet
tmp <- as.data.frame.table(m$optnet)
tmp[!tmp$Freq == 0, ]
qgraph(tmp, layout="spring", labels = colnames(out), label.scale=FALSE,
       label.cex=1, node.width=.5)


df <- readRDS("savedrecs.RData")
bibliometrix::biblioNetwork(recs, analysis = "co-occurrences", network = "author_keywords")

tmp <- cocMatrix(recs, Field = "DE")

tmp %>%
  as_cooccurrence() %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(mapping = aes(edge_colour = cooc)) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1.8, col = "darkgreen") +
  ggtitle(sprintf("\n%s", "CETA treaty\nCo-occurrence of nouns")) +
  theme_void()
