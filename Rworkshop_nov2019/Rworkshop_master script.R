# Initialize packages
suppressWarnings(library(tidyverse))
suppressWarnings(library(afex))
suppressWarnings(library(lme4))
suppressWarnings(library(emmeans))
suppressWarnings(library(ggplot2))


# Set working directory
setwd("/Users/anishakhosla/Desktop")

# Load dataset
stroop = read.csv("stroop_data.csv")

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

numSubs <- length(unique(stroop$participant))

print(numSubs)

# Number of trials per subject
numTrials <- stroop %>% 
  group_by(participant) %>% 
  summarise(numTrials = length(rt))

numTrials

table(stroop$participant)

table(stroop$participant, stroop$taskID)

# Look at structure of dataframe (class of variables)
str(stroop)

# Make participant a factor
stroop$participant<- as.factor(stroop$participant)

# Visualize Outliers

theme_set(theme_bw(base_size = 18))

qplot(taskID, rt, facets = . ~ participant, 
      colour = participant, geom = "boxplot", data = stroop) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Remove Outliers

stroop_clean<- stroop %>% 
  filter(rt < 1500)

# Number of trials per subject

table(stroop_clean$participant)

# Visualize again (w/o outliers)
qplot(taskID, rt, facets = . ~ participant, 
      colour = participant, geom = "boxplot", data = stroop_clean) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Can also split by congruency
qplot(stimulus_congruency, rt, facets = . ~ participant, 
      colour = participant, geom = "boxplot", data = stroop_clean) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


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
  filter(accuracy == "0") %>% 
  ggplot(aes(taskID, rt, colour = taskID, fill = taskID)) +
  geom_violin() +
  labs(title = "Violin Plot for Inaccurate Responses",
       x = "Task",
       y = "Reaction Time (ms)") +
  geom_point(size = 1.3, 
             alpha = .2,
             position = position_jitter(width = 0.4)) +
  scale_fill_brewer() +
  scale_color_brewer() +
  geom_hline(yintercept=1000, linetype="dashed", color = "black") + 
  theme_minimal() +
  theme(legend.position = "right")

# how would you change the colour of your points?

# how would we demarcate a cut off point?

# how do I save this onto my computer?
# first we have to name it, let's call it violint plot
# set your path to wherever you want the files to be saved

ggsave("My Violin Plot.png", plot = violinplot, 
       path = "~/Dropbox/Baycrest_RWorkshop/Part 2/figures", 
       dpi = 300, width = 8, height = 6, units = "in")

# SCATTERPLOT
stroop_clean %>% 
  ggplot(aes(x = stimulus_congruency, y = rt)) +
  geom_point(shape = 19, alpha = 0.4, size = 2.5, position = position_jitter(width = 0.4)) +
  stat_summary(fun.y = mean, geom = "point", size = 3, fill = "red", color = "red") +
  stat_summary(fun.data = "mean_se", geom = "errorbar",
               width = 0.3, show.legend = FALSE, color = "red") 

# why does this look so ugly?

# make a new df that just has the mean rt values for congruent and incongruent trials per particpant
stroop_clean %>% 
  group_by(participant, stimulus_congruency) %>% 
  summarise(mean_rt = mean(rt)) 

# now pipe this into ggplot 
stroop_clean %>% 
  group_by(participant, stimulus_congruency) %>% 
  summarise(mean_rt = mean(rt)) %>% 
  ggplot(aes(x = stimulus_congruency, y = mean_rt, color = participant)) +
  geom_point(shape = 19, alpha = 0.4, size = 2.5, 
             position = position_jitter(width = 0.1)) +
  stat_summary(fun.data=mean_se, fun.args = list(mult=1), 
               geom="errorbar", color="black", width=0.1) +
  stat_summary(fun.y = mean, geom = "point", size = 3, shape = 8, color = "black") +
  labs(title = "Scatterplot",
       subtitle = "Including participant-level data",
       x = "Condition",
       y = "Mean Reaction Time (ms)") +
  scale_x_discrete(labels = c("Congruent", "Incongruent")) +
  theme_minimal() +
  theme(legend.position = "none", 
        axis.title = element_text(face = "bold", size = 14))

