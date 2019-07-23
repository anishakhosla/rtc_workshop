## Introduction to R Workshop (July 22, 2019)

# Editors: Anisha Khosla, Nichole Bouffard, Stephanie Simpson

# NOTE: workshop inspired from PSY1210 by Dr. Katherine Duncan and Michael Mack at University of Toronto, 
# past U of T coders R workshops, PSY252 by Tobi Gerstenberg at Stanford University

################################################################
### RStudio ###

## 4 panels
#Top left: Script viewer - write your code to save it for future use
#Bottom left: Console - this is where R is actually running
#Top right: Variable/history displayer
#Bottom right: Files/plots/packages/help displayer

## Script vs Console
# Console: type commands directly to see their result. This is not saved
# Script editor: Save your code for later. 

## Shortcuts
# TAB -- autocomplete
# control/cmd + enter -- run current line from the script in console


################################################################
### R Resources ###

# Resources: 
# PSY252: https://psych252.github.io/
# Book (PSY252): https://psych252.github.io/psych252book/
# cheatsheets (from https://psych252.github.io/)
# Book: Introduction to Probability and Statistics using R by G. Jay Kerns
# U of T coders: https://uoftcoders.github.io/studyGroup/lessons/ 

################################################################
### PACKAGES ###

## Installing Packages

install.packages('tidyverse')

# check if it has been installed already
installed.packages('tidyverse')

# to view a list of installed packages
installed.packages()

## Loading Packages

library(tidyverse)
library(readxl) # for excel
library(data.table) # for setnames
library(knitr)

################################################################
### BASICS ###

# We can use comments using a hash sign

## Commonly used variables in R

# numeric
n <- 1 
# str() displays the type of object
str(n) 

# character
c <- '4'
str(c)  

identical(3, '3')

# logical: TRUE, FALSE
l <- TRUE
str(l)

# not available: NA

# converting numeric to character
as.numeric(c)

as.character(n)

## Getting help

help.start()   # general help
help(print)    # help about function print
?print         # same as above
example(print) # shows an example of function print

## Data Types in R

# vectors, factors, matrix, array, dataframe, list
# for more see https://www.statmethods.net/input/datatypes.html

## Vectors

my_vector <- c(8,0,9.9,6,-1,4)
my_vector[1] # access first element 
# note: in R, the indexing begins with 1 (0 in Python)
my_vector[3:5] # access 3rd to 5th elements
my_vector[c(1, 3)] # access first and last element

mean(my_vector)
max(my_vector)

## Factors

# factos are grouping variables in data

as.factor(n)
groups <- factor(c("red","green", "red", "green"))
levels(groups)

## Setting your working directory

# Set the location i.e.working directory.  This is where R will look for files you want to load. 
setwd()

# sample working directory for MAC users
setwd("/Users/anishakhosla/Desktop/r_workshop")


# sample working directory for PC users
#setwd("C:\\Users\\akhosla\\Desktop\\r_workshop")

################################################################
### DATAFRAMES ###

# read in data from .csv to a dataframe
coffeeData <- read.csv('fake_dataR.csv')

# EXPLAIN DATA
View(coffeeData)

str(coffeeData)

# different ways of exploring your data
summary(coffeeData)
dim(coffeeData)
head(coffeeData)
names(coffeeData)

# to select/view a single column
coffeeData$participantID

#### INTERACTIVE ###
# Use what we learned about indexing into vectors

coffeeData$participantID[1]  # participant number from the 1st row
coffeeData$participantID[40] # participant number from the 40th row

coffeeData$participantID[1:3]


## Pipe operator
# inserts the results from the previous function into the next function
# it allows us to do step-by-step actions in an intuitive way
# shortcut is cmd/ctrl + shift + m

# (x) rewritten as x %>% f

x <- 1:4
sum(x) # without pipe

x %>% sum() # with pipe

# filter--we can define a set of conditions that we want to filter the rows of our data frame by
coffeeData %>% 
  filter(participantID == 'pilot')

# select--same as filter but allows for subsetting columns instead
coffeeData %>% 
  select(participantID, accuracy)

# the - operator can be used to exclude a column
coffeeData %>% 
  select(-accuracy)

# why pipe? 
# note: arrange() sorts data

arrange(filter(select(coffeeData, participantID, contains('uent'), accuracy), participantID=='pilot'), accuracy)

coffeeData %>% 
  select(participantID, contains('uent'), accuracy) %>% 
  filter(participantID=='pilot') %>% 
  arrange(accuracy)

