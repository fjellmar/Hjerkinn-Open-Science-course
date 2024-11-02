#### Installing packages needed ####
library(tidyverse)
library(usethis)
library(targets)
library(quarto)
library(rgbif)

remotes::install_github("LivingNorway/LivingNorwayR") #  first time I got error "bad credentials"

# checking where credentials are saved
Sys.getenv("GITHUB_TOKEN")
Sys.getenv("GITHUB_PAT")
gitcreds::gitcreds_get() # found it - old username saved ("marifjel")
gitcreds::gitcreds_get()$passwordv

install.packages("gitcreds")
library(gitcreds)
gitcreds_delete() # fixing issue

remotes::install_github("LivingNorway/LivingNorwayR") # now it works!

library(checker)
chk_requirements(path = url("https://raw.githubusercontent.com/audhalbritter/ort_science_course/main/R/OS_course_requirements.yaml"))

# connect to github
library(usethis)
use_git_config(
  user.name = "fjellmar", 
  user.email = "mari.fjelldal@gmail.com"
)

usethis::use_git()