# check out cowplot and ggthemes for even cooler plot themes
# https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
# https://ggplot2.tidyverse.org/reference/ggtheme.html

# HEATMAP
View(Seatbelts) # built-in R dataset

# first we need to convert our dataset into a correlation matrix
# we can use the base R cor function
matrix <- round(cor(Seatbelts), 2)
head(matrix)

# to make this into a heatmap, we need to convert from wide to long format
# we use melt for this, which comes from the reshape2 package
library(reshape2)
seat_melt <- melt(matrix)
head(seat_melt) # value here indicates the correlation between the two variables

# use geom_tile to make our heatmap
heatmap <- seat_melt %>% 
  ggplot(aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white")

heatmap

# But this is boring, how woudl we customize the colours?
# geom_tile(aes(fill = value)) +
# scale_fill_gradient(low = "pink", high = "slateblue3") 

# let's spice this up a bit more
heatmap +
  scale_fill_gradient2(low = "palevioletred1", high = "slateblue3", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") + #/n is like the "return" key
  coord_fixed() + # make it into a square
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 2.5) + # add the r values
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))

# This heatmap tutorial was based on work previously published on STHDA: 
# http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

# See link below for other ways to customize this
# http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

# Side note, you can also use the function heatmap to create similar correlation matrices
# See link below on how to use that:
# https://www.datanovia.com/en/lessons/heatmap-in-r-static-and-interactive-visualization/

###-----------------------END OF DATA VIZ-----------------------###

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

afex::aov_ez(stroop_clean, id = "participant", dv = "rt", within = c("taskID", "stimulus_congruency"))


# in aov_car
# For type 2 or 3 SS, use Anova. But we can't specify random effects with Anova(lm) so we can use afex::aov_car
# aov car uses car::Anova as backend calculations unlike base R aov

aov_car(rt ~  taskID*stimulus_congruency + Error(participant/taskID*stimulus_congruency), data = stroop_clean) # uses car::Anova




#### NICHOLE'S PART ###

# Questions that we want to know:
# How is reaction time related to accuracy and congruency?

## Linear mixed effects model

# how to write a model
lm(rt ~ stimulus_congruency + accuracy + stimulus_congruency*accuracy, data =stroop_clean) %>% summary
# Same thing but shorter eqn
lm(rt ~ stimulus_congruency*accuracy, data = stroop_clean) %>% summary


# The goal of a linear mixed effects model is to estimate the fixed effects (i.e., accuracy and congurency) while controlling for random variance. In general, fixed effects are the variables we expect to have an effect on the dv and random effects are factors we are trying to control. Sources of random variance could be variance between individuals, or variance between stimulus types. These would be modeled as random intercepts. 

stroop_clean%>%
  group_by(participant) %>% 
  summarise(avgRT=mean(rt), sd = sd(rt), se = sd/sqrt(numSubs)) %>%
  ggplot(aes(x=participant, y = avgRT, fill = participant)) +
  geom_bar(stat = "summary", fun.y = "mean") +
  geom_errorbar(aes(ymin=avgRT-se, ymax=avgRT+se))+
  theme_classic()

# mean rts by subject
with(stroop_clean, aggregate(rt ~ participant, FUN = "mean"))


# We can model these individual differences by assuming different random intercepts
# We will be using lmer from lme4 because it allows us to add random effects like random intercepts or slopes

# Question: Controlling for the random variation across participants (and tasks), how does the congruency of the trial and accuracy on the trial predict reaction time?