## Data Exploration

# distinct() shows all distinct values in a column
coffeeData %>% 
  distinct(participantID)

# count() shows the number of distinct values in a column
coffeeData %>% 
  count(participantID)

#count(coffeeDataTidy$participantID) with base R

coffeeData %>% 
  count(participantID, group)

# HAVE A BREAK

################################################################
### DATA CLEANING ###

# VIEW DATA AGAIN AND WALK THROUGH WHAT LONG AND WIDE IS

# Transform your data from wide format to long format (i.e., combine columns so that each row represents one observation)
## topics covered: piping, gather, spread, separate, unite, adding new columns, mutate


## Data Wrangling

# gather()
coffeeDataLong <- coffeeData %>%
  gather('group','rt',6:7)

# If we wanted to do the reverse function spread()
coffeeDataWide <- coffeeDataLong %>%
  spread(group,rt)

# separate()
coffeeDataSplitDates<- coffeeDataLong %>%
  separate(Date, c('year','month', 'day'))

# Inverse function unite()
coffeeDataJoinedDates <- coffeeDataSplitDates %>%
  unite(Date, year, month, day)


# Making congruent and incogruent columns 'tidy' (one obs per row)
coffeeDataLong$congruency <- 0
coffeeDataLong$congruency[coffeeDataLong$congruent == 'y'] <- 1
coffeeDataClean <- coffeeDataLong[,-c(4,5)]

# using mutate function
coffeeDataLong <- coffeeDataLong %>% 
  mutate(congruency = ifelse(congruent=='y', 1, 0))
coffeeDataClean <- coffeeDataLong[,-c(4,5)]

# Change RT column from miliseconds to second using mutate
coffeeDataTidy <- coffeeDataClean  %>%
  mutate(rt_sec=rt/1000)

# Remove unecesary NAs
coffeeDataTidy <- coffeeDataTidy  %>%
  drop_na(rt,rt_sec)

# WELLNESS CHECK IN

################################################################
### SUMMARY STATISTICS ###

# Now that we have tidy data let's get some summary statistics
# topics covered: filter, group_by, summarise

# descriptive stats of values in a column
mean(coffeeDataTidy$rt_sec)
median(coffeeDataTidy$rt_sec)
var(coffeeDataTidy$rt_sec)
sd(coffeeDataTidy$rt_sec)
range(coffeeDataTidy$rt_sec)

# Compute and store summary stats 
coffeeDataTidy %>%
  summarise(mean_RT = mean(rt), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt), 
            sd_acc=sd(accuracy))

# Summarize data by group
coffeeDataTidy %>%
  group_by(group) %>%
  summarise(mean_RT = mean(rt), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt), 
            sd_acc=sd(accuracy))

# Summarize data by group but filter out the pilot subject
coffeeDataTidy %>%
  group_by(group) %>%
  filter(participantID != 'pilot') %>%
  summarise(mean_RT = mean(rt), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt), 
            sd_acc=sd(accuracy))

################################################################
### BASIC INFERENTIAL STATISTICS ###

# 1.Do coffee drinkers have more accurate respones on the stroop task compared to water drinks?
coffeeDataTidy_ttest <- coffeeDataTidy %>% 
  filter(participantID != 'pilot')
t.test(coffeeDataTidy_ttest$accuracy[coffeeDataTidy_ttest$group == 'coffee'], 
       coffeeDataTidy_ttest$accuracy[coffeeDataTidy_ttest$group == 'water'])

# 2. Are coffee drinkers reaction times faster than water drinkers for correct responses?
coffeeDataTidy_ttest <- coffeeDataTidy %>% 
  filter(participantID != 'pilot'  & accuracy==1)

t.test(coffeeDataTidy_ttest$rt[coffeeDataTidy_ttest$group == 'coffee'], 
       coffeeDataTidy_ttest$rt[coffeeDataTidy_ttest$group == 'water'])

# 3. Is there a relationship between RT and accuracy? (correlation)
coffeeDataTidy_cor <- coffeeDataTidy %>% 
  filter(participantID != 'pilot') %>%
  group_by(participantID) %>%
  summarise(mean_rt = mean(rt), mean_acc = mean(accuracy))

cor.test(coffeeDataTidy_cor$mean_rt,coffeeDataTidy_cor$mean_acc)


# HAVE A BREAK

################################################################
library(ggthemes) # for fun ggplot themes
library(gridExtra) # for grid.arrange
library(Hmisc) # need for stat_summary

#### DATA VISUALIZATION: GGPLOT ####

