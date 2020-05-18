# https://www.bnosac.be/index.php/blog/56-an-overview-of-text-mining-visualisations-possibilities-with-r-on-the-ceta-trade-agreement
library(data.table)
count.matches <- function(pat, vec) sapply(regmatches(vec, gregexpr(pat, vec)), length)

df <- read.table("c:/tmp/savedrecs.txt", sep = "\t", header = TRUE, quote = "", row.names = NULL, stringsAsFactors = FALSE, fileEncoding = "UTF-16")

## Natural Language Processing: POS tagging
library(pattern.nlp)
#df <- df[1:33, ]
if(!file.exists("df_tagged.RData")){
  df_tagged <- lapply(1:nrow(df), function(thisrow){
    tryCatch(cbind(pattern_pos(x = df$ID[thisrow], language = "english", core = TRUE), thisrow), error = function(e){NULL})
  })  
  saveRDS(df_tagged, "df_tagged.RData")
} else {
  df_tagged <- readRDS("df_tagged.RData")
}
dft <- rbindlist(df_tagged, use.names = FALSE)

table(dft$word.type)[order(table(dft$word.type), decreasing = T)]

## Take only nouns
df_nouns <- dft[grepl("^NN", word.type), ]
df_nouns <- df_nouns[count.matches("[a-z]", tolower(word.lemma)) > 2, ]


## Look at POS tags
library(lattice)
barchart(sort(table(dft$word.type)), col = "lightblue", xlab = "Term frequency", 
         main = "Parts of Speech Tag term frequency")
head(dft[dft$word.type == "JJ", ])


# Topic model -------------------------------------------------------------

# What are these texts about? 
library(topicmodels)
library(udpipe)
library(slam)

nounbydoc <- df_nouns[, list(freq = .N), by = list(document = thisrow, term = word.lemma)]

dtm <- udpipe::document_term_matrix(document_term_frequencies(nounbydoc)) # document_frequency_matrix(x)
topterms <- col_sums(dtm)
topterms <- sort(topterms, decreasing = TRUE)
hist(topterms, breaks = 100)
tt <- table(topterms)
plot(1:10, tt[1:10], type = "l")
topterms <- topterms[topterms > 5]
topterms <- head(topterms, 250)
topterms <- names(topterms)
dtm_top <- dtm[, topterms]
dtm_top_freq <- dtm[row_sums(dtm) > 0, ]
set.seed(123456789)

topics <- LDA(x = dtm_top_freq[, topterms], k = 5, method = "VEM", control = list(alpha = 0.1, estimate.alpha = TRUE, seed = as.integer(10:1), verbose = FALSE, nstart = 10, save = 0, best = TRUE))
# What topics are there?
topic_terms <- predict(topics, type = "terms", min_posterior = 0.01)
topic_terms
scores <- predict(topics, newdata = dtm[, topterms], type = "topics")
# How many articles about each topic?
table(scores$topic)


# Wordcloud ---------------------------------------------------------------

## Word frequencies
x <- df_nouns[, list(n = .N), by = list(word.lemma)]
x <- x[order(x$n, decreasing = TRUE), ]
x <- as.data.frame(x)

## Visualise them with wordclouds
library(wordcloud)
wordcloud(words = x$word.lemma, freq = x$n, max.words = 150, random.order = FALSE, colors = brewer.pal(8, "Dark2"))


# Co-occurrence -----------------------------------------------------------

library(ggraph)
library(ggforce)
library(igraph)
library(tidytext)

#word_cooccurences <- pair_count(df_nouns, group="article.id", value="word.lemma", sort = TRUE)

x <- df_nouns
dtm <- document_term_frequencies(x = x, document = "thisrow", term = "word.lemma")
dtm <- document_term_matrix(dtm)
correlation <- dtm_cor(dtm)
word_cooccurences <- as_cooccurrence(correlation)
word_cooccurences <- word_cooccurences[order(word_cooccurences$cooc, decreasing = TRUE), ]
#word_cooccurences$cooc <- (word_cooccurences$cooc-min(word_cooccurences$cooc))+.1
set.seed(123456789)
head(word_cooccurences, 120) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(mapping = aes(edge_colour = cooc)) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1.8, col = "darkgreen") +
  ggtitle(sprintf("\n%s", "CETA treaty\nCo-occurrence of nouns")) +
  theme_void()

table(word_cooccurences$cooc)



library(Matrix)
library(qgraph)
terms <- predict(ceta_topics, type = "terms", min_posterior = 0.025)
terms <- unique(unlist(sapply(terms, names)))
out <- dtm_top
out <- cor(as.matrix(out))
out <- nearPD(x=out, corr = TRUE)$mat
out <- as.matrix(out)

m <- EBICglasso(out, n = 365, threshold = TRUE)
qgraph(m, layout="spring", labels = colnames(out), label.scale=FALSE,
       label.cex=1, node.width=.5)