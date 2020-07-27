# R Workshop: Session 3 on Data Visualization
  ## Date: July 24, 2020
  ## Author: Stephanie Simpson (ssimpson@research.baycrest.org)
  ## This script uses ggplot2 to create three different kinds of figures: 1. bar plot, 2. box plot, and 3. scatterplot

#--------------------------------------#

# LOAD PACKAGES
  
# Download the following packages in order to run this script

library(readr) # for reading in csv files
library(tidyverse) # for general coding + includes ggplot2 which we need for graphing
library(ggthemes) # for fun ggplot themes
library(cowplot) # another fun add-on to ggplot
library(gridExtra) # for arranging plots together

# As a reminder, these packages need to be installed already before they can be added here. If they haven't been installed yet, you can do it by uncommenting and running this line of code. This will allow you to install multiple packages at once.
# install.packages(c("readr", "tidyverse", "ggthemes", "cowplot", "gridExtra"))

#--------------------------------------#

# LOAD DATA

# Load in the data by using the read_csv function (which calls on the readr package)
# To run this script, we are going to use Nichole's single item recognition data (in long format)

# IMPORTANT: you will need to *change this directory* to match the one on your personal computer
  ## i.e., you need to tell R where it should go and grab your data csv file

# this allows us to load in our data and call it "sirdat"

sirdat <-read_csv('~/Dropbox/Baycrest_Rworkshop/2020/SngItmRec_Long.csv') # change this path to match your personal directory

#--------------------------------------#

# VIEW DATA

# Make sure the data (which we called sirdat) looks correct before continuing

View()

#--------------------------------------#

# WHAT IS GGPLOT?

# ggplot2 is a system for creating graphics in R and is one of the core packages in the tidyverse
# ggplot 2 is all about layering!
  ## the idea is that you build your graph by literally adding different components to your figure, one line at a time
    ### we first tell the function ggplot() which data we would like to visualize
    ### and then add layers like:
     #### aesthetic properties to represent variables - aes(), 
     #### geoms to represent data points - e.g., geom_point(), 
     #### scales - e.g., scale_colour_brewer()

# See https://ggplot2.tidyverse.org/ for more information

#--------------------------------------#

# PLOT 1: BAR PLOT



# This shows us the "skeleton" of our plot, but we haven't added any of the actual data points to it yet
# We can do this by adding stat_summary
# stat_XX is an alternative way to build layers - it will add transformations of the original data set

bar_plot <- 

bar_plot # call the plot to display it

# To make our graph "manuscript-ready", we need to add some measure of effect size, labels, and change the colours
# It would also be nice to display the accuracy rate by stimulus types
# To do this, we can apply a facet wrap
  ## This allows you to separate your data into subsets and then plot them all together
  ## http://www.cookbook-r.com/Graphs/Facets_(ggplot2)/

bar_plot + 

#--------------------------------------#

# THEMES

# I'm currently using the built-in gpplot2 themes, but we can change this as well!
    # For instance, we can two other packages called cowplot (https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html)
    # or ggthemes (https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/)

bar_plot + 

# Notice here that R is displaying the older version of the barplot
# If we want to see our more polished version, we need to override the original bar_plot...

bar_plot <- bar_plot +


#--------------------------------------#

# PLOT 2: BOX PLOT

# What is the purpose of a box plot? (https://towardsdatascience.com/understanding-boxplots-5e2df7bcbd51)
  ## box represents the IQR
  ## middle line represents the median
  ## outer lines indicate the minimum and maximum (range)
  ## outliers will appear as points outside the range

box_plot <- sirdat %>%


box_plot

# Again, let's spice this up! This line of code will:
  ## modify the appearance of outliers
  ## add a horizontal line
  ## create labels
  ## change colours
  ## label and reposition the legend

box_plot <- box_plot +

box_plot

#--------------------------------------#

# PLOT 3: SCATTERPLOT

# Let's try one of R's built-in datasets called iris
  ## What is iris?

## Scatterplot A

# base of the scatterplot

scatterplot_base

# add a single linear trend line to this plot with geom_smooth
# this helps better visualize the pattern in your data
scatterplot <- scatterplot_base + 

scatterplot

# Change the axes labels

scatterplot + 

## Scatterplot B (with multiple trendlines)

# create trendlines for each species by adding an aesthetic to geom_smooth
scatterplot_base +

# Apply what you've learned
  ## How would you add some labels?
  ## How would you change the theme to make the data more visible?
  ## How would you reposition the legend to the top of your figure?

scatterplot +

#--------------------------------------#

# OTHER TIPS

## Combine plots

# using the :: allows you to call the package without downloading it (though it must be installed)

## side by side orientation


## vertical orientation

## Save your figures 

ggsave

#--------------------------------------#

# MORE CUSTOMIZATIONS 

  ## Change the shape of your points - https://www.datanovia.com/en/blog/ggplot-point-shapes-best-tips/
  ## Change the colour - http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually#use-wes-anderson-color-palettes
  ## R color sheet - http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf## ggthemes = https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
  ## ggplot2 cheatsheet - https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
  ## R for Data Science chapter on Data visualisation - https://r4ds.had.co.nz/data-visualisation.html

# Please see the resource list in our Google Drive for additional helpful sites!