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
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")

# Wrangle data
# ------------------------------------------------------------------------------
#my_data_clean_aug %>% ...

# Model data
# ------------------------------------------------------------------------------

my_pca <- my_data_clean_aug %>%
  select_if(is.numeric) %>%
  select(1:50) %>%
  prcomp(center = TRUE, scale. = TRUE) %>% 
  broom::tidy("pcs")

success_rate <- my_data_clean_aug %>%
  select(event_label, cluster_org, cluster_pca) %>%
  mutate(cluster_org = case_when(cluster_org == 1 ~ "good",
                                 cluster_org == 2 ~ "poor"),
         cluster_pca = case_when(cluster_pca == 1 ~ "good",
                                 cluster_pca == 2 ~ "poor"),
         cluster_org_correct = case_when(event_label == cluster_org ~ 1,
                                         event_label != cluster_org ~ 0),
         cluster_pca_correct = case_when(event_label == cluster_pca ~ 1,
                                         event_label != cluster_pca ~ 0)) %>% 
  summarise(score_org = mean(cluster_org_correct),
            score_pca = mean(cluster_pca_correct))

# Visualise data
# ------------------------------------------------------------------------------

my_data_clean_aug %>% 
  ggplot(aes(x = .fittedPC1, y = .fittedPC2, colour = event_label)) +
  geom_point()

my_pca %>% 
  ggplot(aes(x = PC, y = percent)) +
  geom_col() +
  theme_bw()

# Write data
# ------------------------------------------------------------------------------
write_tsv(x = success_rate, path = 'results/04_my_data_clean_ann.tsv')

ggsave("results/pca.pdf")