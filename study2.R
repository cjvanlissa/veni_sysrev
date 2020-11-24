library(data.table)
#library(bibliometrix)
#library(yaml)
library(stringr)
#library(lattice)
#library(topicmodels)
library(udpipe)
library(igraph)
library(wordcloud)
library(Matrix)
library(yaml)
library(Rmpfr)
library(topicmodels)
library(udpipe)
library(slam)
library(tidytext)
library(ggplot2)
library(textrank)
source("word_functions.R")
run_everything <- TRUE

## Look at POS tags?

recs <- data.table(read.csv("recs_final.csv"))
recs[, "doc" := 1:nrow(recs)]
recs$AB <- tolower(recs$AB)

# Detect languages not necessary; only one abstract is (partly) in Spanish.
#library(cld3)
#languages <- cld3::detect_language(recs$AB)
#table(languages)
#recs$AB[languages == "es"]

if(run_everything){
  if(!file.exists("english-ewt-ud-2.4-190531.udpipe")) {
    ud_model <- udpipe_download_model(language = "english")
  } else {
    ud_model <- udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")
    ud_model <- udpipe_load_model(ud_model$file)
  }
  udp_res <- udpipe_annotate(ud_model, x = recs$AB, doc_id = recs$doc)
  df <- as.data.table(udp_res)
  saveRDS(df, "study2_df.RData")
} else {
  df <- readRDS("study2_df.RData")
}


# LDA analysis ------------------------------------------------------------

if(run_everything){
  # Functions:
  harmonicMean <- function(logLikelihoods, precision = 2000L) {
    llMed <- median(logLikelihoods)
    as.double(llMed - log(mean(exp(-mpfr(logLikelihoods,
                                         prec = precision) + llMed))))
  }
  BIC <- function(ll, p, n){
    -2 * ll + p * log(n)
  }
  entropy <- function(post_prob){
    1 + (1/(nrow(post_prob) * 
              log(ncol(post_prob)))) * (sum(rowSums(post_prob * 
                                                      log(post_prob + 1e-12))))
  }
  
  # Preprocessing -----------------------------------------------------------
  
  # Frequency of word by doc
  nounbydoc <- df[df$upos %in% c("NOUN", "ADJ"), list(freq = .N), by = list(doc_id = doc_id, term = lemma)]
  df_lda <- nounbydoc #[nounbydoc$term %in% names(dict), ]
  df_lda <- df_lda %>%
    bind_tf_idf(term, doc_id, freq)
  summary(df_lda$tf_idf)
  
  select_words <- df_lda[!duplicated(df_lda$term), ]
  select_words <- select_words$term[select_words$tf_idf >= median(select_words$tf_idf)]
  df_lda <- df_lda[df_lda$term %in% select_words, ]
  
  dtm <- udpipe::document_term_matrix(document_term_frequencies(df_lda))
  yaml::write_yaml(dim(dtm), file = "Study2_lda_dims.txt")
  
  # Build topic models
  seqk <- seq(2, 20, 1)
  burnin <- 1000
  iter <- 1000
  keep <- 50
  set.seed(44773)
  res_lda <- lapply(seqk, function(k) {
    topicmodels::LDA(
      dtm,
      k = k,
      method = "Gibbs",
      control = list(
        burnin = burnin,
        iter = iter,
        keep = keep
      )
    )
  })
  
  ll <- sapply(res_lda, function(x){harmonicMean(x@logLiks[-c(1:(burnin/keep))])})
  
  K = seqk
  N = nrow(dtm)
  M = ncol(dtm)
  
  parameters <- K*(M-1)+N*(K-1)
  N <- nrow(dtm)
  bics <- BIC(ll, parameters, N)
  
  entropies <- sapply(res_lda, function(x){entropy(x@gamma)})
  
  p <- ggplot(data.frame(K = seqk, Entropy = entropies), aes(x = K, y = Entropy)) + geom_path() +
    xlab('Number of topics') +
    scale_y_continuous(limits = c(0,1)) +
    theme_bw()
  
  ggsave("study2_entropies.png", p, device = "png")
  ggsave("study2_entropies.svg", p, device = "svg")
  
  p <- ggplot(data.frame(K = seqk, ll = ll), aes(x = K, y = ll)) + geom_path() +
    geom_vline(xintercept = (which.max(ll)+1), linetype = 2) +
    xlab('Number of topics') +
    geom_smooth(method = "lm", formula = y~log(x), se = FALSE)+
    theme_bw()
  
  ggsave("study2_ll.png", p, device = "png")
  ggsave("study2_ll.svg", p, device = "svg")
  
  p <- ggplot(data.frame(K = seqk, BIC = bics), aes(x = K, y = BIC)) + geom_path() +
    geom_vline(xintercept = (which.min(bics)+1), linetype = 2) +
    xlab('Number of topics') +
    geom_smooth(method = "lm", formula = y~x, se = FALSE)+
    theme_bw()
  
  ggsave("study2_BIC.png", p, device = "png")
  ggsave("study2_BIC.svg", p, device = "svg")
}


