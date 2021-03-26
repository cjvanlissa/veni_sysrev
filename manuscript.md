---
title             : "Mapping Correlates of Adolescent Emotion Dysregulation: A Text-mining Systematic Review"
shorttitle        : "ADOLESCENT EMOTION REGULATION"

author: 
  - name          : "Caspar J. van Lissa"
    affiliation   : "1"
    corresponding : yes    # Define only one corresponding author
    address       : "Padualaan 14, 3584CH Utrecht, The Netherlands"
    email         : "c.j.vanlissa@uu.nl"

affiliation:
  - id            : "1"
    institution   : "Utrecht University faculty of Social and Behavioral Sciences, department of Methodology & Statistics"

authornote: |
  This work is supported by a NWO Veni grant (NWO
  grant number VI.Veni.191G.090). Acknowledgement: Lukas Beinhauer contributed
  substantially to the screening of articles. Conflicts of Interest: None.
  

abstract: |
  Adolesence is a developmentally sensititve period for emotion regulation
  with potentially lifelong implications for mental health and well-being.
  Although substantial empirical research has addressed this topic, the
  literature is fragmented across subdisciplines, and an overarching
  theoretical framework is lacking. The first step toward constructing a
  unifying framework is identifying relevant phenomena. This systematic
  review of 6305 papers used text mining to identify phenomena relevant to
  adolescents' emotion regulation. First, a baseline was established of
  relevant phenomena discussed in theory and recent narrative reviews. Then,
  article keywords and abstracts were analyzed using text mining,
  examining term frequency as an indicator of relevance and term
  co-occurrence as an indicator of association. The results reflected themes
  commonly featured in theory and narrative reviews, such as socialization
  and neurocognitive development, but also identified undertheorized themes,
  such as developmental disorders, physical health, external stressors,
  structural disadvantage, substance use, identity and moral development, and
  sexual development. The findings illustrate how text mining systematic
  reviews, a novel approach, may complement narrative reviews. Future
  theoretical work might integrate these undertheorized themes into
  an overarching framework, and empirical research might consider them as
  promising areas for future research, or as potential confounders in research
  on adolescents' emotion regulation.

keywords          : "emotion regulation, adolescence, systematic review, text mining, machine learning"
bibliography      : ["veni_sysrev.bib"]
floatsintext      : no
figurelist        : no
tablelist         : no
footnotelist      : no
linenumbers       : no
mask              : no
draft             : no
documentclass     : "apa6"
classoption       : "man,noextraspace"
output:
  papaja::apa6_pdf: default
  papaja::apa6_docx: default
knit              : worcs::cite_essential
header-includes:
  - \raggedbottom
---


<!-- Reviewer suggestions:
Kristin Buss -->


```r
# Seed for random number generation
set.seed(42)
knitr::opts_chunk$set(cache.extra = knitr::rand_seed, echo = FALSE, message = FALSE, warning = FALSE, results="hide")
```

Adolescence is a developmentally sensitive period for emotion regulation [@zimmermannEmotionRegulationEarly2014]. 
<!--Adolescents experience biological, cognitive, and social changes that prompt new emotional
experiences and tax regulatory abilities [@steinbergAgeOpportunityLessons2014].
These coalescing changes temporarily restrict adolescents' capacity for emotion regulation 
[@zimmermannEmotionRegulationEarly2014],
resulting in more frequent and intense (negative) emotions [see @silkAdolescentsEmotionRegulation2003].-->
Although most adolescents successfully develop mature emotion regulation abilities,
as many as one in five develop psychopathology [@leeAdolescentMentalHealth2014]
with roots in emotion regulation difficulties
[@aldaoEmotionregulationStrategiesPsychopathology2010;
@@schaferEmotionRegulationStrategies2017].
Given the prevalence of emotion regulation difficulties in adolescence,
their implications for mental health<!--and social functioning [@braetEmotionRegulationChildren2014]; @reindlSocializationEmotionRegulation2016]-->
and downstream cost to society,
it is important to have a comprehensive overview of the factors associated with adolescents' emotion regulation.
<!--Of particular interest are potential risk factors that render some youth susceptible to emotion regulation difficulties.-->
Despite the abundance of publications in this field,
it is difficult to obtain a comprehensive understanding of emotion regulation in adolescence [@riedigerEmotionRegulationAdolescence2014]:
Different (sub)disciplines have approached the topic in disparate ways [@riedigerEmotionRegulationAdolescence2014],
without consistent terminology [@bariolaChildAdolescentEmotion2011], conceptual frameworks [@stifterEmotionRegulation2019], or an overarching theoretical framework
[@bussTheoriesEmotionalDevelopment2019].
This has prompted calls for the integration of knowledge across research areas [@riedigerEmotionRegulationAdolescence2014] and consolidation of empirical research into overarching theory [e.g., @bussTheoriesEmotionalDevelopment2019].
Formal methods for theory construction state that the first step in this endeavor is to identify well-established relevant *empirical phenomena*,
defined as stable and general features of the world [@borsboomTheoryConstructionMethodology2020; @@bogenSavingPhenomena1988].
This study used a text mining systematic review to provide a comprehensive map of the empirical phenomena relevant to adolescent emotion regulation.

Despite recent interest in theory construction method,
few specific techniques exist for identifying relevant phenomena, aside from expert opinion [@borsboomTheoryConstructionMethodology2020].
This paper argues that systematic reviews are a suitable method for quantifying which phenomena experts consider to be relevant.
Traditional narrative reviews are limited, however, by small convenience samples,
confirmation bias,
and an undue emphasis on positive results [@littellEvidencebasedBiasedQuality2008].
This paper aims to overcome these limitations by adopting a novel method:
the text mining systematic review (TMSR).
Relative to narrative reviews, text mining can cover arbitrarily greater corpora,
and gleans insights from the literature by means of a more transparent and reproducible process.
<!--Where sentient readers tend to structure their reading of the literature around established ideas [@littellEvidencebasedBiasedQuality2008],
the inherent "fairness" of text mining gives emerging themes a chance to come to the fore.-->
This approach assumes the frequency with which phenomena recur in the literature to be indicative of their relevance.
If it is additionally assumed that the frequency with which phenomena are studied together is indicative of the extent to which researchers believe them to be associated,
then the co-occurrence of phenomena within publications can be interpreted as a rudimentary nomological network: a mapping of relationships between theoretically relevant phenomena [see @alaviAligningTheoryMethodology2018].
This network can serve as a starting point for the formulation of a proto-theory,
which would additionally involve abductive reasoning: specifying putative mechanisms to explain associations between the phenomena [@borsboomTheoryConstructionMethodology2020].
By mapping the phenomena relevant to adolescent emotion regulation,
the present work thus lays the groundwork for future theory development.

<!--
stifterEmotionRegulation2019
* call for studies incorporating predictors of ER across multiple levels of analysis
* different conceptual frameworks

riedigerEmotionRegulationAdolescence2014
* difficulty in deriving a cohesive picture about emotion regulation in adolescence
* different conceptual frameworks

* three themes (neurocognitive development, socialization, interplay between internal and external factors) currently represent relatively independent bodies of research
* A more explicit integration of these various research perspectives will help us to arrive at a more integrated and interpretable picture of the development of emorion regulation during adolescence. 

@bussTheoriesEmotionalDevelopment2019

* emotional development theory is still in its own state of development. 
* empirical evidence can contribute to theory development.

@bariolaChildAdolescentEmotion2011
* Further research apply reﬁned theoretical conceptualizations of ER.


