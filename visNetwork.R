# Libraries ---------------------------------------------------------------
library(visNetwork)
library(geomnet)
library(igraph)

# Data Preparation --------------------------------------------------------

#Nodes
df_plot <- df_plot2

df_plot$cooc <- scales::rescale(df_plot$cooc, from = range(df_plot$cooc), to = c(1, 10))
nodes <- unique(c(df_plot$term1, df_plot$term2))
nodes <- data.frame(id = nodes, label = nodes, stringsAsFactors = FALSE)
#id has to be the same like from and to columns in edges

#Edges
edges <- df_plot
colnames(edges) <- c("from", "to", "width")

#Create graph for Louvain
graph <- graph_from_data_frame(edges, directed = FALSE)

#Louvain Comunity Detection
cluster <- cluster_louvain(graph)

cluster_df <- data.frame(as.list(membership(cluster)))
cluster_df <- as.data.frame(t(cluster_df))
cluster_df$label <- rownames(cluster_df)

#Create group column
nodes <- dplyr::left_join(nodes, cluster_df, by = "label")
colnames(nodes)[3] <- "group"

visNetwork(nodes, edges) %>%
  visPhysics(solver = "repulsion", barnesHut = list(gravitationalConstant = -20000)) %>%
  visSave(file = "tmp.html")

visNetwork(nodes, edges) %>%
  visPhysics(solver = "forceAtlas2Based", forceAtlas2Based = list(gravitationalConstant = -50))