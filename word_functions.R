shifter <- function(x, n = 1) {
  if (n == 0) x else c(tail(x, -n), head(x, n))
}

boot_dtm_old <- function(dtm, iterations = 1000, confidence_boundary = .95){
  bt <- replicate(iterations, {
    b <- dtm[sample.int(nrow(dtm), replace = TRUE), ]
    colSums(b)
  })
  interesting <- rowSums(bt > 0)
  cb <- confidence_boundary * iterations
  interesting > cb
}

boot_dtm <- function(dtm, iterations = 100, confidence_boundary = .95){
  cb <- confidence_boundary * iterations
  m_logical <- dtm > 0
  interesting <- vector(length = ncol(dtm))
  len <- nrow(dtm)
  for(j in 1:ncol(dtm)){
    interesting[j] <- sum(replicate(iterations, {
        any(sample(m_logical[, j], len, replace = TRUE))
      })) > cb
  }
  
}

library(fitdistrplus)
select_words <- function(dtm, q = .95){
  d <- colSums(dtm)
  fit <- fitdist(d, "nbinom")
  thres <- qnbinom(q, size=fit$estimate["size"], mu=fit$estimate["mu"])
  return(d > thres)
}

select_cooc <- function(cooc, q = .95){
  mat.summ   <- summary(cooc)
  mat.summ <- mat.summ[!mat.summ$i == mat.summ$j, ]
  lower.summ <- subset(mat.summ, i >= j)
  fit <- fitdist(lower.summ$x, "nbinom")
  thres <- qnbinom(q, size=fit$estimate["size"], mu=fit$estimate["mu"])
  lower.summ <- lower.summ[!lower.summ$x < thres, ]
  out <- sparseMatrix(i = lower.summ$i,
               j = lower.summ$j,
               x = lower.summ$x,
               dims = dim(cooc), symmetric = TRUE)
  rownames(out) <- rownames(cooc)
  colnames(out) <- colnames(cooc)
  is_zero <- rowSums(out) == 0
  out <- out[!is_zero, !is_zero]
  attr(out, "thres") <- thres
  return(out)
}

create_cooc <- function(dtm){
  dtm_binary <- dtm > 0
  Matrix::t(dtm_binary) %*% dtm
}

net_dens <- function(cooc){
  potential_connections <- dim(cooc)[1]*(dim(cooc)[2]-1)/2
  sum(cooc[lower.tri(cooc)] > 0) / potential_connections
}

library(RaschSampler)
library(abind)
select_fixed_margin <- function(dtm, confidence_boundary = .95, iterations = 100){
  out <- create_cooc(dtm)
  diag(out) <- 0
  if(!exists(".Random.seed")) set.seed(NULL)
  rand_seed <- .Random.seed[1]
  ctr <- rsctrl(burn_in=10, n_eff=iterations, step=10, seed=rand_seed, tfixed=FALSE)
  mat <- RaschSampler::rsampler(as.matrix(dtm), ctr)
  mat <- lapply(1:mat$n_eff, function(i) rsextrmat(mat, i))
  
  coocs <- lapply(mat, function(x){ 
    g <- create_cooc(x)
    diag(g) <- 0
    g
  })
  coocs <- do.call(abind,c(coocs,list(along=3)))
  
  bounds <- apply(coocs, c(1,2), function(k){quantile(k, confidence_boundary)})
  
  out[!out > bounds] <- 0
  out
}

pretty_words <- function(x){ 
  out <- str_to_sentence(gsub("[_-]", " ", x))
  out[out == "Adhd cd"] <- "ADHD/CD"
  out[out == "Ses"] <- "SES"
  out[out == "Ptsd"] <- "PTSD"
  out[out == "Schizo"] <- "Schizophrenia"
  out <- gsub("^Par\\.", "Parenting ", out)
  out
}


conflicting_matches <- function(words, dict){
  dict_matches <- lapply(unlist(dict), function(this_reg){
    grep(this_reg, words)
  })
  names(dict_matches) <- unlist(dict)
  
  tmp <- unlist(dict_matches)
  dups <- unique(tmp[duplicated(tmp)])
  dup_words <- words[dups]
  dups <- dups[!duplicated(dup_words)]
  dup_words <- words[dups]
  if(length(dups)){
    out <- lapply(dups, function(this_dup){
      names(dict_matches)[sapply(dict_matches, `%in%`, x = this_dup)]
    })
    names(out) <- dup_words
    out
  }
}
unmatched <- function(words, dict){
  dict_matches <- lapply(unlist(dict), function(this_reg){
    grep(this_reg, words)
  })
  sort(table(words[c(1:length(words))[-unique(unlist(dict_matches))]]), decreasing = TRUE)
}

