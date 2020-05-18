# Create an edge list: a list of connections between 10 origin nodes, and 10 destination nodes:
origin <- paste0("dest ", sample(c(1:10), 20, replace = T))
destination <- paste0("dest ", sample(c(1:10), 20, replace = T))
data <- data.frame(origin, destination)
head(data)

# Transform input data in a adjacency matrix
adjacencyData <- with(data, table(origin, destination))

# Charge the circlize library
library(circlize)
head(adjacencyData)
# Make the circular plot
chordDiagram(adjacencyData, transparency = 0.5)

df_chord <- word_cooccurences
df_chord <- df_chord[!(df_chord$term1 == "youth" | df_chord$term2 == "youth"),]

df_chord <- reshape2::dcast(df_chord, term1~term2)[, -1]
df_chord[is.na(df_chord)] <- 0
df_chord <- as.matrix(df_chord)
rownames(df_chord) <- colnames(df_chord)
plot(1:length(table(df_chord)), table(df_chord))
df_chord[df_chord < 4] <- 0
chordDiagram(df_chord, transparency = 0.5)

chordDiagram(df_chord, annotationTrack = "grid", #grid.col = grid.col, 
             preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(df_chord))))))
# we go back to the first track and customize sector labels
circos.track(track.index = 1, panel.fun = function(x, y) {
  circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
              facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
}, bg.border = NA) # here set bg.border to NA is a