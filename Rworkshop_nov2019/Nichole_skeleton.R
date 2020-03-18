# STROOP DATA
# Participant: Participant identifier 
# taskID: color stroop task or a spatial stroop task
# stimulus_ID: relevant stimulus dimension ex. color or position of the letters
# stimulus_distractor: irrelevant stimulus dimension ex. word
# stimulus_congruency: whether or not the word and color of letters match (congruent vs incongruent)
# response_ID: participant response (supposed to respond with color of letters)      
# accuracy: 1 = correct, 0 = incorrect
# rt: reaction time               


#### NICHOLE'S PART ###

# Question we want to know:
# How is reaction time related to accuracy and congruency?

# how to write a model for our question
# question: What is the effect of congruency and accuracy on reaction time?
lm()
# Same thing but shorter eqn
lm() %>% summary

## Linear mixed effects model
#The goal of a linear mixed effects model is to estimate the fixed effects (i.e., accuracy and congurency) while controlling for random variance.

## Model terms: Fixed vs. random effects 
# In general, fixed effects are the variables we expect to have an effect on the dv and random effects are factors we are trying to control. Sources of random variance, for example could be variance between individuals.

stroop_clean%>%
  group_by(participant) %>% 
  summarise(avgRT=mean(rt), sd = sd(rt), se = sd/sqrt(numSubs)) %>%
  ggplot(aes(x=participant, y = avgRT, fill = participant)) +
  geom_bar(stat = "summary", fun.y = "mean") +
  geom_errorbar(aes(ymin=avgRT-se, ymax=avgRT+se))+
  theme_classic()

# mean rts by subject
with(stroop_clean, aggregate(rt ~ participant, FUN = "mean"))


# We can model individual differences by assuming different individual random intercepts
# We will be using lmer from lme4 because it allows us to add random effects like random intercepts or slopes

# lmer will help us estimate the mean for each participant, by adding a random intercept for each participant
# Here '(1|participant)' is the syntax for a random intercept 
# Note that it’s considered best practice that random effects have at least 5 levels, otherwise it should be used as a fixed effect
# It assigns a different intercept or different baseline level for each subject. 
# Now your model expects that there’s going to be multiple responses per participant, and these responses will vary relative to each participant’s baseline level. This effectively resolves the non-independence that stems from having multiple responses by the same subject.


# Edited Question: Controlling for the random variation across participants, how does the congruency of the trial and accuracy on the trial predict reaction time?
lmer() %>% summary


## Output
# intercept = mean of each subject’s deviation from intercept mean
# fixed effect = grand slope mean 

# for a cleaner ANOVA format output
lmer() %>% anova

# extracting coefficients
mdl <- lmer() 
coef()

# note: model has a separate intercept for each subject, but parameter estimate (i.e. slope) is constant for across rt and stim congruency


# There can also be variance of the fixed effects within each subject. This would be the random slope.
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
lmer() %>% summary

# We get isSingular error which means we don't have enough data to estimate the random slopes
# Output:
# intercept = mean of each subject’s deviation from intercept mean
# fixed effect = the mean of each subject’s deviation from the slope mean
# corr = does someone who has a high intercept also have a high slope
  
# We now see that a unique parameter estimate for each participant was generated
mdl2 <- lmer()
coef()

# Try taking out one of the random slopes (taking out congruency)
lmer() %>% anova


# Pairwise comparisons
mdl3<-lmer() 
emmeans(mdl3,pairwise~stimulus_congruency)




### ONLY GO OVER IF TIME
# see variablity in response across participants
ranef(mdl)
random.effect.mdl <- ranef(mdl) 
# The condVar argument of the ranef function tells R to compute the variability in response conditional on each random effect at a time. Set condVar to True when there are more than one random effects
qrr2 <- lattice::dotplot(random.effect.mdl, strip = FALSE)
print(qrr2[[1]]) 