count_fun <- function(x) rowSums(x)>0

cat_internal <- function(words, dict){
  dict <- dict[order(names(dict))]
  rexes <- unlist(dict)
  reps <- sapply(dict, length)
  new_name <- rep(names(dict), times = reps)
  dict_matches <- sapply(rexes, function(this_reg){
    grepl(this_reg, words, perl = TRUE)})
  matches <- as.data.table(dict_matches)
  dropthese <- vector("numeric")
  for(this_name in names(dict)){
    sum_cols <- which(new_name == this_name)
    if(length(sum_cols) > 1){
      matches[, (this_name) := count_fun(.SD), .SDcols=sum_cols]
      dropthese <- append(dropthese, sum_cols)
    }
  }
  matches[, (dropthese):=NULL]  
  setcolorder(matches, names(dict))
  matches
}

cat_words2 <- function(words, dict, resolve_dups){
  dict <- dict[order(names(dict))]
  resolve_dups <- dict[order(names(resolve_dups))]
  rexes <- unlist(dict)
  matches <- cat_internal(words, dict)
  num_matches <- rowSums(matches)
  onematch <- which(num_matches == 1)
  outwords <- words
  outwords[onematch] <- names(dict)[apply(matches[onematch, ] == 1, 1, which)]
  out <- list(
    words = outwords
  )
  if(any(num_matches > 1)){
    match_dups <- cat_internal(words[num_matches > 1], resolve_dups)
    num_dup_matches <- rowSums(match_dups)
    onematch <- which(num_dup_matches == 1)
    out$words[num_matches > 1][onematch] <- colnames(match_dups)[apply(match_dups[onematch, ], 1, which)]
    if(any(num_dup_matches > 1)){
      warning("Duplicate matches found")
      dups <- unique(words[num_matches > 1][num_dup_matches > 1])
      out_dups <- lapply(dups, function(x){
        tmp <- which(words == x)[1]
        unname(rexes[dict_matches[tmp, ]])
      })
      names(out_dups) <- dups
      out$dup <- out_dups
    }
    
  }
  if(any(num_matches == 0)){
    warning("Unmatched words found")
    nomatch <- which(num_matches == 0)
    tab <- table(words[nomatch])
    out$unmatched <- sort(tab, decreasing = TRUE)
  }
  out
}

cat_words_22_3_2020 <- function(words, dict){
  dict_order <- names(dict) # I'm saving these names to preserve the order, so I can sequentially match terms
  dict <- dict[order(names(dict))] # Maybe skip this? And just save the order instead
  rexes <- unlist(dict)
  reps <- sapply(dict, length)
  new_name <- rep(names(dict), times = reps)
  dict_matches <- sapply(rexes, function(this_reg){
    grepl(this_reg, words, perl = TRUE)})
  matches <- as.data.table(dict_matches)
  dropthese <- vector("numeric")
  for(this_name in names(dict)){
    sum_cols <- which(new_name == this_name)
    if(length(sum_cols) > 1){
      matches[, (this_name) := count_fun(.SD), .SDcols=sum_cols]
      dropthese <- append(dropthese, sum_cols)
    }
  }
  matches[, (dropthese):=NULL]  
  setcolorder(matches, names(dict))
  num_matches <- rowSums(matches)
  onematch <- which(num_matches == 1)
  outwords <- words
  outwords[onematch] <- names(dict)[apply(matches[onematch, ] == 1, 1, which)]
  out <- list(
    words = outwords
  )
  if(any(num_matches > 1)){
    warning("Duplicate matches found")
    dups <- unique(words[num_matches > 1])
    out_dups <- lapply(dups, function(x){
      tmp <- which(words == x & num_matches > 1)[1]
      unname(rexes[dict_matches[tmp, ]])
    })
    names(out_dups) <- dups
    out$dup <- out_dups
  }
  if(any(num_matches == 0)){
    warning("Unmatched words found")
    nomatch <- which(num_matches == 0)
    tab <- table(words[nomatch])
    out$unmatched <- sort(tab, decreasing = TRUE)
  }
  out
}
abstract_by_keyword <- function(keyword){
  these_docs <- df$doc[which(df$word == keyword)]
  print(unique(these_docs))
  for(i in unique(these_docs)){
    print(recs$AB[i])
    readline(prompt="Press [enter] to continue")
  }
}

