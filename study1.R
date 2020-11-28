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
library(ggplot2)
library(yaml)
source("word_functions.R")

run_everything = FALSE
study1details <- read_yaml("study1_details.yml")
dict <- read_yaml("yaml_dict.txt")
## Look at POS tags?
if(run_everything){
  recs <- data.table(read.csv("recs_final.csv"))
  recs[, "doc" := 1:nrow(recs)]
  study1details <- list(dim_recs = dim(recs))
  
  # Extract individual words
  df <- lapply(recs$DE, function(x){strsplit(x, split = "; ")[[1]]})
  df <- merge_df(recs, df, "word")
  
  df[, word := tolower(word)]
  
  # Clean
  df <- na.omit(df, cols = "word")
  number_docs_words <- c(docs = length(unique(df$doc)), words = length(unique(df$word)))
  yaml::write_yaml(number_docs_words, "study1_number_docs_words.txt")
  # Exclude words
  exclude_terms <- readLines("exclude_terms.txt")
  exclude_these <- unique(unlist(lapply(exclude_terms, grep, x = df$word)))
  
  df <- df[!exclude_these, ]
  
  # Categorize words
  res_cat <- cat_words(df$word, dict, handle_dups = "all")
  # Check coding issues
  #res_cat$dup
  #head(res_cat$unmatched)
  df <- merge_df(df, res_cat$words, "word_coded")
  saveRDS(df, "study1_df.RData")
} else {
  df <- readRDS("study1_df.RData")
  number_docs_words <- yaml::read_yaml("study1_number_docs_words.txt")
}


if(run_everything){
  # Frequency of word by doc
  nounbydoc <- df[, list(freq = .N), by = list(doc_id = doc, term = word_coded)]
  # Set frequency to 1; we're not interpreting word frequency, only occurrence
  nounbydoc$freq <- 1
  
  dtm <- udpipe::document_term_matrix(document_term_frequencies(nounbydoc))
 
  # Continue plotting word frequency ----------------------------------------
  
 
  
  set.seed(5348)
  dtm_top <- dtm[, select_words(dtm, .975)]
  dtm_top <- dtm_top[rowSums(dtm_top) > 0, ]
  write_yaml(dim(dtm_top), "study1_dtm_top.yml")
  
  # Wordcloud ---------------------------------------------------------------
  
  ## Word frequencies
  topterms <- colSums(dtm_top)
  baseline <- readRDS("baseline.RData")
  
  word_freq <- data.frame(Word = names(topterms), Frequency = topterms, row.names = NULL)
  write.csv(word_freq, "study1_word_freq.csv", row.names = FALSE)
  df_plot <- word_freq
  categ <- read.csv("study1_categorization.csv", stringsAsFactors = FALSE)
  df_plot$cat <- categ$category[match(df_plot$Word, categ$name)]
  df_plot$baseline <- as.character(df_plot$Word %in% baseline)
  df_plot$Word <- pretty_words(df_plot$Word)
  
  df_plot <- df_plot[order(df_plot$Frequency, decreasing = TRUE), ]
  df_plot$Word <- ordered(df_plot$Word, levels = df_plot$Word[order(df_plot$Frequency)])
  
  cat_cols <- c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "forestgreen")
  df_plot$cat <- ordered(df_plot$cat, levels = c("Outcome", "Indicator", "Cause", "Protective"))
  
  write_yaml(df_plot$Word, "s1_words.yml")
  
  
  p <- ggplot(df_plot, aes(y = Word, x = Frequency)) +
    geom_segment(aes(x = 0, xend = Frequency,
                     y = Word, yend = Word,
                     colour = baseline),
                 linetype = 2) + geom_vline(xintercept = 0, colour = "grey50",
                                            linetype = 1) + xlab("Word frequency") +
    geom_point(aes(fill = cat), shape = 21, size = 2) +
    scale_colour_manual(values = c("TRUE" = "gray70", "FALSE" = "gray30"))+
    scale_fill_manual(values = c(Outcome = "gray50", Indicator = "tomato", Cause = "gold", Protective = "forestgreen")) +
    scale_x_log10() +
    theme_bw() + theme(panel.grid.major.x = element_blank(),
                       panel.grid.minor.x = element_blank(), axis.title.y = element_blank(),
                       legend.position = c(.70,.125),
                       legend.title = element_blank(),
                       axis.text.y = element_text(hjust=0, vjust = 0, size = 6))
  
  
  svg("s1_varimp.svg", width = 7/2.54, height = 14/2.54)
  eval(p)
  dev.off()
  
  ggsave("s1_varimp.png", p, device = "png", width = 7, height = 14, units = "cm")
  
  df_plot$Frequency <- sqrt(df_plot$Frequency)
  ## Visualise them with wordclouds
  p <- quote({
    set.seed(46)
    wordcloud(words = df_plot$Word, freq = df_plot$Frequency, scale = c(2,.4), max.words = 150, rot.per = 0,  random.order = FALSE, colors = brewer.pal(8, "Dark2"))
  })
  svg("study1_wordcloud.svg")
  eval(p)
  dev.off()
  
  png("study1_wordcloud.png")
  eval(p)
  dev.off()
}