Where sentient readers tend to structure their reading of the literature around established ideas [@littellEvidencebasedBiasedQuality2008],
This potentially reveals phenomena and associations missed by narrative reviewers,
thereby laying the groundwork for future empirical and theoretical work.


we set out to map these relevant empirical phenomena using a systematic review.


generate a proto-theoretical nomological network of the relevant empirical phenomena.
We discuss how this nomological network relates to existing relevant theory, and conclude
with recommendations for future theory-generating efforts.
There have been calls for the  consolidation of these disparate insights into overarching theory would be an important step forward.
An important first step 
and intrinsic limitations of narrative reviews prohibit comprehensive coverage of the vast but diffuse literature .-->
<!--
Recent years have seen the publication of several excellent systematic reviews,
but these have all been narrative reviews.-->

 <!-- CJ To fill out gaps, following up on promising constructs and unify heretofore disparate regions of the lit -->
<!-- SH: this implies that the main contribution of the paper is predominantly methodological is that the case? Is there some primary thesis/argument that will be advanced? It is really important to take a top-down approach to that messaging, beginning here in the first paragraph-->
<!-- Ergens anders: Similarly, although
there are several *relevant* theories, there is no specific theoretical
framework to guide research on adolescents' emotion regulation. Although theory
development is beyond the scope of this paper, we set out to generate a
proto-theoretical nomological network of the potential risk factors,
manifestations, and outcomes of emotion regulation in adolescence. We discuss
how this nomological network relates to existing relevant theory, and conclude
with recommendations for future theory-generating efforts.-->
<!-- At the same time, the staggered development of motivational-emotional and regulatory brain circuits gives rise
to a maturity gap [@croneUnderstandingAdolescencePeriod2012]. 
This leads youngsters to pursue new experiences in life and love,
without being fully prepared to cope with the emotional outcomes. --> 

<!--The literature thus paints a picture of
adolescence as a chrysalis for emotional development: Children enter this stage
with emotion regulation skills adapted to the challenges of childhood. During
adolescence, emotional systems are rearranged substantially.-->

<!--
* intense negative emotions in daily life (Silk, Steinberg, & Morris, 2003) 
* unstable peer or romantic relationships (Furman & Collins, 2009)
* decrease in perceived support from parents (Furman & Buhrmester, 1992).
* early adolescence is characterized by a higher rate of conflicts with parents (Laursen, Coy, & Collins, 1998)
* higher variability of negative emotions compared to late adolescence (Larson, Moneta, Richards, & Wilson, 2002).
* relative to other developmental stages, adolescence involves a particularly large number of transitions, novel situations, and new stimuli, physical, cognitive, emotional, and social development—particularly in early and mid-adolescence (Seiffge-Krenke, 2000)
-->

## Existing theoretical landscape



<img src="baseline_network.png" title="Phenomena relevant to adolescents' emotion regulation according to theory (A) and narrative reviews (B; transparent circles indicate constructs also present in the theory)." alt="Phenomena relevant to adolescents' emotion regulation according to theory (A) and narrative reviews (B; transparent circles indicate constructs also present in the theory)." width="100%" />


Although it has been argued that there is a paucity of theories *specific to* adolescent emotion regulation,
many *relevant* theories are commonly invoked in empirical work [see  @bussTheoriesEmotionalDevelopment2019].
In order to contextualize the results of the present systematic review
and assess to what extent the identified phenomena through text mining mirror or complement existing theory,
a brief review of the existing theoretical landscape is provided.
Others have published more detailed reviews of theories of emotional development [@bussTheoriesEmotionalDevelopment2019] and emotion regulation in adolescence [@riedigerEmotionRegulationAdolescence2014].
In reading the theoretical literature,
relevant phenomena were documented, along with whether these were discussed as putative causes, outcomes, indicators, or protective factors in relation to emotion regulation.
The left panel of Figure \@ref(fig:figbaseline) visually summarizes the phenomena discussed in the theoretical literature, using a style similar to the subsequent systematic review,
in order to contextualize the original contributions of this approach.
<!-- 
Our text mining analysis of the phenomena empirical literature is best understood against a backdrop of -->

Two of the most general theories invoked to frame developmental research are the bioecological model [@bronfenbrennerBioecologicalModelHuman2007], and the transactional model [@sameroffUnifiedTheoryDevelopment2010].
The bioecological model describes how the environment
shapes individual development.
At the individual level, every person is imbued with biological predispositions,
and develops over time in interaction with contextual influences.
The most immediate source of contextual influences is the microsystem,
composed of people close to the individual.
Other influences stem from the macrosystem, consisting of political and economic influences,
and the exosystem, consisting of cultural norms and values.
The transactional model [@sameroffUnifiedTheoryDevelopment2010] is compatible with the bioecological model,
but places a stronger emphasis on development as a product of reciprocal influences between child and environment.
The transactional model distinguishes between proximal influences, which roughly correspond to the microsystem in the bioecological model, and distal influences, which derive from
structural factors indirectly shaping development, like socio-economic status,
schools, and the community (macro- and exosystem).
With increasing age, distal influences gain ground on proximal influences.
These two theories have a broader scope than most.
This means that they can be invoked to contextualize any developmental study,
but lack specificity - a shortcoming that curtails a theory's utility in generating hypotheses.
Domain-specific theories, by comprarison, offer greater specificity.

Among the oldest domain-specific theories of adolescents' emotional development is Hall's notion of "storm and stress" [see
@arnettAdolescentStormStress1999].
It describes how hormonal changes diminish self-control and increase reactivity, which in turn leads to emotion
regulation difficulties, increased conflict with parents, and risky behavior.
This notion of diminished self-control and increased emotional reactivity still persists in modern theory, but is increasingly recast as a normative change that facilitates emotional maturation at the risk of emotional
disturbance [@arnettAdolescentStormStress1999; @@leeAdolescentMentalHealth2014; @@croneUnderstandingAdolescencePeriod2012] 
A potential limitation of the notion of storm and stress is that it considers emotion regulation difficulties to be part of normative development, and thus underemphasizes adolescents' diverging destinies [cf. @croneUnderstandingAdolescencePeriod2012].
<!--SH I am still not sure what the empirical contribution is - can you be more specific with it in this sentence? -->
<!--Several recent publications have undertaken the
monumental task of providing a comprehensive overview of theories of emotional
development [e.g., @bussTheoriesEmotionalDevelopment2019;
@holodynskiDevelopmentEmotionsEmotion2006;
@riedigerEmotionRegulationAdolescence2014], and of the empirical work
pertaining to emotions in adolescence
[@coe-odessEmergentEmotionsAdolescence2019].  -->

One theory of normative emotional development [@sroufeEmotionalDevelopmentOrganization1995] focuses on developmental influences to a greater extent.
This theory posits that, as children grow older,
their increasing self-regulatory abilities
drive a transition from external emotion regulation by primary caregivers
toward autonomous emotion regulation.
This theory focuses on two drivers of
development: social and cognitive influences. 
Social influences mainly occur
through parental co-regulation, parenting behaviors, and parent-child
attachment. Cognitive influences occur through the development of the central
nervous system (CNS), cognition, and self-regulation.
This theory's relevance for adolescent research may be diminished by its focus on early childhood,
although there is substantial continuity in developmental influences throughout childhood and adolescence.
For instance, there is substantial similarity between mothers' and fathers' unique roles in emotional development in childhood [@vanlissaMothersFathersQuantitative2020] and adolescence [@vanlissaRoleFathersMothers2019].
In terms of level of analysis, the scope of Sroufe's and Hall's theories corresponds approximately to the individual and the microsystem in the ecological model [@bronfenbrennerBioecologicalModelHuman2007].
The emphasis on socialization and neurocognitive development as two drivers of emotional development, which is evident from both theories,
is the focus of several theories with a narrower scope.

