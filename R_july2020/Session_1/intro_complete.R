
# R WORKSHOP, SESSION 1, JULY 20th 2020
# anishakhosla

###-------------------------------------------------------------------------###

# RSTUDIO

# 4 panels
# Top left: Script viewer - write your code to save it for future use
# Bottom left: Console - this is where R is actually running
# Top right: Variable/history displayer
# Bottom right: Files/plots/packages/help displayer

# Script vs Console
# Console: type commands directly to see their result. This is not saved
# Script editor: Save your code for later. 

# Shortcuts
# TAB -- autocomplete
# control/cmd + enter -- run current line from the script in console

## How to run a line of code?
# When you are on the line, press cmd (mac) / ctrl (windows), then enter (more later)

###-------------------------------------------------------------------------###

# COMMENTS

# Comments are lines in the script that are skipped and not run. They can be used to annotate your code and make it more friendly when you are trying out something new or for others if you are sharing your code. This is also VERY helpful to remind yourself of what you did when you look back at the code years after you wrote it.

# If you add a hashtag, everything written after is a comment.


# This is a comment. We can use comments using a hash sign
This is not a comment


###-------------------------------------------------------------------------###


# VARIABLES & DATA TYPES

# Variables are used to store information and you can reference to the information later using the variable name. 
 
# Variables can be used to store different types of data like numerics (1,4), characters('a','g'), booleans (TRUE/FALSE)
 
# If you are wondering:
#   Why '<-' and not '=' for variable assignment? -- indicates the difference between function arguments and assignation. See https://www.r-bloggers.com/why-do-we-use-arrow-as-an-assignment-operator/
  
# How to run a line of code?: When you are on the line, press cmd (mac) / ctrl (windows), then enter (more later)


#%# Numeric
# assigning a value to a variable
n <- 1 

# str() displays the type/ structure of object
str(n) 

#%# Character
c <- '4'
str(c)  

# Is 3 the same as '3'?
identical(3, '3')

#%# Boolean/Logical: TRUE, FALSE, NA
# NA: not available

l <- TRUE
str(l)


# Converting from one data type to another
# Ex. Converting numeric to character
as.numeric(c)
as.character(n)


###-------------------------------------------------------------------------###

# GETTING HELP IN RSTUDIO

# Below are some ways to get help within RStudio. You can, of course, google functions and specific things you are looking for. R Documentation is usually a good first source because it details everything a function can do, but if you are looking for something more specific, often someone else has asked the same question on forums like StackOverflow


#%# Getting help in RStudio

help.start()   # general help

help(mean)    # help for function mean()
?mean         # same as above

example(mean) # shows an example of function mean()

###-------------------------------------------------------------------------###

# VECTORS, FACTORS, CONVERTING BETWEEN DATA TYPES

#vectors, factors, matrix, array, dataframe, list
#for more see https://www.statmethods.net/input/datatypes.html

#%# Vectors
my_vector <- c(8,0,9.9,6,-1,4)

#%# Indexing vectors
my_vector[1] # access first element 
# note: in R, the indexing begins with 1 (0 in Python)
my_vector[3:5] # access 3rd to 5th elements
my_vector[c(1, 3)] # access first and last element

mean(my_vector)
max(my_vector)

#%# Factors
# how catgorical variables are stored in R

groups <- factor(c("red","green", "red", "green"))
groups

levels(groups) # all possible values of a factor
nlevels(groups) # number of possible values of a factor


# why is it important to specify data type? -- especially important with numerical factors
groups<- c(4,5,6)
str(groups)

# convert numeric to character
groups<- as.character(groups)
str(groups)
levels(groups) # this will not work because 'groups' is not a factor yet

# convery character to factor
groups<- as.factor(groups)
str(groups)
levels(groups)

###-------------------------------------------------------------------------###


# SETTING WORKING DIRECTORY

# directory = folder
 
# The folder R will load files from and save files to. You can check and change the current directory to a different one


# Where am I? i.e. where is R currently looking for files or saving files to?
getwd()

# Set the location i.e.working directory.  This is where R will look for files you want to load.
# setwd()

# sample working directory for MAC users
setwd('/Users/anishakhosla/Dropbox/Baycrest_Rworkshop/2020/part1')

# if I had the file on my Desktop
# setwd("/Users/anishakhosla/Desktop")

# sample working directory for windows users
#setwd("C:\\Users\\akhosla\\Desktop")

###-------------------------------------------------------------------------###


# LOAD DATA

#You can read in .csv files into sheet-like data format in R. This sheet-like data is called a 'dataframe' in R

#Coffee Data: There was a pilot participant and 4 other participants who either drank coffee or water (between-subject variable) and then did some task. We have the reaction time and accuracy from the task.