# Co-occurrence -----------------------------------------------------------

#word_cooccurences <- pair_count(df_nouns, group="article.id", value="word.lemma", sort = TRUE)
# create_cooc <- function(dtm){
#   dtm_binary <- dtm > 0
#   Matrix::t(dtm_binary) %*% dtm
# }
# permute <- function(dtm){
#   dtm_perm <- apply(dtm, 2, function(j){ sample(j, length(j))})
#   create_cooc(dtm_perm)
# }
# set.seed(68483)
# perm <- replicate(100, permute(dtm_top))
# q95 <- median(apply(perm, 3, function(k){quantile(k[lower.tri(k)], .95)}))

#cooc <- select_fixed_margin(dtm_top, confidence_boundary = .975, iterations = 100)

if(run_everything){
  cooc <- select_cooc(create_cooc(dtm_top), q = .975)
  
  df_plot <- as_cooccurrence(cooc)
  df_plot <- df_plot[!df_plot$term1 == df_plot$term2, ]
  df_plot <- df_plot[order(df_plot$cooc, decreasing = TRUE), ]
  
  # tt <- as.data.frame(table(word_cooccurences$cooc), stringsAsFactors = FALSE)
  # tt$Frequency <- as.numeric(tt$Var1)
  # tt$Cooc <- tt$Freq
  # ggplot(tt, aes(x=Frequency, y = Cooc))+geom_point() + geom_path()+ geom_text(aes(label= Frequency))+
  #   theme_bw() + scale_y_log10()+scale_x_log10()
  
  #df_plot <- word_cooccurences[word_cooccurences$cooc > q95, ] #.01*nrow(recs), ]
  #df_plot <- word_cooccurences[word_cooccurences$cooc > 22, ] #.01*nrow(recs), ]
  
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
  
  
  # Write study details -----------------------------------------------------
  
  write_yaml(study1details, "study1_details.yml")
  
  
  # Create network ----------------------------------------------------------
  
  # Use EBICglasso
  # cor_mat <- dtm_cor(dtm_top)
  # cor_mat <- (cor_mat+1)/2
  # cor_mat <- cooc
  # 
  # cor_mat[1:5, 1:5]
  # cor_mat[45:50, 45:50]
  # m <- EBICglasso(cor_mat, n = dim(dtm_top)[1], gamma = 0.5, threshold = T, returnAllResults = T)
  # df_plot <- as.data.frame.table(m$optnet, stringsAsFactors = FALSE)
  # names(df_plot) <- c("term1", "term2", "cooc")
  # df_plot <- df_plot[!df_plot$cooc == 0, ]
  # df_plot$id <- apply(df_plot[, c("term1", "term2")], 1, function(x)paste0(sort(x), collapse = ""))
  # df_plot <- df_plot[!duplicated(df_plot$id), ]
  
  
  edg <- df_plot
  # edge_cols <- read.csv("edge_cols.csv", stringsAsFactors = FALSE)
  # if(any(!edg$id %in% edge_cols$id)){
  #   stop("Please classify missing edges.")
  # }
  # edge_cols$color <- "gray70"
  # edge_cols$color[which(edge_cols$association)] <- "navy"
  # edge_cols$color[which(!edge_cols$association)] <- "darkred"
  # edg$color <- edge_cols$color[match(edg$id, edge_cols$id)]
  #edg$col <- sapply(edg$color, function(i){
  #  do.call(rgb, c(as.list(col2rgb(i)), list(alpha = 178, maxColorValue = 255)))
  #})  
  
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
  
  #min_size <- (strwidth(vert$name[max(nchar(vert$name))]) + strwidth("oo")) * 100
  vert$size <- scales::rescale(log(vert$size), c(4, 12))
  g <- graph_from_data_frame(edg, vertices = vert,
                             directed = FALSE)
  #g <- Rsenal::pruneEdg
  #min_size <- (strwidth(vert$label[max(nchar(vert$label))]) + strwidth("oo"))*100
  
  # edge thickness
  E(g)$width <- scales::rescale(sqrt(E(g)$width), to = c(2, 8))
  
  
  dysreg_vertex = which(names(V(g)) == "dysregulation")
  
  edge.start <- ends(g, es=E(g), names = FALSE)[,1]
  edge.end <- ends(g, es=E(g), names = FALSE)[,2]
  E(g)$lty <- c(1, 5)[(!(edge.start == dysreg_vertex|edge.end == dysreg_vertex))+1]
  
  # Other layouts:
  #l <- layout_with_lgl(g, root = which(V(g)$name == "dysregulation"))
  #l <- layout_with_fr(g)
  #l <- layout_(g,with_dh(weight.edge.lengths = edge_density(g)/1000))
  set.seed(2) #4 #2 #3
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
  png("study1_network1.png", width = 960)
  eval(p)
  dev.off()
  
  svg("study1_network1.svg", width = 14)
  eval(p)
  dev.off()
}