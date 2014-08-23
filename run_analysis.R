##Obtain the zip file from the UR and Unzip it. Obtain the Date/Time of download for validation purposes
##later-on. Similarly, maintain the Directory (curDir) from where run_analysis.R was started.

download <- function() {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dest <- "./Dataset.zip"
  
  download.file(url, dest)
  dataDownload <- date()
  
  unzip(dest)
  CurDir <- getwd()
  setwd("UCI HAR Dataset/")

## Read the extracted (input) files. From the Features.txt and Activity_labels.txt file, 
## structure via the column2 structural column. 

features<-read.table("features.txt")["V2"]
activity_labels<-read.table("activity_labels.txt")["V2"]

## Representing (grep) the link between the Mean / Std columns and the Features, based on the mean|std
mstd_ind<-grep("mean|std",features$V2) 

## Obtaining the data from the Test folder
setwd("test")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
test_subject <- read.table("subject_test.txt")

feat(test_x) <- features$V2
feat(test_y) <- "labels"
feat(test_subject)<-"subjects"

## Obtaining the data from the Train folder
setwd("../test/")
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
train_subject <- read.table("subject_train.txt")

feat(train_x) <- features$V2
feat(train_y)<-"labels"
names(train_subject)<-"subjects"

## Go back to starting WD
setwd(CurDir)

## Only the relevant statisics are obtained, via subsetting, from the mstd_ind vector and test/train sets
## Starting with the X subset, combining it into a subset_combination

mstd_ind2 <-colnames(test_x)[mstd_ind]
subset1 <-cbind(test_subject,test_y,subset(test_X, mstd_ind2))
subset2 <-cbind(train_subject,train_y,subset(train_X, mstd_ind2))
subset_comb <-rbind(subset1, subset2)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidydataset <- aggregate(subset_comb,list(Subject=subset_comb$subjects, Labels=subset_comb$labels), mean)

write.table(tidydataset, file="./tidydata.txt", row.names=FALSE)
}
