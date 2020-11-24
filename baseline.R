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
run_everything = TRUE
dict <- read_yaml("yaml_dict.txt")
## Look at POS tags?
if(run_everything){
  recs <- readLines("concepts_review.txt")
  df <- data.frame(word = trimws(tolower(recs)))
  
  # Categorize words
  res_cat <- cat_words(df$word, dict, handle_dups = "all")
  baseline <- c("dysregulation", unique(res_cat$words))
  saveRDS(baseline, "baseline.RData")
} else {
  baseline <- readRDS("baseline.RData")
}


df_plot <- data.frame(term1 = baseline, term2 = "dysregulation")

edg <- df_plot

edg$width = 1

vert <- data.frame(name = baseline, label = pretty_words(baseline), size = 1)
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
#E(g)$width <- scales::rescale(sqrt(E(g)$width), to = c(2, 8))



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
png("baseline_network.png", width = 960)
eval(p)
dev.off()

svg("baseline_network.svg", width = 14)
eval(p)
dev.off()