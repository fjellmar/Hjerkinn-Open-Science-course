#### Installing packages needed ####
library(tidyverse)
library(usethis)
library(targets)
library(quarto)
library(rgbif)

remotes::install_github("LivingNorway/LivingNorwayR") 

library(checker)
chk_requirements(path = url("https://raw.githubusercontent.com/audhalbritter/ort_science_course/main/R/OS_course_requirements.yaml"))
