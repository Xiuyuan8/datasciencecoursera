# This code is for the project of "Getting & Cleanning Data". 
# Time: March 22th
# Author: Xiuyuan Li 
# Aim:(The following sentences are cited from Coursera Website)
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


library(reshape2)

fname <- "getdata.zip"
  
## Download and unzip the dataset from website 

if(!file.exists(fname)){
  fURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fURL, fname, method="curl")
}
if(!file.exists("UCI HAR Dataset")){
  unzip(fname)
}


## Load activity labels + features 
actLab <- read.table("UCI HAR Dataset/activity_labels.txt")
actLab[,2] <- as.character(actLab[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Extract only the data on mean and standard deviation 
featuresWat <- grep(".*mean.*|.*std.*",features[,2])
featuresWat.name <- features[featuresWat,2]
featuresWat.name=gsub('-mean','Mean',featuresWat.name)
featuresWat.name=gsub('-std','Std',featuresWat.name)
featuresWat.name <- gsub('[-()]','',featuresWat.name)
  
# load the train and test datasets and add labels 
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWat]
trainAct <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubj <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainData <- cbind(trainSubj,trainAct,trainData)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWat]
testAct <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubj,testAct,test)

# Merge train and test datasets and add labels 
Data <- rbind(trainData,test)
colnames(Data) <- c("subject","activity", featuresWat.name)

# Trun activities & subjects into factors 
Data$activity <- factor(Data$activity, level = actLab[,1], labels = actLab[,2])
Data$subject <- as.factor(Data$subject)

Data.melted <- melt(Data,id = c("subject","activity"))
Data.mean <- dcast(Data.melted,subject + activity ~ variable, mean)

write.table(Data.mean,"Documents/Data Science/Getting and Cleaning Data/tidy_data.txt", row.names = FALSE, quote = FALSE)



