library(reticulate)
#use_python()
use_condaenv("veni_sysrev") #C:\Users\lissa102\AppData\Local\Continuum\miniconda3\envs\veni_sysrev
asreview <- import("asreview")
asreview
asreview oracle YOUR_DATA.csv --state_file myreview.h5

py_run_string("asreview oracle")