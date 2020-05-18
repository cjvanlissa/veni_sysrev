rayyan <- read.csv("articles.csv")
rayyan <- rayyan[, c("key", "notes")]
if(all(rayyan$key == unique_recs$id_num)){
  unique_recs$rayyan <- NA
  unique_recs$rayyan[rayyan$notes == " RAYYAN-INCLUSION: {\"Caspar\"=>\"Included\"}"] <- TRUE
  unique_recs$rayyan[rayyan$notes == " RAYYAN-INCLUSION: {\"Caspar\"=>\"Excluded\"}"] <- FALSE
} else {
  stop("Rayyan and R id numbers did not match")
}
# Include papers for ASReview
write.table(paste(unique_recs$id_num[which(unique_recs$rayyan)]-1, collapse = " "), "clipboard", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Exclude papers for ASReview
write.table(paste(unique_recs$id_num[which(!unique_recs$rayyan)]-1, collapse = " "), "clipboard", quote = FALSE, row.names = FALSE, col.names = FALSE)

