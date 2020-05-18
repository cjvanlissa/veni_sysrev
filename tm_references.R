df <- read.table("c:/tmp/savedrecs.txt", sep = "\t", header = TRUE, quote = "", row.names = NULL, stringsAsFactors = FALSE, fileEncoding = "UTF-16")

library(reticulate)
ed <- import("editdistance")

library(findpython)
can_find_python_cmd(required_modules = "pattern.db")
options('python_cmd'='C:/Python27/python.exe')
Sys.setenv(PYTHON2 = "C:/Python27/python.exe")

py_config()

ts <- import_from_path("textrank", path = "c:/git_repositories/textrank")
py_run_string('textrank extract-summary "c:\tmp\test_sum.txt"')