# Keyword extraction ------------------------------------------------------

# Exclude words
if(run_everything){
  df_kw <- df[upos %in% c("NOUN", "ADJ"), ]
  df_kw <- df_kw[grepl("^[a-zA-Z].", df_kw$lemma), ]
  exclude_terms <- readLines("exclude_terms.txt")
  exclude_these <- unique(unlist(lapply(exclude_terms, grep, x = df_kw$lemma)))
  df_kw <- df_kw[-exclude_these, ]
  saveRDS(df_kw, "study2_df_kw.RData")
} else {
  df_kw <- readRDS("study2_df_kw.RData")
}

# No numeric values
# all(is.na(as.numeric(df_kw$lemma)))
#df_kw$lemma[nchar(df_kw$lemma) == 3]

if(run_everything){
  kw_tr <- textrank_keywords(x = df_kw$lemma[df_kw$upos %in% c("NOUN", "ADJ")], 
                             ngram_max = 3, sep = " ")
  saveRDS(kw_tr, "study2_textrank.RData")
} else {
  kw_tr <- readRDS("study2_textrank.RData")
}

if(run_everything){
  # Merge back with original data
  df_kw$keyword <- txt_recode_ngram(df_kw$lemma, compound = kw_tr$keywords$keyword, ngram = kw_tr$keywords$ngram, sep = " ")
  df_kw$keyword[!df_kw$keyword %in% kw_tr$keywords$keyword] <- NA
  
  df_analyze <- df_kw[!is.na(df_kw$keyword), ]
  dict <- read_yaml("yaml_dict.txt")
  res_cat <- cat_words(df_analyze$keyword, dict, handle_dups = "all")
  # Check coding issues
  #res_cat$dup
  #head(res_cat$unmatched)
  df_analyze <- merge_df(df_analyze, res_cat$words, "word_coded")
  saveRDS(df_analyze, "study2_df_analyze.RData")
} else {
  df_analyze <- readRDS("study2_df_analyze.RData")
}


# Wordcloud ---------------------------------------------------------------

if(run_everything){
  # Frequency of word by doc
  nounbydoc <- df_analyze[, list(freq = .N), by = list(doc_id = doc_id, term = word_coded)]
  number_docs_words2 <- c(docs = length(unique(nounbydoc$doc_id)), words = length(unique(nounbydoc$term)))
  
  nounbydoc$freq <- 1
  dtm <- udpipe::document_term_matrix(document_term_frequencies(nounbydoc))
  topterms <- colSums(dtm)
  topterms <- sort(topterms, decreasing = TRUE)
  
  # Select most common terms ------------------------------------------------
  set.seed(720)
  dtm_top <- dtm[, select_words(dtm, .975)]
  dtm_top <- dtm_top[rowSums(dtm_top) > 0, ]
  dim(dtm_top)
  
  #topterms <- topterms[topterms > .005*nrow(recs)]
  
  #which_topterms <- head(topterms, 250)
  #which_topterms <- names(which_topterms)
  #dtm_top <- dtm[, which_topterms]
  #dtm_top <- dtm_top[rowSums(dtm_top) > 0, ]
  #dim(dtm_top)
  
  # Wordcloud ---------------------------------------------------------------
  
  ## Word frequencies
  topterms <- colSums(dtm_top)
  topterms <- sort(topterms, decreasing = TRUE)
  word_freq <- data.frame(Word = names(topterms), Frequency = topterms, row.names = NULL)
  write.csv(word_freq, "study2_word_freq.csv", row.names = FALSE)
  df_plot <- word_freq
  df_plot$Word <- pretty_words(df_plot$Word)
  df_plot$Frequency <- sqrt(df_plot$Frequency)
  ## Visualise them with wordclouds
  p <- quote({
    set.seed(46)
    wordcloud(words = df_plot$Word, freq = df_plot$Frequency, scale = c(4,.4), max.words = 150, rot.per = 0,  random.order = FALSE, colors = brewer.pal(8, "Dark2"))
  })
  
  svg("study2_wordcloud.svg")
  eval(p)
  dev.off()
  
  png("study2_wordcloud.png")
  eval(p)
  dev.off()
}

