## Introduction to R Workshop (July 22, 2019)

################################################################
### PACKAGES ###

## Installing Packages

install.packages('tidyverse')

# check if it has been installed already
installed.packages('tidyverse')

## Loading Packages

library(tidyverse)
library(readxl) # for excel
library(readr) # for csv
library(data.table) #for setnames
library(knitr)
library(ggthemes) # for fun ggplot themes
library(gridExtra)
library(psych)

################################################################
### BASICS ###

# We can use comments using a hash sign

## Commonly used variables in R

# numeric
n = 1 
# str() displays the type of object
str(n) 

# character
c = '4'
str(c)  

identical(3, '3')

# logical: TRUE, FALSE
l = TRUE
str(l)

# not available: NA

# converting numeric to character
as.numeric(c)

as.character(n)

# factors are data types used for ordinal variables
as.factor(n)

## Data Types in R

# vectors, factors, matrix, array, dataframe, list
# for more see https://www.statmethods.net/input/datatypes.html

## Vectors

my_vector <- c(8,0,9.9,6,-1,4)
numbers[1] # access first element 
# note: in R, the indexing begins with 1 (0 in Python)
numbers[3:5] # access 3rd to 5th elements
numbers[c(1, 3)] # access first and last element


## Setting your working directory

# Set the location i.e.working directory.  This is where R will look for files you want to load. 
setwd()

# sample working directory for MAC users
setwd("/Users/anishakhosla/Desktop/r_workshop")


# sample working directory for PC users
#setwd("C:\\Users\\akhosla\\Desktop\\r_workshop")

## Dataframes

# read in data from .csv to a dataframe
coffeeData <- read.csv('fake_dataR.csv')

View(coffeeData)

str(coffeeData)

# different ways of exploring your data
summary(coffeeData)
dim(coffeeData)
head(coffeeData)
names(coffeeData)

# to select/view a single column
coffeeData$participantID
coffeeData[["participantID"]] # different way of doing the same thing

coffeeData$participantID[1]  # participant number from the 1st row
coffeeData$participantID[40] # participant number from the 40th row
coffeeData[["participantID"]][40] # same as above

coffeeData$participantID[1:3]

################################################################
### DATA CLEANING ###

# Transform your data from wide format to long format (i.e., combine columns so that each row represents one observation)
## topics covered: piping, gather, spread, separate, unite, adding new columns, mutate

## Pipe operator
# inserts the results from the previous function into the next function
# it allows us to do step-by-step actions in an intuitive way
# shortcut is cmd/ctrl + shift + m

x <- 1:4
sum(x) # without pipe

x %>% sum() # with pipe


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

# Change RT column from miliseconds to second using mutate
coffeeDataTidy <- coffeeDataClean  %>%
  mutate(rt_sec=rt/1000)


## More Data Exploration

# distinct() shows all distinct values in a column
coffeeDataTidy %>% 
  distinct(participantID)

# count() shows the number of distinct values in a column
coffeeDataTidy %>% 
  count(participantID)

coffeeDataTidy %>% 
  count(participantID, group)

# interacitve table with datatable()

install.packages('DT')
library(DT)

coffeeDataTidy %>% 
  DT::datatable()


################################################################
### SUMMARY STATISTICS ###

# Now that we have tidy data let's get some summary statistics
# topics covered: filter, group_by, summarise

# descriptive stats of values in a column
mean(coffeeDataTidy$rt_sec, na.rm=T)
median(coffeeDataTidy$rt_sec, na.rm=T)
var(coffeeDataTidy$rt_sec, na.rm=T)
sd(coffeeDataTidy$rt_sec, na.rm=T)
range(coffeeDataTidy$rt_sec, na.rm=T)

# describe() function from the psych package
describe(coffeeDataTidy$rt_sec)

coffeeDataTidy %>%
  summarise(mean_RT = mean(rt), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt), 
            sd_acc=sd(accuracy))

# Need to tell mean() and sd() to ignore the missing values (i.e., NA's) by saying na.rm = TRUE
coffeeDataTidy %>%
  summarise(mean_RT = mean(rt, na.rm = TRUE), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt, na.rm = TRUE), 
            sd_acc=sd(accuracy))

