# R Workshop - Session 2 July 22, 2020
# Author: Nichole Bouffard
# This script runs the anovas and t tests for single item recognition. It uses the package afex to run anovas and plot effects.

#--------------------------------------#

# Load in the three packages below. (Note, if you don't already have them downloaded you can uncomment the "install.packages" lines (delete #) and run those first, then load them using the library() line.)

# tidyverse - useful datawrangling functions, piping, and ggplot 
# afex - this is package I like to use to run my stats. It has a function "aov_ez" that I use instead of "aov". It takes a more intutive input compared the aov formulas 
# emmeans - for running the pairwise comparisons (t tests) after the anova
 
## libraries -----
# install.pacakges(tidyverse)
library(tidyverse)
# install.packages(afex)
library(afex)
#install.packages(emmeans)
library(emmeans)
#

#--------------------------------------#

### SINGLE ITEM RECOGNITION ###

## Read in data -----
sirdat <-

# Data wrangle from wide to long format (long = one observation per row)
sirdat <-

# Look at how the different variables are categorized. Change grouping factors to factors


### DESCRIPTIVE STATISTICS ###

## Calculate number of subjects
# Younger Adults

# Older Adults


# Plot Data - Qplot

# Add boxplot


# Compute means and standard deviation  
sirdat_summary<-
# Compute standard error
sirdat_summary<-
# Range, median

# Check balance w ezDesign
#install.packages('ez')
library(ez)

#--------------------------------------#
## ANOVA 2x2x3 (group, stimulus, condition)
# This is something I like to run at the top of my scripts. It basically sets up your environment to do contrast coding so your contrasts sum to zero (the default in R is not to do this)
set_sum_contrasts()

# Model1
mdl1<-

# print the output of the anova


# Run the post hoc t tests.
# You can play around with this and add different variables to contrast by

# Bonferroni adjustment

# Can see how the contrasts were coded using coef()

#--------------------------------------#
## Object Recognition ANOVA 2x3 (group, condition)
# Filter only object data
sirdat_object <- 

mdl2<-

# print the table

# Plot effects

## Posthoc t tests 

#--------------------------------------#
## Scene Recognition ANOVA 2x3 (group, condition)
# Filter only scene data
sirdat_scene <- 

mdl3<-

# print table

# Plot effects

## Posthoc t tests

#--------------------------------------#
# Helpful resources/links
 
# Data wrangling cheat sheet
#  https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# Afex guide
# https://cran.r-project.org/web/packages/afex/afex.pdf

# Learning Stats with R by Danielle Navarro
# https://learningstatisticswithr.com/