fuzzy_dedup <- function(txt, threshold = 5, labs = txt){
  UseMethod("fuzzy_dedup", txt)
}

fuzzy_dedup.character <- function(txt, threshold = 5, labs){
  cl <- as.list(match.call()[-1])
  cl$txt <- stringdistmatrix(txt)
  cl$labs <- txt
  do.call(fuzzy_dedup, cl)
}

fuzzy_dedup.matrix <- function(txt, threshold = 5, labs){
  tmp <- txt < threshold
  tmp <- rowSums(tmp)
  dups <- which(tmp > 1)
  if(any(dups)){
    sim_dups <- txt[dups, ]
    remove_these <- NULL
    for(this_ref in 1:length(dups)){
      potential_matches <- which(sim_dups[this_ref, ] < threshold)
      for(i in 1:length(dups)){
        
      }
      cat(labs[dups[which(sim_dups[, this_group]  < threshold)]], sep = "\n")
      user_response <- readline("All the same: 1\nNot the same: 2")
      if(user_response == "1"){
        remove_these <- c(remove_these, dups[which(sim_dups[, this_group]  < threshold)][-1])
      } else {
        user_response <- readline("Which elements should be preserved?")
        remove_these <- c(remove_these, dups[which(sim_dups[, this_group]  < 5)][-c(1,as.numeric(strsplit(user_response, ",")[[1]]))])
      }
    }
  } else {
    cat("No duplicates found.")
  }
}
