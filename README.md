# Readme <a href='https://osf.io/zcvbs/'><img src='worcs_icon.png' align="right" height="139" /></a>

This repository contains the source code for the paper *"Mapping Correlates of Adolescent Emotion Dysregulation: A Text-mining Systematic Review"*.

## Where do I start?

You can load this project in RStudio by opening the file called `veni_sysrev.Rproj`.
**NOTE:** To reproduce the published analyses, use the command `rmarkdown::render("manuscript.Rmd")`.
One of the dependencies causes the code to break when trying to Knit the document using the "Knit" button in RStudio.
Raw data are contained in the `recs/` folder.

## Project structure

<!--  You can add rows to this table, using "|" to separate columns.         -->
File                 | Description                | Usage         
-------------------- | -------------------------- | --------------
README.md            | Description of project     | Human editable
veni_sysrev.Rproj    | Project file               | Loads project 
LICENSE              | User permissions           | Read only     
manuscript.Rmd       | Fully reproducible manuscript | Human editable
.worcs               | WORCS metadata YAML        | Read only     
preregistration.rmd  | Preregistered hypotheses   | Human editable
prepare_data.R       | Script to process raw data | Human editable
renv.lock            | Reproducible R environment | Read only     

<!--  You can consider adding the following to this file:                    -->
<!--  * A citation reference for your project                                -->
<!--  * Contact information for questions/comments                           -->
<!--  * How people can offer to contribute to the project                    -->
<!--  * A contributor code of conduct, https://www.contributor-covenant.org/ -->

# Reproducibility

This project uses the Workflow for Open Reproducible Code in Science (WORCS) to
ensure transparency and reproducibility. The workflow is designed to meet the
principles of Open Science throughout a research project. 

To reproduce the published analyses, use the command `rmarkdown::render("manuscript.Rmd")`.
One of the dependencies causes the code to break when trying to Knit the document using the "Knit" button in RStudio.

To learn how WORCS helps researchers meet the TOP-guidelines and FAIR principles,
read the preprint at https://osf.io/zcvbs/

## WORCS: Advice for authors

* To get started with `worcs`, see the [setup vignette](https://cjvanlissa.github.io/worcs/articles/setup.html)
* For detailed information about the steps of the WORCS workflow, see the [workflow vignette](https://cjvanlissa.github.io/worcs/articles/workflow.html)

## WORCS: Advice for readers

Please refer to the vignette on [reproducing a WORCS project]() for step by step advice.
<!-- If your project deviates from the steps outlined in the vignette on     -->
<!-- reproducing a WORCS project, please provide your own advice for         -->
<!-- readers here.                                                           -->