# Feature importance ------------------------------------------------------
if(run_everything){
  topterms <- colSums(dtm_top)
  word_freq <- data.frame(Word = names(topterms), Frequency = topterms, row.names = NULL)
  df_plot <- word_freq
  categ <- read.csv("study1_categorization.csv", stringsAsFactors = FALSE)
  df_plot$cat <- categ$category[match(df_plot$Word, categ$name)]
  df_plot$Word <- pretty_words(df_plot$Word)
  
  df_plot <- df_plot[order(df_plot$Frequency, decreasing = TRUE), ]
  df_plot$Word <- ordered(df_plot$Word, levels = df_plot$Word[order(df_plot$Frequency)])
  
  cat_cols <- c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "forestgreen")
  df_plot$cat <- ordered(df_plot$cat, levels = c("Outcome", "Indicator", "Cause", "Protective"))
  
  write_yaml(df_plot$Word, "s2_words.yml")
  
  p <- ggplot(df_plot, aes(y = Word, x = Frequency)) +
    geom_segment(aes(x = 0, xend = Frequency,
                     y = Word, yend = Word), colour = "grey50",
                 linetype = 2) + geom_vline(xintercept = 0, colour = "grey50",
                                            linetype = 1) + xlab("Word frequency") +
    geom_point(aes(fill = cat), shape = 21, size = 2) +
    scale_fill_manual(values = c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "forestgreen")) +
    scale_x_log10() +
    theme_bw() + theme(panel.grid.major.x = element_blank(),
                       panel.grid.minor.x = element_blank(), axis.title.y = element_blank(),
                       legend.position = c(.70,.125),
                       legend.title = element_blank(),
                       axis.text.y = element_text(hjust=0, vjust = 0, size = 6))
  
  
  svg("s2_varimp.svg", width = 7/2.54, height = 14/2.54)
  eval(p)
  dev.off()
  
  ggsave("s2_varimp.png", p, device = "png", width = 7, height = 14, units = "cm")
}

# Co-occurrence -----------------------------------------------------------
if(run_everything){
  set.seed(5646)
  cooc <- select_cooc(create_cooc(dtm_top), q = .975)
  
  df_plot <- as_cooccurrence(cooc)
  df_plot <- df_plot[!df_plot$term1 == df_plot$term2, ]
  df_plot <- df_plot[order(df_plot$cooc, decreasing = TRUE), ]
  
  #perm <- replicate(100, permute(dtm_top))
  #q95 <- median(apply(perm, 3, function(k){quantile(k[lower.tri(k)], .95)}))
  
  #cooc <- as.matrix(create_cooc(dtm_top))
  
  #word_cooccurences <- as_cooccurrence(cooc)
  #word_cooccurences <- word_cooccurences[!word_cooccurences$term1 == word_cooccurences$term2, ]
  #word_cooccurences <- word_cooccurences[order(word_cooccurences$cooc, decreasing = TRUE), ]
  
  #tt <- as.data.frame(table(word_cooccurences$cooc), stringsAsFactors = FALSE)
  # tt$Frequency <- as.numeric(tt$Var1)
  # tt$Cooc <- tt$Freq
  # ggplot(tt, aes(x=Frequency, y = Cooc))+geom_point() + geom_path()+ geom_text(aes(label= Frequency))+ geom_vline(xintercept = q95, linetype = 2) + theme_bw() + scale_y_log10()+scale_x_log10()
  
  
  #df_plot <- word_cooccurences[word_cooccurences$cooc > .005*nrow(recs), ] #.01*nrow(recs), ]
  #df_plot <- word_cooccurences[word_cooccurences$cooc > q95, ] #.01*nrow(recs), ]
  df_plot$id <- apply(df_plot[, c("term1", "term2")], 1, function(x)paste0(sort(x), collapse = ""))
  df_plot <- df_plot[!duplicated(df_plot$id), ]
  
  #df_plot <- df_plot[!(df_plot$term1 == "youth" | df_plot$term2 == "youth"),]
  # #word_cooccurences$cooc <- (word_cooccurences$cooc-min(word_cooccurences$cooc))+.1
  # set.seed(123456789)
  # df_plot %>%
  #   graph_from_data_frame() %>%
  #   ggraph(layout = "circle") +
  #   geom_edge_link(mapping = aes(edge_colour = cooc, edge_width = cooc)) +
  #   #geom_node_text(color = "lightblue", size = 5) +
  #   geom_node_label(aes(label = name), col = "darkgreen") +
  #   ggtitle(sprintf("\n%s", "CETA treaty\nCo-occurrence of nouns")) +
  #   theme_void()
  
  
  # Create network ----------------------------------------------------------
  
  edg <- df_plot
  edg$width = edg$cooc
  
  vert <- data.frame(name = names(topterms), label = pretty_words(names(topterms)), size = topterms)
  vert <- vert[vert$name %in% unique(c(edg$term1, edg$term2)), ]
  
  categ <- read.csv("study1_categorization.csv", stringsAsFactors = FALSE)
  if(any(!vert$name %in% categ$name)){
    write.table(vert$name[!vert$name %in% categ$name], "clipboard", sep = "\n", row.names = FALSE, col.names= FALSE)
    stop("Please re-categorize missing vertices.")
  } 
  vert$Category <- categ$category[match(vert$name, categ$name)]
  
  cat_cols <- c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "forestgreen")
  cat_cols <- c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "olivedrab2")
  vert$color <- cat_cols[vert$Category]
  
  vert$size <- scales::rescale(log(vert$size), c(4, 12))
  g <- graph_from_data_frame(edg, vertices = vert,
                             directed = FALSE)
  
  # edge thickness
  E(g)$width <- scales::rescale(sqrt(E(g)$width), to = c(.2, 8))
  dysreg_vertex = which(names(V(g)) == "dysregulation")
  
  edge.start <- ends(g, es=E(g), names = FALSE)[,1]
  edge.end <- ends(g, es=E(g), names = FALSE)[,2]
  # Color edges based on origin:
  #E(g)$color <- V(g)$color[edge.start]
  E(g)$lty <- c(1, 5)[(!(edge.start == dysreg_vertex|edge.end == dysreg_vertex))+1]
  
  set.seed(12) #4 #2 #3
  l1 <- l <- layout_with_fr(g)
  set.seed(64)
  l2 <- layout_in_circle(g)
  
  p <- quote({
    # Set margins to 0
    par(mar=c(0,0,0,0),
        mfrow=c(1,2))
    plot(g, edge.curved = 0, layout=l1,
         vertex.label.family = "sans",
         vertex.label.cex = 0.8,
         vertex.shape = "circle",
         vertex.frame.color = 'gray40',
         vertex.label.color = 'black',      # Color of node names
         vertex.label.font = 1,         # Font of node names
    )
    legend(x=-1.1, y=1.1, names(cat_cols), pch=21, col="#777777", pt.bg=cat_cols, pt.cex=2, cex=.8, bty="n", ncol=1)
    plot(g, edge.curved = 0, layout=l2,
         vertex.label.family = "sans",
         vertex.label.cex = 0.8,
         vertex.shape = "circle",
         vertex.frame.color = 'gray40',
         vertex.label.color = 'black',      # Color of node names
         vertex.label.font = 1,         # Font of node names
    )
  })
  
  # Save files
  png("study2_network1.png", width = 960)
  eval(p)
  dev.off()
  
  svg("study2_network1.svg", width = 14)
  eval(p)
  dev.off()
}


