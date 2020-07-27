
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





###-------------------------------------------------------------------------###


# VARIABLES & DATA TYPES

# How to run a line of code?: When you are on the line, press cmd (mac) / ctrl (windows), then enter (more later)


#%# Numeric
# assigning a value to a variable
# *code here*


# str() displays the type/ structure of object
# *code here*


#%# Character
c <- '4'
str(c)  

# Is 3 the same as '3'?
# *code here*


#%# Boolean/Logical: TRUE, FALSE, NA
# NA: not available
# *code here*



# Converting from one data type to another
# Ex. Converting numeric to character
# *code here*



###-------------------------------------------------------------------------###

# GETTING HELP IN RSTUDIO

# general help
# *code here*

# help fort function mean()
# *code here*

# same as above
# *code here*

# shows an example of function mean()
# *code here*


###-------------------------------------------------------------------------###

# VECTORS, FACTORS, CONVERTING BETWEEN DATA TYPES


#%# Vectors
# *code here*

#%# Indexing vectors
# note: in R, the indexing begins with 1 (0 in Python)

# access first element 
# *code here*

# access 3rd to 5th elements
# *code here*

# access first and last element
# *code here*

# mean of elements in vector
# *code here*

# max of elements in vector
# *code here*

#%# Factors
# how catgorical variables are stored in R

groups <- factor(c("red","green", "red", "green"))
groups

# all possible values of a factor
# *code here*

# number of possible values of a factor
# *code here*

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

# getwd()
# setwd()


# if I had the file on my Desktop
# setwd("/Users/anishakhosla/Desktop")

# sample working directory for windows users
#setwd("C:\\Users\\akhosla\\Desktop")

###-------------------------------------------------------------------------###


# LOAD DATA

#Coffee Data: There was a pilot participant and 4 other participants who either drank coffee or water (between-subject variable) and then did some task. We have the reaction time and accuracy from the task.


# read in data from .csv to a dataframe
# *code here*


# EXPLAIN DATA

# look at data
# *code here*


# structure of data
# *code here*



###-------------------------------------------------------------------------###

# DATAFRAMES -- EXPLORE DATA

# summary for each column of the dataframe
# *code here*

# number of rows and columns
# *code here*

# prints the first 5 rows of a dataframe
# *code here*

# name of columns
# *code here*

# to select/print a particular column
# *code here*

# Use what we learned about indexing into vectors to index into columns of a dataframe
# participant number from the 1st row
# *code here*


# participant number from the 40th row
# *code here*


df$participantID[1:3] # grabs the first 3 entries in a particular column

###-------------------------------------------------------------------------###


# PACKAGES




###-------------------------------------------------------------------------###

# PIPING

# Pipe operator: %>% 

# - shortcut is cmd/ctrl + shift + m
# - it allows us to do step-by-step actions in an intuitive way
# - insert results from prev step as output for the next step OR inserts the results from the previous function into the next function


x <- 1:4
x

# without pipe
# *code here*

# with pipe
# *code here*


###-------------------------------------------------------------------------###

# DATAFRAMES -- TIDYVERSE


# back to our dataset...
df$participantID

# distinct() shows all distinct values in a column
# *code here*

# count() shows the number of distinct values in a column
# example, how many rows per subject?
# *code here*

# filter--we can define a set of conditions that we want to filter the rows of our data frame by
# *code here*

# select--same as filter but allows for subsetting columns instead
# *code here*


# add new column
# *code here*

# the - operator can be used to exclude a column
# *code here*


#%# why pipe? 
# note: arrange() sorts data

# select columns participantID, drink, rt
# filter for the pilot participant
# arrange reraction time in descending order 

# piping
# *code here*


# base R
arrange(filter((select(df, contains('part'), drink, rt)), participantID=='pilot'), rt)

# subset data--print rows where the rt is above 1000ms
# *code here*


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

