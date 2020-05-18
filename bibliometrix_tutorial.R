recs$TI[grepl("THEOR", recs$TI)]
tmp <- recs[recs$TI]
which(duplicated(recs$TI))
recs$TI[(duplicated(recs$TI))]

recs$AB[recs$TI == "FAMILY DYNAMICS AND CHILD OUTCOMES IN EARLY INTERVENTION: THE ROLE OF DEVELOPMENTAL THEORY IN THE SPECIFICATION OF EFFECTS"]

recs$AB[recs$TI == "PEER VICTIMIZATION AND NEUROBIOLOGICAL MODELS: BUILDING TOWARD COMPREHENSIVE DEVELOPMENTAL THEORIES"]


ANXIETY AND DEPRESSION DURING CHILDHOOD AND ADOLESCENCE: TESTING THEORETICAL MODELS OF CONTINUITY AND DISCONTINUITY"

FAMILY DYNAMICS AND CHILD OUTCOMES IN EARLY INTERVENTION: THE ROLE OF DEVELOPMENTAL THEORY IN THE SPECIFICATION OF EFFECTS"

GENERAL STRAIN THEORY, GENDER, AND THE CONDITIONING INFLUENCE OF NEGATIVE INTERNALIZING EMOTIONS ON YOUTH RISK BEHAVIORS

library(bibliometrix)
library(dplyr)
library(igraph)
library(ggraph)

results <- biblioAnalysis(recs, sep = ";")

S <- summary(object = results, k = 10, pause = FALSE)
plot(S$AnnualGrowthRate)

plot(x = results, k = 10, pause = FALSE)

NetMatrix <- biblioNetwork(recs, analysis = "collaboration", network = "authors")
range(NetMatrix)
tmp <- NetMatrix
max_collab <- vector(length = nrow(tmp))
for(i in 1:nrow(tmp)){
  max_collab[i] <- max(tmp[i, -i], na.rm = TRUE)
}
tb <- table(max_collab)
plot(1:length(tb), tb, type = "b")
sum(max_collab > 5)
keep_these <- max_collab > 10
sum(keep_these)
tmp2 <- tmp[keep_these, keep_these]
colnames(tmp2) <- rownames(tmp2) <- gsub(" [A-Z]+?$", "", rownames(tmp2))
set.seed(36478)
authors <- networkPlot(tmp2, n = 93, type = "fruchterman", labelsize = 2, label.cex = TRUE, halo = TRUE, size = 6, size.cex = TRUE, weighted = TRUE, edgesize = 4)
head(authors$graph)
tmp2[1:5, 1:5]

tmp2 %>%
  graph_from_adjacency_matrix() %>%
  ggraph(layout = "fr") +
  geom_edge_link() + #mapping = aes(edge_colour = cooc)
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1.8, col = "darkgreen") +
  ggtitle(sprintf("\n%s", "CETA treaty\nCo-occurrence of nouns")) +
  theme_void()


NetMatrix[1:10, 1:10]
dim(NetMatrix)



CS <- conceptualStructure(recs,field="DE", method="CA", minDegree=4, k.max=8, stemming=TRUE, labelsize=10, documents=10)
saveRDS(CS, "CS.RData")
net		bipartite network
res		Results of CA, MCA or MDS method
km.res		Results of cluster analysis
graph_terms		Conceptual structure map (class "ggplot2")

CS2 <- conceptualStructure(recs,field="ID", method="CA", minDegree=4, clust=5, stemming=FALSE, labelsize=10, documents=10)

