library(data.table)
library(bibliometrix)
library(yaml)
library(stringr)
library(lattice)
library(topicmodels)
library(udpipe)
library(slam)
library(tidytext)
library(ggraph)
library(ggforce)
library(igraph)
library(tidytext)

source("word_functions.R")

## Look at POS tags?

recs <- data.table(read.csv("recs_final.csv"))
recs[, "doc" := 1:nrow(recs)]

# Try quanteda
#library(quanteda)
#corp <- corpus(recs, text_field = "DE")  # build a new corpus from the texts
# Try kwic
#kwic(corp, pattern = "drug")

# Extract individual words
df <- lapply(recs$DE, function(x){strsplit(x, split = "; ")[[1]]})
df <- merge_df(recs, df, "word")

df[, word := tolower(word)]

# Clean
df <- na.omit(df, cols = "word")

# Exclude words
exclude_terms <- readLines("exclude_terms.txt")
exclude_these <- unique(unlist(lapply(exclude_terms, grep, x = df$word)))

df <- df[!exclude_these, ]

# Categorize words
dict <- read_yaml("yaml_dict.txt")
res_cat <- cat_words(df$word, dict, handle_dups = "all")
# Check coding issues
#res_cat$dup
#head(res_cat$unmatched)
df <- merge_df(df, res_cat$words, "word_coded")


# Create plot data --------------------------------------------------------
nounbydoc <- df[, list(freq = .N), by = list(doc_id = doc, term = word)]
nounbydoc$freq <- 1
dtm <- udpipe::document_term_matrix(document_term_frequencies(nounbydoc))
tt <- as.data.frame(table(col_sums(dtm)), stringsAsFactors = FALSE)
tt$Frequency <- as.numeric(tt$Var1)
tt$Words <- tt$Freq
tt$Dictionary <- "Original"
df_plot <- tt[, c("Frequency", "Words", "Dictionary")]
rm(nounbydoc, dtm, tt)
# End plot data -----------------------------------------------------------


# Remove duplicate words per doc
#df[, id := paste0(word_coded, doc)]
#df <- df[!duplicated(id), ]
#df[, id := NULL]
#head(df)

# Frequency of word by doc
nounbydoc <- df[, list(freq = .N), by = list(doc_id = doc, term = word_coded)]
# Set frequency to 1; we're not interpreting word frequency, only occurrence
nounbydoc$freq <- 1
# tmp <- nounbydoc %>%
#   bind_tf_idf(term, doc_id, freq)
# summary(tmp$tf_idf)
dtm <- udpipe::document_term_matrix(document_term_frequencies(nounbydoc))
topterms <- col_sums(dtm)
topterms <- sort(topterms, decreasing = TRUE)

tt <- as.data.frame(table(topterms), stringsAsFactors = FALSE)
tt$Frequency <- as.numeric(tt$topterms)
tt$Words <- tt$Freq
tt$Dictionary <- "Recoded"
df_plot <- rbind(df_plot, tt[, c("Frequency", "Words", "Dictionary")])
ggplot(df_plot, aes(x=Frequency, y = Words, linetype = Dictionary))+geom_point() + geom_path()+
         theme_bw() + scale_y_log10()+scale_x_log10()

topterms <- topterms[topterms > .005*nrow(recs)]

which_topterms <- head(topterms, 250)
which_topterms <- names(which_topterms)
dtm_top <- dtm[, which_topterms]
dtm_top <- dtm_top[row_sums(dtm_top) > 0, ]
dim(dtm_top)
# Wordcloud ---------------------------------------------------------------

## Word frequencies

word_freq <- data.frame(Word = names(topterms), Frequency = topterms, row.names = NULL)
df_plot <- word_freq
df_plot$Word <- str_to_sentence(gsub("[_-]", " ", df_plot$Word))
## Visualise them with wordclouds
library(wordcloud)
svg("study1_wordcloud.svg")
set.seed(46)
wordcloud(words = df_plot$Word, freq = df_plot$Frequency, scale = c(5,1), max.words = 150, rot.per = 0,  random.order = FALSE, colors = brewer.pal(8, "Dark2"))
dev.off()

png("study1_wordcloud.png")
set.seed(46)
wordcloud(words = df_plot$Word, freq = df_plot$Frequency, scale = c(5,1), max.words = 150, rot.per = 0,  random.order = FALSE, colors = brewer.pal(8, "Dark2"))
dev.off()