Among theories focused on socialization, the tripartite model [@morrisRoleFamilyContext2007] is widely cited.
This theory describes three pathways through which parents shape emotion regulation
development: modeling, parenting practices, and the
emotional family climate,
which subsumes attachment and marital relationship quality.
This theory focuses parents, acknowledging unique contributions by mothers and fathers, but also recognizes the importance of siblings.
Others in turn have adapted the tripartite model to describe the influence of peers [@reindlSocializationEmotionRegulation2016], thus illustrating its wider usefulness in understanding socialization.
A more abstract take on socialization is found in the internalization model of emotional development [@holodynskiDevelopmentEmotionsEmotion2006]. 
This theory describes the role of emotion in communication, and the cultural symbolic function of emotion.

In research on neurocognitive aspects of adolescents' emotion regulation,
polyvagal theory has been influential [@porgesOrientingDefensiveWorld1995].
This theory examines emotional experience and -regulation in relation to autonomous nervous system functioning, respiratory sinus arrhythmia, and the stress response.
Although polyvagal theory is relevant for development,
it does not explicitly address it.
Among neurocognitive developmental theories,
there is some consensus that the developmental asymmetry between motivational-emotional and inhibitory brain circuits gives rise to a "maturity gap" in middle adolescence [@croneUnderstandingAdolescencePeriod2012; @@caseyBrakingAcceleratingAdolescent2011; @@craccoEmotionRegulationChildhood2017].
According to the model of social-affective engagement and goal flexibility [@croneUnderstandingAdolescencePeriod2012],
adolescents' cognitive engagement is dynamically responsive to
social and motivational goal salience.
This flexibility <!--, on the one hand,-->
prepares adolescents to <!--effectively engage cognitive systems in novel
challenging situations in a way that facilitates--> develop mature regulatory
abilities, but also places them at risk of impulsivity in
pursuit of peer approval.
To a greater extent than related writings [cf. @craccoEmotionRegulationChildhood2017], this model focuses on adolescents diverging destinies;
why some youngsters flourish while others languish [@croneUnderstandingAdolescencePeriod2012].
This is important for understanding individual differences in development.
The relevance of this theory is enhanced by its focus on adolescence,
but is curtailed because it only tangentially addresses emotion regulation.
Furthermore, whereas this theory addresses the role of cognitive factors and peers as drivers of development, it devotes less attention to other relevant phenomena, such as parenting [cf. @morrisRoleFamilyContext2007].
Micro-scale theories as reviewed here are useful in explaining specific phenomena in detail,
but do not provide a comprehensive understanding of adolescent's emotion regulation.
To this end, it is important to consider these micro-scale theories in the context of a larger framework of relevant phenomena.

<!--Like Sroufe, Holodynski describes an age graded transition from
interpersonal to intrapersonal emotion regulation.
In doing so, Holodynski applies Vygotsky's theory of development to the domain of
emotion, and presents a detailed integrated model of emotional experience and
regulation.-->
Theories of the phenomenon of emotion regulation offer insight into
intra-individual drivers of emotion regulation development.
The influential process model [@grossHandbookEmotionRegulation2013] describes the
phenomenon of emotion regulation, from eliciting cue to ultimate response.
This model posits that individuals use strategies to modulate the different stages of this process,
consciously or otherwise. 
Individuals who engage in maladaptive emotion regulation strategies tend to experience more negative emotions,
diminished well-being, and greater strain in interpersonal relationships
[@@grossIndividualDifferencesTwo2003a; @bellRelationshipsInputsOutputs2000].
However, comparative studies indicate that the adaptive versus maladaptive psychosocial consequences of specific strategies appear to be partly contingent on the cultural context [see
@bariolaChildAdolescentEmotion2011].
Similar to the process model, the "social
information processing" theory also describes the role of cognitive
processes and strategies in emotion regulation
[@lemeriseIntegratedModelEmotion2000].
One shortcoming of these theories for understanding adolescents' emotion regulation 
is the lack of a developmental component.

<!-- RK: What do you take from these broad perspectives for your RQ?-->
<!--SH I am not sure what contribution this paragraph ultimately makes - you should consider condensing it substantially to just note that these theories have something to say about emotional development but are not adolescent-specific-->
<!--Theories like this are particularly relevant to a fine-grained
understanding of the process of emotion regulation, but their developmental
relevance has unfortunately not yet been considered (REF Buss). -->
<!--Parents are widely considered to be the primary proximal influence driving
emotion regulation development.
Yet several limitations remain.
@coe-odessEmergentEmotionsAdolescence2019;
instead takes an inductive approach to map the correlates of adolescents'
emotion regulation based on all available literature.

The present study instead takes an inductive approach to map the correlates of
adolescents' emotion regulation based on all available literature. From this
mapping, we proceed to classify correlates as potential risk factors,
manifestations, and outcomes of adolescent emotion regulation. The results
provide a conceptual overview of the existing literature, can help identify
blind spots in existing theory, and might inspire new hypotheses to guide
future deductive research.

Several limitations emerge from prior efforts to provide an encompassing
framework of this literature

These efforts at unification have, thusfar, been conducted in a top-down,
theory-driven manner.

which motivates most youngsters to seek out challenges in life and love, but
renders some of them vulnerable to emotion dysregulation.  -->

<!--
Note that the left panel of Figure \@ref(fig:tmnetworks) visually summarizes the correlates of emotion regulation difficulties (labeled: *Dysregulation*) according to our theoretical review.
The left panel of Figure \@ref(fig:tmnetworks) summarizes key constructs covered by the theories reviewed above. 
In the subsequent text mining analysis, we will distinguish the topics covered in this theoretical review visually to highlight unique contributions of our approach.
This allows us to see in what respects the text mining analysis reflects existing theory,
and in what respects it complements it.-->
<!--### Shortcomings of existing theory-->

Despite the abundance of theory *relevant* to emotion regulation in adolescence,
the literature has several limitations.
First, few theories have explicitly addressed adolescence.
This life stage differs qualitatively from both childhood and adulthood [@bariolaChildAdolescentEmotion2011].
It is therefore questionable whether theories focused on different age groups can be generalized to adolescents.
<!--Relatedly, many relevant theories lack an explicit developmental component, which renders them and thus lack a well-substantiated
understanding of developmental processes[see
@bussTheoriesEmotionalDevelopment2019;
@croneUnderstandingAdolescencePeriod2012]. -->
Furthermore, few theories have comprehensively addressed important predictors of development in this life stage,
and none directly guide contemporary research in the field [@bussTheoriesEmotionalDevelopment2019; @@riedigerEmotionRegulationAdolescence2014].
Finally, existing theories vary widely in scope:
Some are broad and non-specific; others describe a specific phenomenon in detail,
but lack a broader perspective.
Broad theories can be used to frame a wide variety of research,
and specific theories are more suitable for deductive hypothesis generation.
To combine the strength of both, it would be beneficial to bridge these levels of analysis.
In sum, there is a need for more integrative theory formation,
in order to provide a unified framework that could guide future empirical work.<!--[see @riedigerEmotionRegulationAdolescence2014].
Inductive analysis of the empirical literature may constitute a first step to this end.-->
<!--Such a theory should focus on -->
The present study lays the groundwork for such theory development,
by identifying theoretically relevant phenomena based on a text-mining systematic review of the literature.

