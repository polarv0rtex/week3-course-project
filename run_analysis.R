# run_analysis.R
# base code borrowed from Benjamin Chan and 
# significantly modified by Brendan McDermott on May 21, 2015

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
unzip(zipfile = "Dataset.zip")

# set unzipped folder as the input path
inputPath <- file.path(path, "UCI HAR Dataset/")

# read the subject files
dtSubjectTrain <- fread(file.path(inputPath, "train", "subject_train.txt"))
dtSubjectTest  <- fread(file.path(inputPath, "test", "subject_test.txt")) 

# read the activity files
dtActivityTrain <- fread(file.path(inputPath, "train", "Y_train.txt"))
dtActivityTest  <- fread(file.path(inputPath, "test", "Y_test.txt"))

# read the data files
fileToDataTable <- function (f) {
        df <- read.table(f)
        dt <- data.table(df)
}
dtTrain <- fileToDataTable(file.path(inputPath, "train", "X_train.txt"))
dtTest  <- fileToDataTable(file.path(inputPath, "test", "X_test.txt"))

# merge training and test sets
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")
dtActivity <- rbind(dtActivityTrain, dtActivityTest)
setnames(dtActivity, "V1", "activityNum")
dt <- rbind(dtTrain, dtTest)

# merge columns
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)

# set the key -- this sorts by subject first
setkey(dt, subject, activityNum)

# extract mean and SD
dtFeatures <- fread(file.path(inputPath, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))

dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]

dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]
select <- c(key(dt), dtFeatures$featureCode)
dt <- dt[, select, with = FALSE]

# use descriptive names
dtActivityNames <- fread(file.path(inputPath, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))

# merge activity labels and add activityName as a key
dt <- merge(dt, dtActivityNames, by="activityNum", all.x=TRUE)
setkey(dt, subject, activityNum, activityName)

# melt the data and reshape as tall and narrow
dt <- data.table(melt(dt, key(dt), variable.name="featureCode"))
dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by="featureCode", all.x=TRUE)