tt <- sort(topterms, decreasing = TRUE)
notingraph <- names(tt)[!names(tt) %in% unique(c(edg$term1, edg$term2))]
notingraph <- categ[categ$name %in% notingraph, ]
# 
# library(qgraph)
# 
# igraph::
# library(Matrix)
# library(qgraph)
# terms <- predict(topics, type = "terms", min_posterior = 0.08)
# terms <- unique(unlist(sapply(terms, names)))
# out <- dtm_top
# out <- cor(as.matrix(out))
# out <- nearPD(x=out, corr = TRUE)$mat
# out <- as.matrix(out)
# 
# cor_mat <- dtm_cor(dtm_top)
# m <- EBICglasso(cor_mat, n = 429, threshold = TRUE, returnAllResults = T)
# m$optnet
# tmp <- as.data.frame.table(m$optnet)
# tmp[!tmp$Freq == 0, ]
# qgraph(tmp, layout="spring", labels = colnames(out), label.scale=FALSE,
#        label.cex=1, node.width=.5)
# 
# 
# df <- readRDS("savedrecs.RData")
# bibliometrix::biblioNetwork(recs, analysis = "co-occurrences", network = "author_keywords")
# 
# tmp <- cocMatrix(recs, Field = "DE")
# 
# tmp %>%
#   as_cooccurrence() %>%
#   graph_from_data_frame() %>%
#   ggraph(layout = "fr") +
#   geom_edge_link(mapping = aes(edge_colour = cooc)) +
#   geom_node_point(color = "lightblue", size = 5) +
#   geom_node_text(aes(label = name), vjust = 1.8, col = "darkgreen") +
#   ggtitle(sprintf("\n%s", "CETA treaty\nCo-occurrence of nouns")) +
#   theme_void()
# 
# gD <- igraph::simplify(igraph::graph.data.frame(allgenes, directed=FALSE))
# lou <- cluster_louvain(gD)