<!--
Barriola: What is most
* evident from the reviewed studies is that the samples
investigated have been mainly non-clinical, within the
early childhood period of development and have examined
predominantly maternal socialization factors.
* the vast
majority have been restricted to toddlers and young chil-
dren and have only examined the in?uence of maternal,
and not paternal, expression.
Most of the literature has addressed emotion regulation in adult or infant
samples. A smaller, but substantial, portion of the literature has examined
emotion regulation in adolescents.
-->

<!-- Next paper: * Existing theory is not very specific, in the sense that it
can give rise to concrete, testable predictions. "either is not guided by
hypotheses of an explicit theory or cites a theory but does not explicitly test
the theory." (Buss) (Smaldino)-->
<!--Unfortunately, there is little theory about which risk factors and
environmental hazards render adolescents susceptible to emotional
difficulties11-->

<!--Initially, much of the research on emotion regulation focused on either
adulthood or early childhood. In recent years, however, a substantial body of
research on emotion regulation in adolescence has accrued.-->

<!--What are the predictors of emotion regulation in adolescence?-->

<!--Emotion regulation can be defined as the ability to modulate emotional
experience and expression through automatic or deliberate processes. -->


<!--


## Why focus on theory?


A focus on theory is becoming increasingly important, given the concern about
the replicability of social scientific findings [@KLEIN].

Several authors of comprehensive reviews have noted that developmental theories
of emotion are still in their infancy [@bussTheoriesEmotionalDevelopment2019].
Several specific limitations of the theoretical landscapes precipitate the
present study. First, although there are many *relevant* theories, few are
focused specifically on emotion regulation. Second, the stage of adolescence is
rarely addressed, although empirical research has indicated that this is a
crucial period of emotion regulation development.
"emotion theory has largely focused on adults, and emotional development theory
has largely focused on infancy and early childhood (see Chap. 24 on adolescent
emotional development)." Buss et al 2019:20

## Why inductive -->

## Prior narrative reviews

Whereas theory provides a top-down deductive understanding of adolescents' emotion regulation,
literature reviews synthesize inductive insights emerging from the empirical literature.
Given the noted absence of a single overarching theory [see @bussTheoriesEmotionalDevelopment2019],
reviews are especially important,
as they provide additional
insight into undertheorized relevant phenomena.
One recent narrative review, in exploring which factors contribute to adolescents' emotion regulation development, clearly reflected the emphasis on neurocognitive factors and socialization that is evident from the theoretical literature [@riedigerEmotionRegulationAdolescence2014].
Other recent narrative reviews complement the aforementioned theoretical literature to a greater extent [@coe-odessEmergentEmotionsAdolescence2019; @bariolaChildAdolescentEmotion2011].
The right panel of Figure \@ref(fig:figbaseline) visualizes constructs uniquely covered by these narrative reviews,
relative to the preceding theoretical literature.
This illustrates in what respects these reviews reflect existing theory,
and in what respects they complement it.
<!--
Note that the left panel of Figure \@ref(fig:tmnetworks) visually summarizes the correlates of emotion regulation difficulties (labeled: *Dysregulation*) according to our theoretical review.
The left panel of Figure \@ref(fig:tmnetworks) summarizes key constructs covered by the theories reviewed above. 
In the subsequent text mining analysis, we will distinguish the topics covered in this theoretical review visually to highlight unique contributions of our approach.
This allows us to see in what respects the text mining analysis reflects existing theory,
and in what respects it complements it.-->

One seminal review discussed relevant phenomena at different levels of analysis [@bariolaChildAdolescentEmotion2011]. 
At the individual level, such relevant phenomena include temperament and biological factors, like neurocognitive development and genes.
At the level of proximal influences, the authors discuss socialization and modeling by parents, teachers, and peers.
Finally, at the level of distal influences, culture and the media are discussed.
This review addressed several important limitations of the literature in this field [@bariolaChildAdolescentEmotion2011].
For instance, that work on children cannot be straightforwardly extrapolated to the life stage of adolescence.
They also called for further research on parents' role beyond early childhood, and on fathers' role in emotion socialization -
a topic that of increasing importance [see @pleckPaternalInvolvementRevised2004].
In line with these recommendations, several recent publications have investigated mothers' and fathers' unique roles in emotion regulation socialization from childhood to adolescence [see @vanlissaMothersFathersQuantitative2020] and throughout adolescence [see @vanlissaRoleFathersMothers2019].

As the aforementioned review is now a decade old,
it is worth considering a more recent review for additional insight [@coe-odessEmergentEmotionsAdolescence2019]. 
This review complements prior work by offering a nuanced discussion of several topics.
At the individual level, this includes the implications of physiological changes,
including neurocognitive development and pubertal maturation.
Pubertal development also precipitates sexual and romantic behavior,
and the intensification of both biological sex differences and gender stereotyped behavior.
This, in turn, likely modulates proximal influences through peers.
<!--With regard to the process of emotion regulation,
Coe-Odess and colleagues discuss the importance
of strategies, and point out that, in addition to negative emotionality,
positive emotionality also peaks in adolescence. -->
The review further describes how individual hormonal changes intensify the stress response,
which relates to adolescents' greater susceptibility to emotion regulation difficulties.
Finally, going beyond the implications of cognitive development
discussed in other publications, the authors discuss how cognitive development and increased capacity
for abstract thought relate to identity formation - a key challenge in
adolescence [@meeusStudyAdolescentIdentity2011] - and to increased emotional
understanding, and by extension, empathy [see @vanlissaLongitudinalInterplayAffective2014].
At the level of proximal influences, the review expands on the role of conflict with parents, which peaks in adolescence as youth become increasingly individuated.
This is relevant because parent-adolescent conflict has been shown to impact both day-to-day mood swings and dispositional emotion regulation [see @vanlissaCostEmpathyParentadolescent2017].
The review further describes mechanisms by which peers exert proximal influences: Adolescents become increasingly oriented toward peers, which
increases their sensitivity to social status and norms,
along with concomitant increases in peer pressure and risk taking.
This review devotes limited attention to distal influences.

There are notable parallels between phenomena relevant to adolescents' emotion regulation as identified in these
narrative reviews, and in the preceding theoretical literature, as can be seen in Figure \@ref(fig:figbaseline).
Nevertheless,
these literature reviews also touch upon issues that have received little
attention in theoretical work.
<!--These include specific individual differences at the biological and psychological level, including genetic predisposition, hormones, pubertal onset, gender, sexuality, temperament, identity, empathy, and stress.
Further introduced are proximal influences, including the role of media, norms, and social status.-->
This illustrates the general principle that reviews of the empirical literature can contribute inductive insight into relevant phenomena underrepresented in theory.
An important shortcoming is that all reviews in this field have been unstructured narrative reviews, which are known to be limited in scope and biased [@littellEvidencebasedBiasedQuality2008].
The current study seeks to complement preceding work by using text mining to conduct a more comprehensive and objective empirical
literature review, and map the phenomena relevant to adolescent emotion regulation.

<!--Where sentient readers tend to structure their reading of the literature around established ideas,
text mining has the potential to reveal phenomena and associations missed by narrative reviewers,
thereby laying the groundwork for future empirical and theoretical work.-->


<!-- NIET TEVEEL OVER THEORIE PRATEN; IK KIJK NIET NAAR THEORIE. IK KIJK NAAR FACTOREN DIE IN VERBAND GEBRACHT WORDEN MET EMOTIEREGULATIE. -->
<!--The life stage of adolescence differs qualitatively from both childhood and adulthood. It is therefore not sufficient to extend -->