# lmer will help us estimate the mean for each participant, by adding a random intercept for each participant
# here '(1|participant)' is the syntax for a random intercept 
# it means we are assuming a different intercept or different baseline level for each subject. “1” stands for the intercept here.
# Now your model expects that there’s going to be multiple responses per participant, and these responses will depend on each participant’s baseline level. This effectively resolves the non-independence that stems from having multiple responses by the same subject.

lmer(rt ~ stimulus_congruency*accuracy+(1|participant), data=stroop_clean) %>% summary

## Output
# Random effects: Tells you how much variance you find among levels of your grouping factors and the residual vaiance
# Fixed effects: This part is similar to a linear model output. Gives intercept and error, slope estimate and error


# for a cleaner ANOVA format output
lmer(rt ~ stimulus_congruency*accuracy+(1|participant), data=stroop_clean) %>% anova

mdl <- lmer(rt ~ stimulus_congruency*accuracy+(1|participant), data=stroop_clean)

# extracting coefficients
coef(mdl)

# note: model has a separate intercept for each subject, but parameter estimate (i.e. slope) is constant for across accuracy and stim congruency


# see variablity in response across participants
ranef(mdl)
random.effect.mdl <- ranef(mdl) 
# The condVar argument of the ranef function tells R to compute the variability in response conditional on each random effect at a time. Set condVar to True when there are more than one random effects
qrr2 <- lattice::dotplot(random.effect.mdl, strip = FALSE)
print(qrr2[[1]]) 


#There can also be variance of the fixed effects within each subject. This would be the random slope.
# RT varition across congruency
stroop_clean%>% 
  ggplot(aes(x = stimulus_congruency, y = rt, fill = stimulus_congruency)) +
  stat_summary(fun.y = mean, geom = "bar") +
  stat_summary(fun.data = "mean_se", geom = "errorbar",
               width = 0.1, show.legend = FALSE) +
  facet_wrap(~ participant) +
  xlab("congruency") + ylab("rt") +
  theme_classic()

# RT variation across accuracy
stroop_clean%>% 
  ggplot(aes(x = accuracy, y = rt, fill = accuracy)) +
  stat_summary(fun.y = mean, geom = "bar") +
  stat_summary(fun.data = "mean_se", geom = "errorbar",
               width = 0.1, show.legend = FALSE) +
  facet_wrap(~ participant) +
  xlab("accuracy") + ylab("rt") +
  theme_classic()

# Predicting reaction times from congruency and accuracy, controlling for random slopes of congruency and accuracy and random intercept of participant
# in lmer
lmer(rt ~ stimulus_congruency*accuracy+(stimulus_congruency*accuracy|participant), data=stroop_clean) %>% anova

# We get isSingular error which means we don't have enough data to estimate the random slopes
lmer(rt ~ stimulus_congruency*accuracy+(stimulus_congruency|participant), data=stroop_clean) %>% anova # fails to converge
lmer(rt ~ stimulus_congruency*accuracy+(accuracy|participant), data=stroop_clean) %>% anova


# Pairwise comparisons
mdl<-lmer(rt ~ stimulus_congruency*accuracy+(accuracy|participant), data=stroop_clean) 
emmeans(mdl,pairwise~stimulus_congruency)





## OTHER QUESTIONS
# Question: Is there an association between rt and congruency after controlling for the variation in participants 
lmer(rt ~ stimulus_congruency*taskID +(1|participant), data=stroop_clean) %>% anova

# pairwise comparison using emmeans
mdl <- lmer(rt ~ stimulus_congruency*taskID +(1|participant), data=stroop_clean)
emmeans(mdl,pairwise~stimulus_congruency)
emmeans(mdl,pairwise~taskID)



## R tutorial based on Bodo Winter's tutorial. They also discuss model comparison
# https://web.stanford.edu/class/psych252/section/Mixed_models_tutorial.html
# also check out linear mixed effects models by Bodo Winter
# Barr, Levy, Scheepers, & Tilly, 2013 for debate on whether we should keep models maximal or not i.e. should we include all random effects even if they don't ipprove our model
# lmerTest for p values