df_tagged <- readRDS("df_tagged.RData")
dft <- rbindlist(df_tagged, use.names = FALSE)

df_sub <- dft[grepl("^VB", word.type), ]

df_sub_sum <- df_sub[, list(freq = .N), by = list(document = thisrow, term = word.lemma)]
df_sub_sum$freq <- 1
dtm <- udpipe::document_term_matrix(document_term_frequencies(df_sub_sum))

topterms <- col_sums(dtm)
topterms <- sort(topterms, decreasing = TRUE)
tt <- table(topterms)
ggplot(data.frame(x = 1:10, y = as.vector(tt[1:10])), aes(x, y)) + geom_point()
head(topterms)
topterms <- topterms[topterms > 10]
topterms <- head(topterms, 250)
topterms <- names(topterms)
tail(topterms)