<!--
Influences on emotion regulation (Riediger Klipker)
* Neurophysiological development 
* Familial context



Despite widespread interest in emotion regulation in adolescence, there is a lack of explicit theories about which risk factors and environmental hazards render adolescents susceptible to emotional difficulties. Some theories can be considered relevant, but these theories are rarely explicit enough to generate specific predictions. 
As many as one in five adolescents experiences severe emotional problems. A key question is therefore which factors render adolescents at-risk for difficulties in emotion regulation. 

Unfortunately, relevant theory on adolescent emotion regulation development is limited27–29. The field is therefore at an impasse: We know that some adolescents are more susceptible to emotion dysregulation than others, but lack tools and theory to identify important predictors of individual development30.

inductive approach, thereby facilitating a more complete understanding of developmental processes, and nourishing theory formation

My work addresses this lacuna by taking an inductive approach to theory formation; paying special attention to between-person differences. This paves the way for a new wave of person-centered research


Key questions:

Why focus on emotion regulation specifically, instead of other aspects of emotional development?

* Biological determinants
* Social determinants

* Existing developmental theories do not focus on adolescence (rather, on adults, or development in infancy and childhood). However, many interesting emotion-related things happen in adolescence.

Important:
Buss: theories of emotion and emotional development
Cracco: Evidence for a maladaptive shift in emotion regulation in adolescence
Zimmermann & Iwanski: Dip in adolescence

Sroufe 1995: Development of emotion regulation until preschool age
"the key progression in emotional regulation is from caregiver-orchestrated
regulation to dyadic regulation to self-regulation."
* attachment - dyadic regulation of emotion (Sroufe 1996)
* Caregiver-guided self-regulation 
* Autonomous self-regulation
***** HOWEVER: In adolescence, regulatory brain regions still developing!!!! So Sroufe stops too early

Polyvagal theory Porges 1995 -->

<!-- SH: ultimately I think that the introduction is too long - considering that the introduction, itself, is a literature review to some extent, I don't come away with a clear delineation between the literature review up this point and the new work you are going to contribute. I think you need to review the Introduction with an eye on focusing the discussion on the problems/gaps that exist and how the lit review method usually used are insufficient for addressing those issues-->

## The present paper

The present paper set out to map the phenomena relevant to adolescent emotion regulation
using a text mining systematic review (TMSR) of the literature.
This approach considers the frequency with which a phenomenon is covered in the literature to be indicative of its relevance,
and the frequency with which phenomena are investigated together within publications to be indicative of a relationship between these constructs.
The expected outcomes consist of term frequency metrics,
which can be rank ordered to identify the most relevant phenomena,
and term co-occurrence metrics.
These metrics can be jointly visualized as a network graph,
thereby "mapping" phenomena relevant to adolescent emotion regulation.
Note that this study is inductive (exploratory),
as opposed to deductive (confirmatory) research, and as such does not test any hypotheses [@@degrootMethodologieGrondslagenVan1961; @wagenmakersCreativityVerificationCyclePsychological2018].
Inductive methods are suitable for the detection of phenomena,
as they aim to generalize from observations (data) without appeal to theory [@haigExploratoryFactorAnalysis2005].

<!--The distinction between inductive and deductive research has recently been recast as a "creativity-verification" cycle [@wagenmakersCreativityVerificationCyclePsychological2018].-->

# Methods

