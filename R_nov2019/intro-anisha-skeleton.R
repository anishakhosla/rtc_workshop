# Initialize packages
suppressWarnings(library(tidyverse))
suppressWarnings(library(afex))
suppressWarnings(library(lme4))
suppressWarnings(library(emmeans))
suppressWarnings(library(ggplot2))


# Set working directory
setwd()

# Load dataset
stroop = read.csv()


# STROOP DATA
# Participant: Participant identifier 
# taskID: color stroop task or a spatial stroop task
# stimulus_ID: relevant stimulus dimension ex. color or position of the letters
# stimulus_distractor: irrelevant stimulus dimension ex. word
# stimulus_congruency: whether or not the word and color of letters match (congruent vs incongruent)
# response_ID: participant response (supposed to respond with color of letters)      
# accuracy: 1 = correct, 0 = incorrect
# rt: reaction time               


## Describe data
# Number of subjects
numSubs <- 

print(numSubs)

# Number of trials per subject
numTrials <- 

numTrials


table()

table()

# Look at structure of dataframe (class of variables)


# Make participant a factor
stroop$participant<-

# Visualize Outliers

theme_set(theme_bw(base_size = 18))

qplot(taskID, rt, facets = . ~ participant, 
      colour = participant, geom = "boxplot", data = stroop) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Remove Outliers

stroop_clean<- 

# Number of trials per subject

table()


# Visualize again (w/o outliers)
qplot(taskID, rt, facets = . ~ participant, 
      colour = participant, geom = "boxplot", data = stroop_clean) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Can also split by congruency
qplot(stimulus_congruency, rt, facets = . ~ participant, 
      colour = participant, geom = "boxplot", data = stroop_clean) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Questions:
# How are accuracy and reaction time affected by congruency and task ID?
# How is rt affected by accuracy and congruency? (linear mixed effects model)

# Setting contrasts to be orthogonal (sum to zero)
# the intercept term will be the grand mean
options(contrasts=c('contr.sum','contr.poly'))
# Same thing using afex
afex::set_sum_contrasts()

# more on contrasts: http://www.clayford.net/statistics/tag/sum-contrasts/

## ANOVA
# in afex
# uses car::Anova i.e. type 3 SS


afex::aov_ez(stroop_clean, id = , dv =, within = )


# in aov_car
# For type 2 or 3 SS, use Anova. But we can't specify random effects with Anova(lm) so we can use afex::aov_car
# aov car uses car::Anova as backend calculations unlike base R aov

aov_car(rt ~  taskID*stimulus_congruency + Error(participant/taskID*stimulus_congruency), data = stroop_clean) # uses car::Anova

