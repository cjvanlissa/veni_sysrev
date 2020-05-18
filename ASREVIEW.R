library(reticulate)
use_python()

asreview oracle YOUR_DATA.csv --state_file myreview.h5
use_condaenv("veni_sysrev") #C:\Users\lissa102\AppData\Local\Continuum\miniconda3\envs\veni_sysrev

asreview <- import("asreview")