As the purpose of inductive research is to inform hypothesis generation,
this approach affords the researcher with substantial creativity [@wagenmakersCreativityVerificationCyclePsychological2018].
This means that subjective decisions are made throughout the analysis process.
To ensure that all such decisions are properly documented,
all code, data, and the historical record of this project are available in a public research repository at [https://github.com/cjvanlissa/veni_sysrev](https://github.com/cjvanlissa/veni_sysrev). 
This study used the Workflow for Open Reproducible Code in Science [WORCS, @vanlissaWORCSWorkflowOpen2020]
to make all analyses reproducible.
Reuse of the analysis code and secondary analysis of the data are encouraged.

## Search strategy

The search was conducted in Web of Science,
the most comprehensive database accessible to the lead author with permissions to export keywords and abstracts.
The search strategy was based on
procedures described by Staaks [@staaksSystematicReviewSearch2019].
First, a reference set of 29 articles was compiled.
Then, a search string was constructed to retrieve the articles in this set.
The search string consisted of synonyms of emotion regulation and adolescence.
It returned 6653 results, including 25 records in the reference set.
To match all 29 reference set items required adding the terms `"emotio* socialization" OR "emotio* processes"` as synonyms for emotion regulation.
Doing so resulted in 191 more hits, most of which did not meet the inclusion criteria explained below.
These terms thus appeared to be overly inclusive, and the original search string was used.




## Screening



Starting with all 6653 records identified through Web of Science,
duplicates were removed based on DOI matches (n = 2) and title similarity (n = 54).
Rayyan QRCI [@Ouzzani2016] identified an additional 13 duplicates.
Papers were screened based on two main criteria:
They had to address emotion regulation or a synonymous construct, and the target population must overlap with the age range of adolescence (10-24) [as defined by @steinbergAgeOpportunityLessons2014; @@sawyerAgeAdolescence2018].
Preliminary screening was conducted in Rayyan.
After 559 papers were screened (192 excluded),
screening continued in the free open source program ASReview [@van_de_schoot_rens_2020_3828293].
This program uses machine learning to screen articles; the algorithm used in the present study was "naive Bayes".
An additional 541 papers were screened (85 excluded),
until among the most recently screened 100 papers only 6 were excluded.
In total, 6305 papers were deemed suitable for analysis.



<!--
## Corpus description


{r, eval = FALSE}
# Plot papers per year
df_plot <- as.data.frame(table(recs_final$PY), stringsAsFactors = FALSE)
df_plot$Year = as.numeric(df_plot$Var1)
ggplot(df_plot, aes(x= Year, y= Freq))+geom_point() + geom_path(group =1)+
  theme_bw() + scale_y_log10()
-->

# Analysis 1: Author keywords



The corpus for this first analysis consisted of author-provided keywords.
Keywords were extracted by document,
and an exclusion filter of methodological terms and similar non-substantive words was applied.
The resulting corpus consisted of 5031 documents with 8080 unique terms.
One important step in reviewing the literature is to examine heterogeneity of the corpus;
to determine whether there is, for example, a clear divide between psychiatric and developmental texts.
To this end, topic modeling using latent dirichlet allocation was conducted [@bleiLatentDirichletAllocation2003].
However, as no subcorpora could be identified (see [online supplement](https://github.com/cjvanlissa/veni_sysrev/blob/master/topic_models.md)), the sample was analyzed in its entirety.

## Identifying common terms



To identify what phenomena are represented in this corpus,
terms occurring in the largest number of texts were analyzed.
To classify closely related terms, a dictionary was used that described 108 terms using 464 regular expression queries.
This dictionary and the classification function are available for reuse.
After dictionary encoding, the remaining number of unique terms was 5292.
To reduce the number of terms to a more manageable set,
word frequency was modeled with a negative binomial distribution.
Terms exceeding the $97.5^{th}$ percentile were retained.
This corresponded to terms occurring in at least 21 documents.
This is a subjective criterion,
but compared to the common practices of either retaining a fixed number of terms or pruning terms below a fixed frequency [see @benoitQuantedaPackageQuantitative2018],
it has the advantage of being responsive to the empirical distribution of term frequencies.
Note that the vast majority of pruned terms (4004) occurred only once in the corpus.
Pruning resulted in 84 remaining terms, which occurred in 4827 documents.
The issues covered in this body of literature are visualized in Figure \@ref(fig:varimps).

<img src="varimps.png" title="Frequency of terms in Analysis 1 and 2. Transparent circles are constructs represented in theory (Figure 1), dotted lines are constructs absent from the co-occurrence graph." alt="Frequency of terms in Analysis 1 and 2. Transparent circles are constructs represented in theory (Figure 1), dotted lines are constructs absent from the co-occurrence graph." width="100%" />

## Mapping the literature

To map the literature, a term co-occurrence matrix was computed,
which represents how frequently words occurred within the same document (see Figure \@ref(fig:tmnetworks)).
In total, there were 2498 co-occurrence relationships.
To aid interpretability, small coefficients were again pruned using a negative binomial distribution,
retaining co-occurrences exceeding the $97.5^{th}$ percentile.
Note that this is a subjective criterion, which corresponded to terms that co-occurred in more than 25 documents.
After pruning, 106 co-occurrence relationships remained.

To stimulate further reflection on the role of each construct,
each of the remaining terms were categorized as either a putative 'Cause', 'Outcome', 'Protective factor', or 'Indicator' of emotion regulation,
following the same procedure described in the introduction to classify phenomena discussed in the theoretical literature.
Note that this classification is based on a subjective reading of the literature,
and that the nature of associations between phenomena is likely to be more complex than presented here.
For example, some of these associations are likely to be spurious, or bidirectional [e.g., emotion regulation is known to both predict and be predicted by conflict with parents, @vanlissaCostEmpathyParentadolescent2017].

<img src="tmnetworks.png" title="Map of phenomena relevant to adolescents' emotion regulation based on term co-occurrence in author keywords (A) and abstracts (B). Size of lines and circles represents frequency. Dashed lines represent links not involving emotion regulation. Transparent circles indicate constructs also represented in the theoretical review." alt="Map of phenomena relevant to adolescents' emotion regulation based on term co-occurrence in author keywords (A) and abstracts (B). Size of lines and circles represents frequency. Dashed lines represent links not involving emotion regulation. Transparent circles indicate constructs also represented in the theoretical review." width="100%" />


# Analysis 2: Abstract text mining



The corpus for this second analysis consisted of the abstracts of the selected articles.
Keywords, as examined in Analysis 1, convey high-quality information because they are carefully chosen by authors to capture the essence of a study.
However, as authors are
typically limited to 5 keywords, some nuance may be lost.
Abstracts, by contrast, offer greater freedom of expression,
but present a greater challenge when it
comes to extracting relevant information.
It has been shown that retaining nouns and adjectives generally helps derive more interpretable text mining models [@martinMoreEfficientTopic2015].
For example, nouns help capture terms like "emotion", and adjectives help capture the "mental" in "mental health".
The natural language processing technique "part-of-speech tagging" (POS-tagging) was used to identify each word's grammatical function within the sentence context.
Finally, stemming was used to reduce the retained terms to their root form;
a common procedure to ensure that terms are correctly classified regardless of their use in a sentence.
As in Analysis 1, heterogeneity was explored using latent dirichlet allocation - but no subcorpora were identified ([see online supplement](https://github.com/cjvanlissa/veni_sysrev/blob/master/topic_models.md)).

## Feature engineering

When conducting text mining analysis on unstructured text data (as opposed to author key words), focusing on individual words out of context can reduce interpretability.
For instance, the central construct of this review, "emotion regulation", is already a bigram.
To obtain more meaningful units of analysis,
the `textrank` algorithm [@wijffelsTextrankSummarizeText2019; @@pageMethodNodeRanking2006] was used to identify $n$-grams (with $n \leq 3$).
This is sufficient to capture trigrams, like "parent-child conflict",
but would not capture quadragrams like "parent-child conflict resolution".
The resulting $n$-grams were merged with the original data.

## Identifying common terms

After applying the dictionary and exclusion filter as explained in Analysis 1,
the resulting corpus consisted of 5097 documents with 11448 unique words.
Again, the $97.5^{th}$ percentile of a negative binomial distribution was used
as a (subjective) threshold for pruning the least common terms,
which corresponded to terms occurring in more than 6 documents.
The identified important keywords are displayed in Figure \@ref(fig:varimps).

## Mapping the literature

A term co-occurrence matrix was constructed following the procedure described in Analysis 1.
In total, there were 850 co-occurrence relationships.
Small coefficients below the $97.5^{th}$ percentile of a negative binomial distribution were again pruned.
This is a subjective criterion, which corresponded to terms that co-occurred in more than 10 documents.
After pruning, 43 co-occurrence relationships remained.
Figure \@ref(fig:tmnetworks) displays the resulting co-occurrence matrix as a force directed graph.



## Results

In the analysis of author keywords (Analysis 1),
emotion regulation and associated mental health-related outcomes were foremost among the common terms in the corpus (Figure \@ref(fig:varimps)). 
Other frequent terms reflect important themes discussed in the theoretical review of the literature;
for instance, the terms *neural*, *parenting*, and *stress* correspond to themes discussed by  @coe-odessEmergentEmotionsAdolescence2019:
Neurocognitive development, the role of the parents, and adolescents' increased stress response.
Importantly, the most common terms also include several concepts not featured prominently in the theoretical review.
For example, *ADHD/CD* [cf. @braetEmotionRegulationChildren2014], *substance* use [cf. @pierrehumbertStrategiesEmotionRegulation2002], and *minority status* [cf. @myersEthnicitySocioeconomicStatusrelated2009] are common in the corpus,
but featured less prominently in the theoretical review.



In the analysis of abstracts (Analysis 2),
emotion regulation and associated mental health-related outcomes were evidently the most common terms.
There was substantial agreement between the most common terms identified in the analysis of author keywords and abstracts.
Specifically, $75\%$ of the most frequent terms identified in the author keywords
were also present in the abstracts,
and conversely, $89\%$ of the most frequent terms from the abstracts were present in the keywords.
There were also some differences;
for instance, the term *sex* was more frequent than in Analysis 1,
suggesting that sex differences are regularly reported in Abstracts even if they are not mentioned in the keywords.
The term *parenting*, which ranked highly in the keyword analysis, was displaced by *mothers* in the analysis of abstracts.
This reflects the prior observation that parenting is most often operationalized in terms of mothering [@pleckPaternalInvolvementRevised2004].

<!-- Co-occurrence -->
With regard to the term co-occurrence analyses, the analysis of  keywords (Analysis 1, see Figure \@ref(fig:tmnetworks)) indicated that 
emotion regulation is evidently a central construct
to which most other constructs were directly linked.
This suggests that the search successfully identified factors relevant for adolescents’ emotion regulation.
The remaining graph was notably sparse, with few interconnections between terms.



Compared to the keyword co-occurrence graph,
the analysis of abstracts (Analysis 2) revealed an even sparser network. 
The structure also differed, as emotion regulation and mental health-related terms appeared to form a central axis.
Many relevant terms were connected to this axis, but not directly to
emotion regulation (as was the case in Analysis 1). 
The only terms directly connected to emotion regulation were *neural*, *mothers*, *attachment* and *ptsd*.
<!--THIS IS NOT IN THE RESULTS FOR ANALYSIS 1 
Again, many prevalent terms were absent from the co-occurrence graph,
as they were not strongly related to any other terms (see Figure \@ref(fig:varimps)). -->

## Discussion

The present study used a text mining systematic review (TMSR)
to identify relevant phenomena in the literature on adolescent emotion regulation,
and used co-occurrence graphs to map associations among these phenomena.
A systematic literature search was conducted,
and new procedures were developed to analyze the author keywords (Analysis 1) and abstracts (Analysis 2) of the resulting corpus.

The TMSR approach considers term frequency to be indicative of a phenomenon's relevance.
In line with this assumption, the results of both analyses
reflected some of the constructs commonly accepted as relevant in theoretical literature and empirical reviews - particularly those pertaining to neurodevelopment and socialization.
Furthermore, some of the most frequently occurring terms were mental health-related outcomes that involve emotion regulation difficulties [see @aldaoEmotionregulationStrategiesPsychopathology2010].
This validates the notion that adolescent emotion regulation is implicated in a range of mental health problems [@leeAdolescentMentalHealth2014],
and underlines the importance of this area of research.

The analyses of term frequency also identified several novel themes,
which were underrepresented in the theoretical literature and prior systematic reviews.
One such theme pertains to developmental disorders, such as ADHD/CD and autism.
This theme recurred in both analyses, although its constituent terms were ranked more highly in the analysis of author keywords as compared to abstracts.
Another theme revolved around adolescents' physical health (sic), which was also reflected in terms like sleep, sports, and disability status.
There thus appears to be substantial empirical work linking emotion regulation and physical health, although this association is underrepresented in theory.
As with the theme of developmental disorders, terms related to physical health ranked more highly in the keyword analysis than in the abstract analysis.
This might indicate that a broader vocabulary was used to describe physical health in the abstracts.
External stressors were another important theme, reflected in terms like bullying, stress, PTSD, abuse, violence, life events, historic events (e.g., earthquakes, war), parenting stress, and divorce.
Based on a review of the theoretical literature, this indeed appears to be an under-theorized area.
Conceptually, external stressors most closely align with the notion of the exosystem in the bioecological model [@bronfenbrennerBioecologicalModelHuman2007], but have rarely been discussed as such in the theoretical literature.
The impression that external stressors are an undertheorized theme is reinforced by the fact that studies linking adverse life events to adolescent emotion regulation tend to appeal to prior empirical work, but not to a theoretical framework [e.g., @@garnefskiNegativeLifeEvents2001; @stikkelbroekAdolescentDepressionNegative2016].
Finally, one emergent theme that appears to be underrepresented in existing theory is structural disadvantage.
This theme was reflected in terms like minority status and discrimination, disability status, socio-economic status, adoption status, and sexual diversity. 
The aforementioned developmental disorders are also relevant in this context, as neuroatypical individuals tend to experience social exclusion [@cappadociaBullyingExperiencesChildren2012].
Future theoretical work might address these shortcomings.

The analysis of abstracts identified three additional themes not represented in the analysis of keywords.
The first of these themes revolved around addictive behavior, with indicators *substance use* and *device use*.
The second theme pertained to identity and moral development, two topics with a common root in theory [@lapsleyMoralIdentityDevelopmental2015].
This theme is also reflected by the terms *values* and *personality*. 
Finally, sexual development emerged as a theme. Aside from the high-ranking construct (biological) *sex*, this theme was reflected in the terms *puberty*, *sexual diversity*, and *romantic*.
These insights illustrate how inductive reviews can identify under-theorized areas,
thereby complementing existing theory and narrative reviews.

With regard to term co-occurrence, most phenomena were directly linked with emotion regulation in the keyword analysis,
and with a central axis of emotion regulation and its mental health-related outcomes in the abstract analysis.
The emergence of a "central axis" of dysregulation and mental health-related outcomes
again suggest that these phenomena are consistently studied together.
This makes sense, given the central role of emotion dyregulation in the etiology of diverse mental health problems [@leeAdolescentMentalHealth2014].

Compared to the keyword analysis, the abstract analysis yielded a sparser network,
with fewer selected terms.
This is likely an artifact of the unstructured nature of abstracts,
which introduces greater noise in the analysis.
Thus, fewer terms will exceed the detection threshold.
In line with this interpretation, exploratory analyses indicated that 99% of terms occurred only once in the abstract analysis, compared to only 78% in the keyword analysis.
Despite the sparser network, there was substantial consistency between the terms retained in both networks.
This supports the validity of the findings,
suggesting that automatic keyword extraction from abstracts can identify relevant constructs,
and may be a suitable alternative to author-provided keywords.

Both analyses revealed relatively few interconnections between phenomena,
and many of the frequently occurring terms were absent from the co-occurrence graphs due to a lack of connectivity.
These observations empirically support the prior claim that this literature is somewhat fragmented [@riedigerEmotionRegulationAdolescence2014] and lacks an overarching theoretical framework [@bussTheoriesEmotionalDevelopment2019]. 
The sparseness of both networks explains, in part,
why some of the most prevalent terms based on term document frequency
are absent from the co-occurrence graph (see Figure \@ref(fig:varimps)).
This does not mean that these terms represent unimportant phenomena.
Rather, it suggests that they are not well-integrated in the broader literature on adolescents' emotion regulation.
Such phenomena might be suitable candidates for future research.
Indeed, several of these excluded constructs represent active ongoing areas of research, including research on *fathers* [@vanlissaRoleFathersMothers2019], *identity* [@campbellFriendsEducationIdentity2019], *friendship* and *social support* [@wangBidirectionalEffectsExpressive2020], *autonomy* [@vrolijkLongitudinalLinkagesFather2020a; @@brenningPerceivedMaternalAutonomy2015], *sexual risk* [@brownDepressiveSymptomsPredictor2006], and *loneliness* [@spithovenItAllTheir2017].
One recommendation for future research might be to study such important but unembedded constructs
in conjunction with other more well-established constructs,
as such an approach might help fill gaps in existing knowledge.

## Implications

The results of this inductive approach echoed many of the constructs considered
relevant in the theoretical literature.
This suggests that the text mining method can indeed be used to map relevant themes in the literature.
The present analyses also revealed several themes that have been underrepresented in theories of adolescent emotion regulation,
but nonetheless occur frequently in the empirical literature.
These themes include developmental disorders, physical health, external stressors, structural disadvantage, addictive behavior, identity and moral development, and sexual development.

It is important to identify such under-theorized areas of the literature because
researchers typically rely on theoretical foundations when planning a study.
By providing an overview of phenomena relevant to adolescents' emotion regulation based on an inductive analysis of the empirical literature,
the present study offers guidance regarding potentially relevant topics to consider.
An important direction for future research would be to formalize these inductive insights into a new overarching theory of adolescent emotion regulation.
Going beyond the inductive identification of relevant phenomena,
the next step in theory construction would involve abductive reasoning: the attribution of observations to causal explanatory principles [@haigExploratoryFactorAnalysis2005].
As a starting point for this effort, the co-occurrence graphs presented here could be
used as templates for a nomological network:
a proto-theoretical diagrammatic representation that describes causal relationships between
relevant phenomena [see @alaviAligningTheoryMethodology2018].

Additional insight can be gleaned from the structure of the co-occurrence graphs.
First, both analyses revealed close ties between emotion regulation and mental health-related outcomes.
This is consistent with emotion regulation's putative implication in the etiology of various mental health problems [see @leeAdolescentMentalHealth2014].
It further emphasizes the societal relevance of this field of research.
Both analyses further revealed that most constructs were
directly tied to emotion regulation and mental health,
with few connections among constructs.
This sparse property of the networks echoes the observation by other authors 
that the literature is somewhat fragmented [@riedigerEmotionRegulationAdolescence2014]
and lacks an overarching theoretical framework [@bussTheoriesEmotionalDevelopment2019].
The present study takes a first step toward integrating this diffuse field
by using a relatively comprehensive and objective method, compared to narrative reviews.
An important future direction for research might be to jointly investigate disconnected constructs, as the lack of connections in the graph indicates a potential knowledge vacuum.



One strength of the present study is that it was more comprehensive than previous reviews of the literature in two respects [cf. @bariolaChildAdolescentEmotion2011; @coe-odessEmergentEmotionsAdolescence2019]:
First, in contrast to prior literature reviews, the present study was based on a systematic literature search.
Second, prior reviews relied on narrative synthesis of a comparatively smaller number of publications, at most 241 [@coe-odessEmergentEmotionsAdolescence2019].
By contrast, the present study was able to map the literature more comprehensively, using text mining analysis to synthesize all 6305 identified records.
Text mining offers unique advantages compared to narrative reviews [@littellEvidencebasedBiasedQuality2008],
because it can cover vastly greater corpora than a sentient reader,
and follows a somewhat more objective, transparent, and reproducible procedure.
Both narrative and text mining reviews are initially labor-intensive.
The key differences are that text mining systematic reviews are more scalable,
because code can be applied to corpora of arbitrary size,
are easily updated when new literature is published.
Once written, analysis code can be repurposed for reviews in different areas of research with relatively little effort.
The present study illustrates that text mining systematic reviews offer an interesting perspective of the published literature that complements theory and narrative reviews.
Moreover, text mining systematic reviews offer an inductive approach to identify relevant phenomena in a particular area of research.
This can serve as the first step toward formal theory construction [@borsboomTheoryConstructionMethodology2020].
The present study was the first to implement this novel approach.

It should be noted that this method has disadvantages as well.
The key limitation of the present study is that the text mining techniques used here
are not able to extract *meaning* from the literature in the way a sentient reader would, an cannot substantively interpret connections between constructs.
This limitation is best addressed by considering the output of a text mining analysis as a starting point for further inductive thought or a more in-depth reading of a particular subset of the literature.
Throughout this paper, results are interpreted subjectively.
Readers are encouraged to reflect on these results independently,
and use them as inspiration for future deductive research.
A related limitation is that the text mining methods used do not capture the nature of the relationship between co-occurring terms.
Instead, terms were manually classified as potential causes, outcomes, protective factors, or indicators, based on domain knowledge.
Efforts are currently underway to develop unsupervised algorithms capable of distilling causal links from bodies of scientific abstracts [@anExtractingCausalRelations2019].
Future research might substantially advance theory formation by applying such methods to the present corpus.
<!--For example, a human reader would understand that the influence of mothers and fathers both
falls under the header of "parenting". 
Furthermore, a human reader would swiftly learn that the term "parenting" has historically been used primarily to represent maternal influences,
and has increasingly come to represent paternal influence as well. -->
Another limitation is that the present analyses were limited to keywords and abstracts.
The primary obstacles to the analysis of full-text publications were limited access to articles behind paywalls,
and the absence of a standardized Application Programming Interface (API) for the automatic retrieval of articles across publishing outlets.
<!--As the number of scientific publications on any given topic tends to show exponential increase over time, making it difficult for applied researchers to keep up.
Meta-scientific analyses of the published literature will likely become increasingly important -->
Comprehensive access to scientific publications is essential to all meta-scientific research, including classic systematic reviews and meta-analyses (e.g., to avoid bias in summary effect sizes).
For text mining approaches in particular, the availability of large data sets is crucial.
<!--Consequently, limited access to full-text publications is a major bottleneck.-->
One example of a data set suitable for even more complex text mining analyses is a corpus of 400k+ full-text papers on COVID-19 that was made publicly available [@wangCORD19Covid19Open2020].
Compiling such full-text data sets currently requires substantial manpower and financial resources, thus placing them out of reach for many researchers.
<!--The authors argued that the sheer volume of available literature made it difficult for individual researchers to remain informed, thus necessitating automated text mining analysis.
Although our analysis comprised a mere 6305 publications, even this is -->
<!--As the number of scientific publications tends to grow exponentially across fields [@larsenRateGrowthScientific2010],
it becomes harder for researchers to remain informed, thus necessitating meta-scientific research.-->
An increased adoption of open access publishing,
and the development of a unified API for article retrieval across publishing outlets,
would facilitate curating full-text data sets.
These changes would enable more widespread adoption and more informative application of meta-scientific (text mining) analyses.
One final limitation is that several subjective decisions were made throughout the analysis process.
This limitation is inherent to inductive studies, however [e.g., @wagenmakersCreativityVerificationCyclePsychological2018]:
There are infinite possible ways to conduct exploratory analysis,
and researchers have considerable creative license in doing so.
To address this limitation, subjective decisions are explicitly discussed throughout the manuscript,
and all analysis code and data are made publicly available in a fully reproducible format [based on @vanlissaWORCSWorkflowOpen2020],
so that others may explore alternative exploratory analysis strategies. 
 
To conclude, this paper set out to map the factors associated with adolescents' emotion regulation, based on a systematic review of the literature, and text mining analysis of author keywords and abstracts.
This map covered familiar phenomena that are well-represented in existing theory,
such as socialization and neurocognitive factors,
which speaks to the validity of this approach.
The structure of the map further reinforced the observation of several previous authors
that the empirical literature is somewhat fragmented by subject area [@riedigerEmotionRegulationAdolescence2014] and lacks an overarching theoretical framework [@bussTheoriesEmotionalDevelopment2019].

Importantly, the present results also draw attention to several relevant phenomena that,
although well-represented in the empirical literature,
are under-emphasized in narrative reviews and theory - such as developmental disorders, physical health, external stressors, structural disadvantage, substance use, identity and moral development, and sexual development.
This has several implications for future research.
First, the major themes identified in these inductive analyses are relevant for the design of empirical studies.
Even when such designs are grounded in theory,
they might benefit from additionally considering relevant phenomena as identified in the present study as potential confounders or contributing causes.
Second, the phenomena that appear to exist on the fringes of the existing literature according to the present analyses might be suitable candidates for further study.
These phenomena might represent emerging themes in the literature, for example, as is the case for the role of fathers [see @pleckPaternalInvolvementRevised2004; @@vanlissaMothersFathersQuantitative2020].
Future research might focus on these emerging themes in order to better elucidate the nature of their association with adolescents' emotion regulation.
Moreover, studying these fringe phenomena in conjunction with other more well-established constructs could help embed these important but loosely connected phenomena into the mainstream literature and bridge gaps in existing knowledge.

Finally, several authors have commented on the lack of an overarching theory tailored specifically to adolescent emotion regulation.
The first step in theory construction methodology (TCM) is to identify relevant phenomena [@borsboomTheoryConstructionMethodology2020].
Text mining systematic reviews offer a relatively comprehensive and objective method for identifying such phenomena, because they can evaluate much larger bodies of literature than sentient readers, and are not biased toward pre-existing ideas.
The next step in formal theory construction methodology would be to describe and quantify the nature of the relationship of each phenomenon in relation to adolescent emotion regulation.
The phenomena identified in the present study might thus serve as a starting point for future theory development,
and sensitize empirical researchers to potential confounders in research on adolescents' emotion regulation.

On behalf of all authors, the corresponding author states that there is no conflict of interest
<!--
Informally, much can be gained by revisiting existing relevant theory
and incorporating relevant phenomena as identified in the present analysis.-->



\newpage

# References


\begingroup
\setlength{\parindent}{-0.5in}
\setlength{\leftskip}{0.5in}

<div id = "refs"></div>
\endgroup




