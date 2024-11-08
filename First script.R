#### Installing packages needed ####
library(tidyverse)
library(usethis)
library(targets)
library(quarto)
library(rgbif)
library(LivingNorwayR)
library(ggplot2)

library(checker)
chk_requirements(path = url("https://raw.githubusercontent.com/audhalbritter/ort_science_course/main/R/OS_course_requirements.yaml"))


#### Clean messy data ####
messy_data <- readRDS("/Users/mariaasfjelldal/Desktop/NMBU batlab/Courses/Open Science 24/messy_data.RDS")

clean_messy_data <- messy_data
library(janitor)
names(clean_messy_data) <- clean_names(clean_messy_data) |> names()
levels(as.factor(clean_messy_data$species_name))
clean_messy_data$species_name <- ifelse(clean_messy_data$species_name == "Lagopas lagopus" | 
                                    clean_messy_data$species_name == "Lagopus lagopus",
                                  "L. lagopus", 
                                  "L. muta")

levels(as.factor(clean_messy_data$sex))
clean_messy_data$sex <- ifelse(clean_messy_data$sex == "female" | 
                           clean_messy_data$sex == "Female" | 
                           clean_messy_data$sex == "FEMALE",
                                  "female", 
                                  "male")


levels(as.factor(clean_messy_data$age))
library(dplyr)
clean_messy_data$age <- case_when(clean_messy_data$age == "A" | clean_messy_data$age == "Adult" | clean_messy_data$age == "ADULT" ~ "adult",
          clean_messy_data$age == "J" | clean_messy_data$age == "Juvenile" | clean_messy_data$age == "JUVENILE" ~ "juvenile")


levels(as.factor(clean_messy_data$date))
library(datefixR)
clean_messy_data$date <- fix_date_char(clean_messy_data$date)

summary(clean_messy_data$count)


#### Data wrangling ####
small_game <- readRDS("/Users/mariaasfjelldal/Desktop/NMBU batlab/Courses/Open Science 24/smallGame.RDS")

library(janitor)
names(small_game) <- clean_names(small_game) |> names()

library(tidyverse)
small_game_wider <- pivot_longer(small_game,
                                 cols=c(4:362),
                                 names_to = "county",
                                 values_to = "number")








#### Making functions ####

library(tidyverse)
library(palmerpenguins)
penguins

penguin_plot_function <- function(data, species, line_method) {
  data |>
  filter(species == {{species}}) |>
    ggplot(aes(x=body_mass_g, y= bill_length_mm)) +
    geom_point() +
    geom_smooth(method = line_method) +
    theme_classic()+
    labs(x = "Body mass (g)", y = "Bill length (mm)", title = species)
}


penguin_plot_function(penguins, "Adelie", loess)


#### Making packages in r ####
install.packages("devtools")
library(devtools)

package_path = "/Users/mariaasfjelldal/Desktop/NMBU batlab/Courses/Open Science 24/pengUINsMari"
usethis::create_package(path = package_path)


#### Using targets ####

install.packages("tarchetypes")
library(tarchetypes)

usethis::use_course("biostats-r/targets_workflow_svalbard")





#### git and Github ####