# read in data from .csv to a dataframe
df <- read.csv('coffee_data.csv')

# EXPLAIN DATA
View(df)
str(df)

###-------------------------------------------------------------------------###

# DATAFRAMES -- EXPLORE DATA


summary(df) # summary for each column of the dataframe
dim(df) # number of rows and columns
head(df) # prints the first 5 rows of a dataframe
names(df) # name of columns

# to select/print a particular column
df$participantID # OR df[['participantID']] (both are the same)

df['participantID'] # while the output of $ or [['']] is a factor, output of this type of indexing is a dataframe. you can check with the str() function like we did above!


# Use what we learned about indexing into vectors to index into columns of a dataframe
df$participantID[1]  # participant number from the 1st row
df$participantID[40] # participant number from the 40th row

df$participantID[1:3] # grabs the first 3 entries in a particular column

###-------------------------------------------------------------------------###


# PACKAGES

#Packages in R (and really any programming language) allow you to add functionality to base R. So you can are downloading a package of functions that did not exist before in base R.


#For example, if you want to do mixed models in R, you would download a package called 'lme4'. You can't do that with base R. We also download packages which make our lives easier and code easier to read and understand. For example, we can create plots to visualize data in base R but they are pretty tedious if you want to make them pretty and publication-ready, you would probably use 'ggplot2'. 

#There are alot of packages that add functionality or make our code easier to read. Hadley Wickham (http://hadley.nz/) made a universe of useful packages so you don't have to install each one of them individually. 'tidyverse' is a universe of such useful packages. When you load 'tidyverse', you will get a huge print out in your console detailing the packages that come with tidyverse


# Installing Packages
# uncomment the line below and run it if you don't have this package installed
#install.packages('tidyverse')

# to view a list of installed packages
# installed.packages()

# Loading Packages
# If you haven't installed the 'tidyverse' package, you should get an error when you run the line below
# If you have it installed, you will get a huge print out in your console detailing the packages that come with tidyverse

library(tidyverse)

###-------------------------------------------------------------------------###

# PIPING

# Pipe operator: %>% 

  # - shortcut is cmd/ctrl + shift + m
  # - it allows us to do step-by-step actions in an intuitive way
  # - insert results from prev step as output for the next step OR inserts the results from the previous function into the next function


x <- 1:4
x

sum(x) # without pipe

x %>% sum() # with pipe

###-------------------------------------------------------------------------###

# DATAFRAMES -- TIDYVERSE


# back to our dataset...
df$participantID

# distinct() shows all distinct values in a column
df %>% 
  distinct(participantID)

# count() shows the number of distinct values in a column
# example, how many rows per subject?
df %>% 
  count(participantID)

# filter--we can define a set of conditions that we want to filter the rows of our data frame by
df %>% 
  filter(participantID == 'pilot')

# select--same as filter but allows for subsetting columns instead
df %>% 
  select(participantID, drink, rt)


# add new column
df$age <- 21
df

# the - operator can be used to exclude a column
df %>% 
  select(-age)


#%# why pipe? 
# note: arrange() sorts data

# select columns participantID, drink, rt
# filter for the pilot participant
# arrange reraction time in descending order 

# piping
df %>% 
  select(contains('part'), drink, rt) %>% 
  filter(participantID=='pilot') %>% 
  arrange(rt)


# base R
arrange(filter((select(df, contains('part'), drink, rt)), participantID=='pilot'), rt)


# subset data--print rows where the rt is above 1000ms
subset(df, df$rt > 1000)

###-------------------------------------------------------------------------###


# R RESOURCES

# Free online edX course by Rafael Irizarry, Harvard University: https://www.edx.org/course/data-science-r-basics 
 
# **Cheatsheets**
#   *note that some of these are links to PDFs which will download when you click on them

# - https://rstudio.com/resources/cheatsheets/ (various cheatsheets)
# - Tidyverse cheatsheet: https://www.datacamp.com/community/blog/tidyverse-cheat-sheet-beginners
# - RStudio cheatsheet: https://rstudio.com/wp-content/uploads/2016/01/rstudio-IDE-cheatsheet.pdf 
# - Base R cheatsheet: https://rstudio.com/wp-content/uploads/2016/10/r-cheat-sheet-3.pdf
 
# Course by Tobi Gerstenberg (stats and data visualization with R)
# PSY252: https://psych252.github.io/
# Book (PSY252): https://psych252.github.io/psych252book/
   
# U of T coders: https://uoftcoders.github.io/studyGroup/lessons/

###-------------------------------------------------------------------------###

  
# Packages to download for following sessions: 
  
#- afex, emmeans, ggthemes, cowplot, gridExtra
#- run the line of code below in the console to install the packages listed above

install.packages(c("afex","emmeans","ggthemes", "cowplot","gridExtra"))

