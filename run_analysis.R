# run_analysis.R
# base code borrowed from Benjamin Chan and modified by Brendan McDermott on May 21, 2015

# set directory
setwd("~/Desktop/cleaning_data/course_project/week3-course-project/")

# load packages
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# set path
path <- getwd()
path

# here we download the file, but for this project, 
# it goes into the same folder

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip?accessType=DOWNLOAD"
f <- "Dataset.zip"
if (!file.exists(path)) {dir.create(path)}
download.file(url, file.path(path, f), method="curl")

# unzip the file

