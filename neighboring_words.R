neighboring_words <- function(words, pattern, position = +1){
  where_word <- grep(pattern, words)
  tb <- table(words[(where_word+position)])
  sort(tb, ddecreasing = TRUE)
}
neighboring_words(words = df_nouns$word.lemma, pattern = "substance")
neighboring_words(words = df_nouns$word.lemma, pattern = "use", -1)
neighboring_words(words = df_nouns$word.lemma, pattern = "regulation", -1)
grep("(ab|mis|)use$", df_nouns$word.lemma, value = TRUE)

grep("auti", df_nouns$word.lemma, value = T)



neighboring_words(words = dft$word, pattern = "activity", -1)
neighboring_words(words = dft$word.lemma, pattern = "problem")
