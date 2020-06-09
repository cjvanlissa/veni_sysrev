library(Rmpfr)
library(topicmodels)
library(udpipe)
library(slam)
library(tidytext)
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

#nounbydoc <- df[, list(freq = .N), by = list(doc_id = doc, term = word_coded)]
df_lda <- nounbydoc #[nounbydoc$term %in% names(dict), ]
df_lda <- df_lda %>%
  bind_tf_idf(term, doc_id, freq)
summary(df_lda$tf_idf)
df_lda <- df_lda[order(df_lda$tf_idf),]

select_words <- df_lda[!duplicated(df_lda$term), ]
select_words <- select_words$term[select_words$tf_idf >= median(select_words$tf_idf)]
df_lda <- df_lda[df_lda$term %in% select_words, ]

dtm <- udpipe::document_term_matrix(document_term_frequencies(df_lda))

# dtm <- as.simple_triplet_matrix(dtm)
# dim(dtm)
# summary(col_sums(dtm))
# term_tfidf <- tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(dim(dtm)[1]/col_sums(dtm > 0))
# summary(term_tfidf)

yaml::write_yaml(dim(dtm), file = "Study1_lda_dims.txt")

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

ggsave("study1_entropies.png", p, device = "png")
ggsave("study1_entropies.svg", p, device = "svg")

p <- ggplot(data.frame(K = seqk, ll = ll), aes(x = K, y = ll)) + geom_path() +
  geom_vline(xintercept = (which.max(ll)+1), linetype = 2) +
  xlab('Number of topics') +
  geom_smooth(method = "lm", formula = y~log(x), se = FALSE)+
  theme_bw()

ggsave("study1_ll.png", p, device = "png")
ggsave("study1_ll.svg", p, device = "svg")

p <- ggplot(data.frame(K = seqk, BIC = bics), aes(x = K, y = BIC)) + geom_path() +
  geom_vline(xintercept = (which.min(bics)+1), linetype = 2) +
  xlab('Number of topics') +
  geom_smooth(method = "lm", formula = y~x, se = FALSE)+
  theme_bw()

ggsave("study1_BIC.png", p, device = "png")
ggsave("study1_BIC.svg", p, device = "svg")

