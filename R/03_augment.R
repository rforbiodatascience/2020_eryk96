# Clear workspace
# ------------------------------------------------------------------------------
rm(list = ls())

# Load libraries
# ------------------------------------------------------------------------------
library("tidyverse")

# Define functions
# ------------------------------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data
# ------------------------------------------------------------------------------
my_data_clean <- read_tsv(file = "data/02_my_data_clean.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
my_data_clean_aug <- my_data_clean # %>% ...

# Augment PCA
my_pca <- my_data_clean_aug %>%
  select(1:50) %>%
  prcomp(center = TRUE, scale. = TRUE)

print(my_pca)

my_data_clean_aug <- my_pca %>% 
  broom::augment(my_data_clean_aug)

# K means on PCA
my_k_pca <- my_data_clean_aug %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = 2)

my_data_clean_aug <- my_k_pca %>%
  broom::augment(my_data_clean_aug) %>% 
  rename(cluster_pca = .cluster)

# K means on original dataset
my_k_org <- my_data_clean_aug %>%
  select(1:50) %>%
  kmeans(centers = 2)

my_data_clean_aug <- my_k_org %>%
  broom::augment(my_data_clean_aug) %>% 
  rename(cluster_org = .cluster)

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = my_data_clean_aug,
          path = "data/03_my_data_clean_aug.tsv")