# Summarize data by group
coffeeDataTidy %>%
  group_by(group) %>%
  summarise(mean_RT = mean(rt, na.rm = TRUE), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt, na.rm = TRUE), 
            sd_acc=sd(accuracy))

# Summarize data by group but filter out the pilot subject
coffeeDataTidy %>%
  group_by(group) %>%
  filter(participantID != 'pilot') %>%
  summarise(mean_RT = mean(rt, na.rm = TRUE), 
            mean_acc=mean(accuracy), 
            sd_rt = sd(rt, na.rm = TRUE), 
            sd_acc=sd(accuracy))

################################################################
### BASIC INFERENTIAL STATISTICS ###

# t-test, comparing reaction time for the coffee and water drink groups.  

coffeeDataTidy_ttest <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != 'pilot'  & accuracy==1)
  
t.test(coffeeDataTidy_ttest$rt[coffeeDataTidy_ttest$group == 'coffee'], 
       coffeeDataTidy_ttest$rt[coffeeDataTidy_ttest$group == 'water'])

# number of observations need to be equal for a paired sample ttest
# so this won't work

coffeeDataTidy_paired <- coffeeDataTidy %>%
  drop_na(rt_sec) %>% 
  filter(participantID != 'pilot'  & accuracy==1) %>% 
  group_by(participantID, congruency)
 
t.test(coffeeDataTidy_paired$rt[coffeeDataTidy_paired$congruency == 1], 
       coffeeDataTidy_paired$rt[coffeeDataTidy_paired$congruency == 0],
       paired = TRUE)


# use cor.test() for correlations

################################################################
#### DATA VISUALIZATION: GGPLOT ####

#ggplot requires 3 elements: 
# data = dataset being plotted
# aesthetics = scale ontro which we map our data
# geometries = visual elements (shapes) of the plot

ggplot(coffeeDataTidy, aes(x = group, y = rt_sec)) + geom_point()


# you can also save aesthetics and data to a variable
my_graph <- ggplot(coffeeDataTidy, aes(x = group, y = rt_sec))

# you can add geoms to this variable
my_graph + geom_point()

my_graph + geom_boxplot()

my_graph + geom_point() + geom_boxplot()

# with piping

my_graph <- coffeeDataTidy_ttest %>%
  ggplot(aes(x = group, y = rt_sec)) + 
  geom_point()

my_graph

# dropping NA values and removing pilot participant using original df and piping
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = congruency, y = rt_sec)) +
  geom_point()
my_graph

# adding colour
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = congruency, y = rt_sec, colour = group)) +
  geom_point()
my_graph

# choosing colours
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = congruency, y = rt_sec, colour = group)) +
  geom_point() +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3"))
my_graph

# adding labels
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = congruency, y = rt_sec, colour = group)) +
  geom_point() +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)")
my_graph

# adjusting x axis scale--convert congruency variable to a factor
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = as.factor(congruency), y = rt_sec, colour = group)) +
  geom_point() +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)")
my_graph

# adjusting x axis scale labels
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = as.factor(congruency), y = rt_sec, colour = group)) +
  geom_point() +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  scale_x_discrete(labels = c("congruent", "incongruent")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)")
my_graph

# how do we change the labels for congruent and incongruent?
coffeeDataTidy %>% 
  coffeeDataTidy$congruency <- recode(coffeeDataTidy$congruency , 
                                      "'0' = 'Incongruent'; 
                                      '1' = 'Congruent'")
# now the congruency column is saved as a character which is okay for plotting
View(coffeeDataTidy)
str(coffeeDataTidy)

# now run the code again and you will see that the labels have changed!

# jitter the points and adjust their transparency
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = as.factor(congruency), y = rt_sec, colour = group)) +
  geom_point(position = position_jitterdodge(), alpha = .4) +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  scale_x_discrete(labels = c("congruent", "incongruent")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)")
my_graph