# ggplot is all about the building blocks, it requires 3 things (minimum):
# 1) data = data frame being plotted
# 2) aesthetics = scale onto which we map our data, colour, line type, etc.
# 3) geometries = visual elements/ objects like points, lines, bars, etc. that shape our data
# we need to add all of these things together in order to build the complete plot

# in this tutorial, I will show you some examples of how to make a:
# scatterplot
# line graph
# bar graph
# violin plot
# box plot

# let's use our coffeeDataTidy as an example again
ggplot(coffeeDataTidy, aes(x = group, y = rt)) 

# where's our data?
# we need to add the object/shape of our data in order for it to be visible
ggplot(coffeeDataTidy, aes(x = group, y = rt)) + geom_point()

# you can also save the aesthetics and data to a variable so that you don't have to copy/ paste each time
my_graph <- ggplot(coffeeDataTidy, aes(x = group, y = rt))

# adding different geoms to the variable allows you to change the type of plot!
my_graph + geom_point()

my_graph + geom_boxplot()

my_graph + geom_point() + geom_boxplot()

# using piping (I will use this syntax from now on)
coffeeDataTidy %>%
  ggplot(aes(x = group, y = rt)) + 
  geom_point()

# SCATTERPLOT
# Q: How does reaction time vary across congruent and incongruent trials?

# using pipling, dropping NA values and removing pilot participants
# adding colour
# choosing colours and adding legend title
# adding labels, title, subtitle
# adjusting x axis scale--convert congruency variable to a factor
# adjusting x axis scale labels

coffeeDataTidy %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = as.factor(congruency), y = rt_sec, colour = group)) +
  # what would happen if we didn't set congruency as a factor?
  geom_point() +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)") +
  scale_x_discrete(labels = c("incongruent", "congruent"))

# another way to change the labels for congruent and incongruent:
# this makes a new column called congruency.new
# in that new column, we recode the numbers 0 and 1 values to their text values
coffeeDataTidy$congruency.new <- recode(coffeeDataTidy$congruency , 
                                    `0` = 'Incongruent', 
                                    `1` = 'Congruent')

# now the congruency column is saved as a character which is okay for plotting
View(coffeeDataTidy)
str(coffeeDataTidy)

# we can set x = congruency.new instead of making congruency a factor
# now run the code below and you will see that the labels have changed!

# how do we make these points more visible?
# jitter the points and adjust their alpha (transparency) level
# the lower the alpha, the more transparent the points appear
coffeeDataTidy %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = congruency.new, y = rt_sec, colour = group)) +
  geom_point(position = position_jitterdodge(), alpha = .8) +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)")

# use stat_summary to add the mean and error bars to your plot
# fun.data is a function that returns 3 values: y mix, y max, y (use it for calculating standard error or confidence intervals)
# fun.y on the other hand just returns a single value (e.g., mean, median)

coffeeDataTidy %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = as.factor(congruency.new), y = rt, colour = group)) +
  geom_point(position = position_jitterdodge(), alpha = .4, size = 1) +
  stat_summary(fun.y = mean, geom = "point", size = 2.5) +
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar",
               width = 0.1, show.legend = FALSE) +  
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  scale_x_discrete(labels = c("congruent", "incongruent")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)")

# LINE GRAPH
# Q: How does the reaction time vary across trials?
# to demonstrate line graphs, I'm using trial number as the x axis instead of congruency
# how do we filter out the NA values in rt_sec column and the pilot data?

line_graph <- coffeeDataTidy %>%
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = trial_number, y = rt_sec, group = group, color = group)) +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  stat_summary(fun.y = mean, geom = "line", size = 1.1, alpha = 0.8, show.legend = FALSE) +
  stat_summary(fun.y = mean, geom = "point", size = 3) +
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar",
               width = 0.2, show.legend = FALSE) +
  # xlim(0, 11) +
  scale_x_continuous(breaks = c(2, 4, 6, 8, 10), labels = c("2", "4", "6", "8", "10")) +
  geom_point(position = position_jitterdodge(), alpha = .4) +
  labs(title = "Line Graph: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Trial Number",
       y = "Reaction Time (s)") +
  theme_few() # add themes to make your graphs look ~fancy~

line_graph

  # Other things to explain:
  # if we used xlim(0, 11) instead of scale_x_continuous
  # ggthemes vs. ggplot2 themes
  # can create a more custom plot rather than using a template!
        # theme(title = element_text(size = 13),
          # axis.title = element_text(face = "bold", size = 11),
          # panel.background = element_rect(fill = "white", colour = "white"),
          # panel.grid.major = element_line(colour = "lightgrey"),
          # axis.ticks = element_line(colour = "white"),
          # legend.title = element_text(face = "bold"))

