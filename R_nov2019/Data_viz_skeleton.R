# Initialize packages
suppressWarnings(library(tidyverse))
suppressWarnings(library(afex))
suppressWarnings(library(lme4))
suppressWarnings(library(lmerTest))
suppressWarnings(library(emmeans))
suppressWarnings(library(ggplot2))


# STROOP DATA
# Participant: Participant identifier 
# trial_number
# taskID: color stroop task or a spatial stroop task
# stimulus_ID: relevant stimulus dimension ex. color or position of the letters
# stimulus_distractor: irrelevant stimulus dimension ex. word
# stimulus_congruency: whether or not the word and color of letters match (congruent vs incongruent)
# response_ID: participant response (supposed to respond with color of letters)      
# accuracy: 1 = correct, 0 = incorrect
# rt: reaction time               

# load in data
stroop<-read.csv('/Users/Stephanie/Dropbox/Baycrest_Rworkshop/PART 2/stroop_data.csv')

# make participant a factor
stroop$participant<-as.factor(stroop$participant)

# number of trials per subject
stroop_clean %>% 
  group_by(participant) %>% 
  summarise(numTrials=length(trial_number))

###-----------------------START OF DATA VIZ-----------------------###

## DATA VISUALIZATION
# BOXPLOT
box <- stroop_clean %>%
  filter(accuracy == 1) %>% 
  ggplot(aes(participant, rt, colour = participant, alpha = 0.2)) +
  geom_boxplot(varwidth=T)

box

boxplot <- box +
  geom_hline(yintercept=200, linetype="dashed", color = "black") +
  labs(title = "Box Plot",
       subtitle = "Reaction time by participant",
       x = "Participant ID",
       y = "Reaction Time (ms)") +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.grid.major = element_line(colour = "gray87"),
        panel.grid.minor.y = element_line(colour = "gray90")) +
  facet_grid(stimulus_congruency ~ .)

boxplot

# how do I change width to make it reader-friendly?

# VIOLIN PLOT
stroop_clean %>% 


# how would you change the colour of your points?

# how would we demarcate a cut off point?

# how do I save this onto my computer?
# first we have to name it, let's call it violint plot
# set your path to wherever you want the files to be saved

ggsave()

# SCATTERPLOT
stroop_clean %>% 
  ggplot() +
  geom_point() +
  stat_summary() +
  stat_summary() 

# why does this look so ugly?

# make a new df that just has the mean rt values for congruent and incongruent trials per particpant


# now pipe this into ggplot 
stroop_clean %>% 
  group_by(participant, stimulus_congruency) %>% 
  summarise(mean_rt = mean(rt)) %>% 

# check out cowplot and ggthemes for even cooler plot themes
# https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
# https://ggplot2.tidyverse.org/reference/ggtheme.html

# HEATMAP
View(Seatbelts) # built-in R dataset

# first we need to convert our dataset into a correlation matrix
# we can use the base R cor function


# to make this into a heatmap, we need to convert from wide to long format
# we use melt for this, which comes from the reshape2 package
library(reshape2)

# value here indicates the correlation between the two variables

# use geom_tile to make our heatmap

heatmap

# But this is boring, how woudl we customize the colours?
# geom_tile(aes(fill = value)) +
# scale_fill_gradient(low = "pink", high = "slateblue3") 

# let's spice this up a bit more
heatmap +
  scale_fill_gradient2() +

# This heatmap tutorial was based on work previously published on STHDA: 
# http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

# See link below for other ways to customize this
# http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

# Side note, you can also use the function heatmap to create similar correlation matrices
# See link below on how to use that:
# https://www.datanovia.com/en/lessons/heatmap-in-r-static-and-interactive-visualization/