# add summary mean and error bars
my_graph <- coffeeDataTidy %>% 
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = as.factor(congruency), y = rt_sec, colour = group)) +
  geom_point(position = position_jitterdodge(), alpha = .4) +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  scale_x_discrete(labels = c("congruent", "incongruent")) +
  labs(title = "Scatter plot: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Congruency",
       y = "Reaction Time (ms)") +
  theme_few() + # for a cleaner look
  stat_summary(fun.y = mean, geom = "point", size = 3) +
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar",
               width = 0.2, show.legend = FALSE)

my_graph

# LINE GRAPH--for Steph: x-axis
# To demonstrate line graphs, we are using trial number as the x axis
# filter out the NA values in rt_sec column 
# filter out pilot data
my_graph <- coffeeDataTidy %>%
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = trial_number, y = rt_sec, group = group, color = group)) +
  scale_color_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  stat_summary(fun.y = mean, geom = "line", size = 1.1, alpha = 0.8, show.legend = FALSE) +
  stat_summary(fun.y = mean, geom = "point", size = 3) +
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar",
               width = 0.2, show.legend = FALSE) +
  scale_x_continuous(breaks = c(2, 4, 6, 8, 10), labels = c("2", "4", "6", "8", "10")) +
  geom_point(position = position_jitterdodge(), alpha = .4) +
  labs(title = "Line Graph: Reaction Time Across Trials",
       subtitle = "Excluding pilot data",
       x = "Trial Number",
       y = "Reaction Time (s)") +
  theme_few()

my_graph
  # Other things to explain:
  # stat_summary
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
bar_plot <- coffeeDataTidy %>%
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = participantID, y = rt_sec, fill = group)) +
  # remember to use fill = for bar graphs!
  stat_summary(fun.y = mean, geom = "bar", width = 0.69) + # width changes how thick the bars are
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar",
               width = 0.09,
               position = position_dodge(width = 0.9)) +
  scale_fill_brewer("Group", palette = 'Accent') +
  labs(title = "Bar Graph",
       x = "Participant",
       y = "Reaction Time") +
  theme_bw()

bar_plot
# why is naming your plot useful?
bar_plot + geom_point(colour = "black", size = 1.3,
                      alpha = .5)

# VIOLINT PLOT
violin <- coffeeDataTidy %>%
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(group, rt, fill = group)) +
  geom_violin(colour = "white") +
  labs(title = "Violin Plot",
       subtitle = "Dots represent raw values",
       x = "Group",
       y = "Raw Reaction Time") +
  geom_hline(yintercept=3000, linetype="dashed", color = "black") + 
  geom_point(colour = "black", fill = "black", size = 1.3, alpha = .5) +
  scale_fill_manual("Group", values = c("darkolivegreen3", "darkgreen")) +
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.grid.major = element_line(colour = "gray87"),
        panel.grid.minor.y = element_line(colour = "gray90"))
violin

# BOX PLOT
box <- coffeeDataTidy %>%
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(group, rt, fill = group)) +
  geom_boxplot(varwidth=T) +
  geom_hline(yintercept=3000, linetype="dashed", color = "black") +
  labs(title = "Box Plot",
    subtitle = "Dots represent potential outliers",
    x = "Group",
    y = "Raw Reaction Time") +
  scale_fill_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "white", colour = "white"),
        panel.grid.major = element_line(colour = "gray87"),
        panel.grid.minor.y = element_line(colour = "gray90"))

box
# how to combine plots together 
# option 1 = grid.arrange
grid.arrange(violin, box, ncol = 2)

# option 2 = facet_wrap
coffeeDataTidy %>%
  drop_na(rt_sec) %>% 
  filter(participantID != "pilot") %>% 
  ggplot(aes(x = group, y = rt_sec, fill = group)) +
  stat_summary(fun.y = mean, geom = "bar", width = 0.69,
               position = position_dodge(width = 0.9)) +
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.09,
               position = position_dodge(width = 0.9)) +
  labs(title = "Facet Wrap Grouped by Congruency Condition",
       x = "Group",
       y = "Reaction Time (s)") +
  scale_fill_manual("Group", values = c("darkgreen", "darkolivegreen3")) +
  # notice for bar graphs you have to use scale_fill_manual instead of colour
  facet_grid(. ~ congruency) +
  theme_few() 


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
# cheatsheets
# R color sheet

# VERY helpful: https://psych252.github.io/psych252book/