# BAR PLOT
# let's say this was a patient study and you were looking to see how each patient performed on the task

bar_plot <- coffeeDataTidy %>%
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = participantID, y = rt_sec, fill = group)) + # remember to use fill = for bar graphs not colour
  stat_summary(fun.y = mean, geom = "bar", width = 0.69) + # width changes how thick the bars are
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", # another option: mean_se 
               width = 0.09,
               position = position_dodge(width = 0.9)) +
  scale_fill_brewer("Group", palette = 'Spectral') +
  labs(title = "Bar Graph",
       x = "Participant",
       y = "Reaction Time (s)") +
  theme_classic()

bar_plot

# why is naming your plot useful?
# it's easy to add small changes rather than re-typing the whole code :)
bar_plot + 
  geom_point(colour = "black", size = 1.3, alpha = .7, 
             position = position_jitter(width = .2)) +
  theme_classic(base_family = "Courier") +
  theme(legend.position = "none")

# VIOLINT PLOT
violin <- coffeeDataTidy %>%
  filter(participantID != "pilot") %>% 
  ggplot(aes(group, rt, fill = group)) +
  geom_violin(colour = "white") +
  labs(title = "Violin Plot",
       subtitle = "> 3000 ms = suspected outlier",
       x = "Group",
       y = "Raw Reaction Time") +
  geom_hline(yintercept=3000, linetype="dashed", color = "black") # + 
  # geom_point(colour = "black", fill = "black", size = 1.3, alpha = .5, position = position_jitter()) +
  # scale_fill_manual("Group", values = c("darkolivegreen3", "darkgreen")) +
  # theme(legend.position = "bottom",
        # panel.background = element_rect(fill = "white", colour = "white"),
        # panel.grid.major = element_line(colour = "gray87"),
        # panel.grid.minor.y = element_line(colour = "gray90"))
violin

# BOX PLOT
box <- coffeeDataTidy %>%
  filter(participantID != "pilot") %>% 
  ggplot(aes(group, rt, fill = group)) + # use colour = group if you just want the outline to be coloured
  geom_boxplot(# notch = TRUE, 
               outlier.colour = "red", outlier.shape = 8, outlier.size = 2) +
  geom_hline(yintercept=3000, linetype="dashed", color = "black") +
  labs(title = "Box Plot",
    subtitle = "Dots represent potential outliers",
    x = "Group",
    y = "Raw Reaction Time") +
  scale_fill_manual("Group", values = c("darkgreen", "darkolivegreen3")) + # changed to scale_colour_manual if you just want the outline
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.grid.major = element_line(colour = "gray87"),
        panel.grid.minor.y = element_line(colour = "gray90"))

box

# how to combine plots together (uses the gridExtra package):
# option 1: grid.arrange
grid.arrange(violin, box, ncol = 2)

# option 2: facet_wrap
# to arrange horizontally
bar_plot +
  facet_grid(. ~ congruency.new) +
  theme_classic() 

# to arrange vertically
bar_plot +
  facet_grid(congruency.new ~ .) +
  theme_classic() 

# how to save plots
# if you don't use plot = then it will automatically save the last plot you loaded
ggsave("figure1.png", 
       plot = line_graph,
       path = "~/Desktop/figures", 
       dpi = 300, 
       width = 6, 
       height = 6, 
       units = "in")

################################################################
#### CONTROL FLOW ####


## Control Flow of Data

# if-else for conditional flow

time = 12

if(time >= 5 & time < 12){
  
  print("good morning")
  
}else if (time >= 12 & time <= 17){
  
  print("good afternoon")
  
}else{
  
  print("good night")
  
}


# for loops for repeated flow

sequence = 1:10

for(i in 1:length(sequence)){
  
  print(i)
  
}

# other things to add:
# customize shapes (https://www.datanovia.com/en/blog/ggplot-point-shapes-best-tips/)
# install wesanderson package for more "hipster" colours...
# cheatsheets: https://psych252.github.io/
             # https://www.rstudio.com/resources/cheatsheets/
# R color sheet

# Resources: 
# the ultimate guide: http://www.cookbook-r.com/
# https://psych252.github.io/psych252book/
# https://psych252.github.io/
# for practice, refer to DataCamp or free courses from edx
# U of T coders is also a very good resource
# http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3