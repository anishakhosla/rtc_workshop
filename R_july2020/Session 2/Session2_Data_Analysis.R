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
sirdat <- read_csv('/Users/nicholebouffard/Dropbox/Baycrest_Rworkshop/2020/part2/SngItmRec.csv') # I'm using read_csv here instead of read.csv. You must have the tidyverse loaded first before you can use read_csv, but it reads your data into a tibble way quicker and more efficient than reading your data into a data.frame using read.csv
# Can navigate to folder, setwd, then:
#sirdat <- read_csv('SingItmRec.csv')

# Data wrangle from wide to long format (long = one observation per row)
sirdat <- sirdat %>% #shortcut to pipe = command+shift+M
  gather(condition, hit_minus_fa,4:6) # can also do DO_SS:SO_SS
# Look at how the different variables are categorized. Change grouping factors to factors
str(sirdat)
sirdat$subid <- as.factor(sirdat$subid)
sirdat$stimulus<- as.factor(sirdat$stimulus)
sirdat$group <- as.factor(sirdat$group)
sirdat$condition <- as.factor(sirdat$condition)
str(sirdat)

### DESCRIPTIVE STATISTICS ###

# What do we get if we just try summary?
summary(sirdat$group)
nlevels(sirdat$subid)

## Calculate number of subjects
# Younger Adults
nYA <- length(unique(sirdat$subid[sirdat$group == 'YA'])) #31

# Older Adults
OA <- sirdat %>%  
  filter(group == 'OA') 
nOA <- length(unique(OA$subid)) #28

# Plot Data - Qplot
qplot(x=condition, y=hit_minus_fa, data=sirdat)
# Add boxplot
qplot(x=condition, y=hit_minus_fa, data=sirdat, geom='boxplot')
# can add another variable using color
qplot(x=condition, y=hit_minus_fa, color = stimulus, data=sirdat, geom='boxplot')


# Compute means and standard deviation  
sirdat_summary <- sirdat %>% 
  group_by(condition, stimulus, group) %>% 
  summarise(mean = mean(hit_minus_fa), sd = sd(hit_minus_fa))

# Compute standard error
sirdat_summary <- sirdat_summary %>% 
  mutate(n = ifelse(group == 'YA', nYA, nOA)) %>% 
  mutate(se = sd/sqrt(n))

# Range, median
range(sirdat$hit_minus_fa)
median(sirdat$hit_minus_fa)

# Check balance w ezDesign
#install.packages('ez')
library(ez)
ezDesign(sirdat, x=subid, y=condition)

# Another way:
with(sirdat, table(subid,condition))


########## PAUSE FOR POLL #############

#--------------------------------------#
## ANOVA 2x2x3 (group, stimulus, condition)
# This is something I like to run at the top of my scripts. It basically sets up your environment to do contrast coding so your contrasts sum to zero (the default in R is not to do this)
set_sum_contrasts()

# Model1
mdl1<-aov_ez(id = 'subid',
             dv = 'hit_minus_fa',
             data = sirdat,
             between = 'group',
             within = c('condition', 'stimulus'))

# print the output of the anova
mdl1

# Plot effects
afex_plot(mdl1, "condition","stimulus")

# Run the post hoc t tests.
# Compute marginal means using emmeans() and paired comparisons using pairs()
# estimated marginal means take into account missing data/unbalanced data. Gives equal weight to each cell
emmeans(mdl1, 'condition')
# Paired comparisons
# emmeans uses pooled variances and degrees of freedom (based on the Welch–Satterthwaite equation). Because it uses pooled variances, there are fewer parameters to estimate, and therefore the degrees of freedom are higher.
pairs(emmeans(mdl1, 'condition'))
# Bonferroni adjustment
pairs(emmeans(mdl1, 'condition'), adjust='bonferroni')
# You can play around with this and add different variables to contrast by
pairs(emmeans(mdl1, 'stimulus'))
pairs(emmeans(mdl1, c('condition','stimulus')))

# Can see how the contrasts were coded using coef()
coef(pairs(emmeans(mdl1, 'condition')))

#--------------------------------------#
## Object Recognition ANOVA 2x3 (group, condition)
# Filter only object data
sirdat_object <- sirdat %>% 
  filter(stimulus == 'object')

mdl2<-aov_ez(id = 'subid',
             dv = 'hit_minus_fa',
             data = sirdat_object,
             between = 'group',
             within = 'condition',
             anova_table= list(es = "pes"))

# print the table
mdl2
# Plot effects
afex_plot(mdl2, "condition","group")

## Posthoc t tests 
pairs(emmeans(mdl2, 'condition'))
pairs(emmeans(mdl2, 'group'))
pairs(emmeans(mdl2, c('condition','group')))
#--------------------------------------#
## Scene Recognition ANOVA 2x3 (group, condition)

########## PAUSE FOR POLL #############

# Filter only scene data
sirdat_scene <- sirdat %>% 
  filter(stimulus == 'scene')

mdl3<-aov_ez(id = 'subid',
             dv = 'hit_minus_fa',
             data = sirdat_scene,
             between = 'group',
             within = 'condition',
             anova_table= list(es = "pes"))

# print table
mdl3
# Plot effects
afex_plot(mdl3, "condition","group")

## Posthoc t tests
pairs(emmeans(mdl3, 'condition'))
pairs(emmeans(mdl3, 'group'))
pairs(emmeans(mdl3, c('condition','group')))

#--------------------------------------#
# Helpful resources/links
 
# Data wrangling cheat sheet
#  https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# Afex guide
# https://cran.r-project.org/web/packages/afex/afex.pdf

# Learning Stats with R by Danielle Navarro
# https://learningstatisticswithr.com/