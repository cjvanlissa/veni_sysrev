Topic models
================
Caspar J. van Lissa
2/10/2021

This document describes a supplementary analysis related to the studies
described in the document `manuscript.Rmd`.

## Analysis 1: Author keywords

One important step in reviewing the literature is to examine
heterogeneity of the corpus; to analyze empirically whether there is,
for example, a clear divide between psychiatric and developmental texts.
To this end, we conducted topic modeling using latent dirichlet
allocation (Blei, Ng, and Jordan 2003). This is a clustering method for
large sparse matrices.

The corpus for this first analysis consisted of author-provided
keywords. We extracted keywords by document, and applied an exclusion
filter of methodological terms and similar non-substantive words. The
resulting corpus consisted of 5031 documents with 8080 unique terms.

We used the term frequency/inverse document frequency (TF-IDF) to select
terms used frequently in a document, but not used frequently in the
corpus, which could therefore be more diagnostic of subgroup membership.
Selection terms with an TF-IDF greater than the median resulted in a
corpus of 2302 documents and 3118 terms.

We considered a range from 2-20 topics, evaluating fit based on the BIC,
and interpretability based on the entropy of the posterior
document/topic probabilities. As can be seen in Figure
<a href="#fig:figbic">1</a>, the BICs followed a near-perfect linearly
increasing trend, and the simplest model had the lowest BIC, indicating
that no subcorpora could be identified.

<div class="figure">

<img src="study1_BIC.png" alt="Analysis 1: Bayesian Information Criteria (BIC) for LDA models with 2-20 clusters." width="2100" />

<p class="caption">

Figure 1: Analysis 1: Bayesian Information Criteria (BIC) for LDA models
with 2-20 clusters.

</p>

</div>

Congruently, all entropies were near-zero, as seen in Figure
<a href="#fig:figent">2</a>. Entropy reflects the separability of the
extracted clusters. The low entropies observed in this analysis indicate
that the posterior document/topic probabilities were effectively
uniformly distributed. Thus, no subcorpora could be identified, and we
proceeded with an analysis of the whole sample.

<div class="figure">

<img src="study1_entropies.png" alt="Analysis 1: Entropy values for LDA models with 2-20 clusters." width="2100" />

<p class="caption">

Figure 2: Analysis 1: Entropy values for LDA models with 2-20 clusters.

</p>

</div>

## Analysis 2: Abstracts

The corpus for this second analysis consisted of the abstracts of the
selected articles. To perform feature extraction, we first applied the
natural language processing technique “part-of-speech tagging”
(POS-tagging), which identifies a word’s grammatical function within the
sentence context. Because our analysis sought to identify phenomena, we
retained only nouns (to capture terms like “emotion”) and adjectives (to
capture the “mental” in “mental health”). Retaining nouns and adjectives
generally helps derive more interpretable text mining models (Martin and
Johnson 2015). Finally, we used stemming to reduce the retained terms to
their root form. The resulting corpus consisted of 15587 terms in 4414
documents.

To assess the homogeneity of the corpus of abstracts, we again conducted
topic modeling. We selected terms with an TF-IDF greater than the
median, which resulted in a corpus of 7800 terms in 6076 documents.

We considered a range from 2-20 topics, evaluating fit based on the BIC,
and interpretability based on the entropy of the posterior
document/topic probabilities. As can be seen in Figure
<a href="#fig:figbic2">3</a>, the BICs again followed a near-perfect
linearly increasing trend, and the simplest model had the lowest BIC,
indicating that no subcorpora could be identified.

<div class="figure">

<img src="study2_BIC.png" alt="Analysis 2: Bayesian Information Criteria (BIC) for LDA models with 2-20 clusters." width="2100" />

<p class="caption">

Figure 3: Analysis 2: Bayesian Information Criteria (BIC) for LDA models
with 2-20 clusters.

</p>

</div>

Congruently, all entropies were near-zero, as seen in Figure
<a href="#fig:figent2">4</a>. Entropy reflects the separability of the
extracted clusters. The low entropies observed in this analysis indicate
that the posterior document/topic probabilities were effectively
uniformly distributed. Thus, no subcorpora could be identified, and we
proceeded with an analysis of the whole sample.

<div class="figure">

<img src="study2_entropies.png" alt="Analysis 2: Entropy values for LDA models with 2-20 clusters." width="2100" />

<p class="caption">

Figure 4: Analysis 2: Entropy values for LDA models with 2-20 clusters.

</p>

</div>

As before, the BICs followed a linearly increasing trend, and entropies
were near-zero. Thus, no subcorpora were identified, and we proceed with
a whole sample analysis.

# References

<div id="refs" class="references">

<div id="ref-bleiLatentDirichletAllocation2003">

Blei, David M., Andrew Y. Ng, and Michael I. Jordan. 2003. “Latent
Dirichlet Allocation.” *Journal of Machine Learning Research* 3 (Jan):
993–1022. <http://www.jmlr.org/papers/v3/blei03a>.

</div>

<div id="ref-martinMoreEfficientTopic2015">

Martin, Fiona, and Mark Johnson. 2015. “More Efﬁcient Topic Modelling
Through a Noun Only Approach.” In *Proceedings of Australasian Language
Technology Association Workshop*, 111–15.

</div>

</div>