# Co-occurrence -----------------------------------------------------------

#word_cooccurences <- pair_count(df_nouns, group="article.id", value="word.lemma", sort = TRUE)
create_cooc <- function(dtm){
  dtm_binary <- dtm > 0
  Matrix::t(dtm_binary) %*% dtm
}

cooc <- create_cooc(dtm_top)

word_cooccurences <- as_cooccurrence(cooc)
word_cooccurences <- word_cooccurences[!word_cooccurences$term1 == word_cooccurences$term2, ]
word_cooccurences <- word_cooccurences[order(word_cooccurences$cooc, decreasing = TRUE), ]

plot(1:length(word_cooccurences$cooc), word_cooccurences$cooc)

df_plot <- word_cooccurences[word_cooccurences$cooc > .005*nrow(recs), ] #.01*nrow(recs), ]

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

library(igraph)

edg <- df_plot
edg$width = edg$cooc

vert <- data.frame(name = names(topterms), label = str_to_sentence(gsub("[_-]", " ", names(topterms))), size = topterms)
vert <- vert[vert$name %in% unique(c(edg$term1, edg$term2)), ]

categ <- read.csv("study1_categorization.csv", stringsAsFactors = FALSE)
if(any(!vert$name %in% categ$name)) stop("Please re-categorize missing vertices.")
vert$Category <- categ$category[match(vert$name, categ$name)]

cat_cols <- c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "forestgreen")
cat_cols <- c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "olivedrab2")
vert$color <- cat_cols[vert$Category]

#min_size <- (strwidth(vert$name[max(nchar(vert$name))]) + strwidth("oo")) * 100
vert$size <- scales::rescale(vert$size, c(12, 20))
g <- graph_from_data_frame(edg, vertices = vert,
                           directed = FALSE)

#min_size <- (strwidth(vert$label[max(nchar(vert$label))]) + strwidth("oo"))*100

#V(g)$size <- scales::rescale(V(g)$size, c(min_size, 2*min_size))

#V(graphNetwork)$size <- log(degree(graphNetwork)) * 5

# All nodes must be assigned a standard minimum-size


# edge thickness
E(g)$width <- scales::rescale(sqrt(E(g)$width), to = c(2, 8))


edge.start <- ends(g, es=E(g), names = FALSE)[,1]
# Color edges based on origin:
#E(g)$color <- V(g)$color[edge.start]
E(g)$lty <- c(1, 5)[(!edge.start == 1)+1]
# Other layouts:
#l <- layout_with_lgl(g, root = which(V(g)$name == "dysregulation"))
#l <- layout_with_fr(g)
#l <- layout_(g,with_dh(weight.edge.lengths = edge_density(g)/1000))
set.seed(12) #4 #2 #3
l <- layout_with_fr(g)

png("study1_network1.png")
# Set margins to 0
par(mar=c(0,0,0,0))
plot(g, edge.curved = 0, layout=l,
     vertex.label.family = "sans",
     vertex.label.cex = 0.8,
     vertex.shape = "circle",
     vertex.frame.color = 'darkolivegreen',
     vertex.label.color = 'black',      # Color of node names
     vertex.label.font = 1,         # Font of node names
)
legend(x=-1.1, y=1.1, names(cat_cols), pch=21, col="#777777", pt.bg=cat_cols, pt.cex=2, cex=.8, bty="n", ncol=1)
dev.off()

svg("study1_network1.svg")
# Set margins to 0
par(mar=c(0,0,0,0))
plot(g, edge.curved = 0, layout=l,
     vertex.label.family = "sans",
     vertex.label.cex = 0.8,
     vertex.shape = "circle",
     vertex.frame.color = 'darkolivegreen',
     vertex.label.color = 'black',      # Color of node names
     vertex.label.font = 1,         # Font of node names
)
legend(x=-1.1, y=1.1, names(cat_cols), pch=21, col="#777777", pt.bg=cat_cols, pt.cex=2, cex=.8, bty="n", ncol=1)
dev.off()


library(qgraph)

igraph::
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

gD <- igraph::simplify(igraph::graph.data.frame(allgenes, directed=FALSE))
lou <- cluster_louvain(gD)
