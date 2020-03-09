# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library(tidyverse)

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
library(datamicroarray)

my_data_raw <- data('gravier', package = 'datamicroarray') #read_tsv(file = "data/_raw/my_raw_data.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
my_data <- tibble(my_data_raw) # %>% ...
my_data <- mutate(as_tibble(pluck(gravier,"x")),y=pluck(gravier,"y"),pt_id=1:length(pluck(gravier, "y")),age=round(rnorm(length(pluck(gravier,"y")),mean=55,sd=10),1))
my_data <- rename(my_data,event_label=y)
my_data$age_group=cut(my_data$age,breaks=seq(10, 100, by=10))

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = my_data,
          path = "data/01_my_data.tsv")
