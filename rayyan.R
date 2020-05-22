if(!tools::md5sum("unique_recs.csv") == "90be8ba1f40442f2aa3a7c82ba3e5ad0"){
  unique_recs <- readRDS("unique_recs.RData")
  rayyan <- read.csv("rayyan_exports/articles.csv")
  names(rayyan)[which(names(rayyan) %in% names(unique_recs))] <- paste0(names(rayyan)[which(names(rayyan) %in% names(unique_recs))], "ray")
  unique_recs[names(rayyan)] <- NA
  unique_recs[names(rayyan)][rayyan$key, ] <- rayyan
  unique_recs$excluded_rayyan <- is.na(unique_recs$key)
  if(!sum(unique_recs$excluded_rayyan) == 13) stop("Number of deleted records not the same as in Rayyan")
  
  unique_recs$rayyan <- NA
  unique_recs$rayyan[unique_recs$notes == " RAYYAN-INCLUSION: {\"Caspar\"=>\"Included\"}"] <- TRUE
  unique_recs$rayyan[unique_recs$notes == " RAYYAN-INCLUSION: {\"Caspar\"=>\"Excluded\"}"] <- FALSE
  if(!(sum(unique_recs$rayyan, na.rm = TRUE) == 367 & sum(!unique_recs$rayyan, na.rm = TRUE) == 192)) stop("Number of included/excluded records not the same as in Rayyan")
  write.csv(unique_recs, "unique_recs.csv", row.names = FALSE)
}


# Include papers for ASReview
index_from_0 <- TRUE
include_papers <- unique_recs$key[which(unique_recs$rayyan)] + c(0, -1)[index_from_0+1]
exclude_papers <- unique_recs$key[which(!unique_recs$rayyan)] + c(0, -1)[index_from_0+1]

# Write include papers to clipboard for ASReview
write.table(paste(include_papers, collapse = " "), "clipboard", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Write exclude papers to clipboard for ASReview
write.table(paste(exclude_papers, collapse = " "), "clipboard", quote = FALSE, row.names = FALSE, col.names = FALSE)