# The order of the dictionary matters: Words are replaced by the first match in
# the dictionary. So more important categories should be listed first.
words <- c("aa", "ab", "cc", "bb")
words <- c("bb", "ba", "aa", "ab", "cc", "bb")
dict <- list(a = "a", b = "b")

# words <- c("aa", "ab", "cc", "bb")
# dict <- list(a = "a", b = "b")
# tmp <- cat_words(words, dict)
# cbind(words, tmp$words)
# dict <- dict[2:1]
# tmp <- cat_words(words, dict)
# cbind(words, tmp$words)
# words <- c("bb", "ba", "aa", "ab", "cc", "bb")
# tmp <- cat_words(words, dict)
# cbind(words, tmp$words)
# dict <- dict[2:1]
# tmp <- cat_words(words, dict)
# cbind(words, tmp$words)
# words <- df$word[56:(56+10)]

cat_words <- function(x, dict, handle_dups = c("first", "all", "random"), ...){
  UseMethod("cat_words", x)
}

cat_words.data.frame <- function(x, dict, handle_dups = c("first", "all", "random"), column = "word", ...){
  Args <- as.list(match.call()[-1])
  Args$x <- x[[column]]
  categorized <- do.call(cat_words, Args)
  if(is.list(out)){
    
  } else {
    
    return()
  }
}

cat_words.character <- function(x, dict, handle_dups = c("first", "all", "random"), ...){
  rexes <- unlist(dict)
  words <- x
  #new_name <- rep(names(dict), times = reps)
  dict_matches <- sapply(rexes, function(this_reg){
    grepl(this_reg, words, perl = TRUE)})
  if(is.null(dim(dict_matches))) dict_matches <- t(dict_matches)
  matches <- matrix(FALSE, nrow = length(words), ncol = length(dict))
  reps <- c(0, sapply(dict, length))
  for(dict_item in 1:length(dict)){
    sum_cols <- (sum(reps[1:dict_item])+1):sum(reps[1:(dict_item+1)])
    matches[, dict_item] <- apply(dict_matches[, sum_cols, drop = FALSE], 1, any)
  }
  
  num_matches <- rowSums(matches)
  has_matches <- !num_matches == 0
  which_matches <- which(has_matches)
  outwords <- words
  outwords[has_matches] <- switch(handle_dups[1],
                                  first = apply(matches[which_matches, ], 1, function(lv){names(dict)[min(which(lv))]}),
                                  random = apply(matches[which_matches, ], 1, function(lv){names(dict)[sample(which(lv), 1)]}),
                                  apply(matches[which_matches, ], 1, function(lv){names(dict)[which(lv)]})
                     )
  
  out <- list(
    words = outwords
  )
  multimatch <- num_matches > 1
  if(any(multimatch)){
    message("Duplicate matches found; see the '$dup' element of the output.")
    dups <- unique(words[multimatch])
    out_dups <- lapply(dups, function(this_dup){
      these_matches <- which(words == this_dup & multimatch)[1]
      unname(rexes[dict_matches[these_matches, ]])
    })
    names(out_dups) <- dups
    out$dup <- out_dups
  }
  if(any(!has_matches)){
    message("Unmatched words found; see the '$unmatched' element of the output.")
    nomatch <- which(!has_matches)
    tab <- table(words[nomatch])
    out$unmatched <- sort(tab, decreasing = TRUE)
  }
  class(out) <- c("word_matches", class(out))
  out
}

# x <- list(v1 = letters[1:3],
#           v2 = LETTERS[1:3],
#           v3 = list(c("a", "A"), c("b"), c("c", "C")),
#           v4 = list(c("a"), c("b", "1"), c("c", "1")))
merge_df <- function(df, words, col_name = "word_coded", ...){
  if(!is.data.table(df)) df <- data.table(df)
  if(!nrow(df) == length(words)) stop("Length of 'df' must be identical to that of 'words'.")
  reps <- sapply(words, length)
  out <- df[rep(1:nrow(df), times = reps), ]
  out[, (col_name) := unlist(words)]
  return(out)
}
