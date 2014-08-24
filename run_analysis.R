# This script (run_analysis.R) will include five steps, to get a tidy data subset of the DataSet that can be
# obtained from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#-------------------------------------------------------------------------------------------------------------------

##Step 0: Obtain the zip file from the UR and Unzip it. Obtain the Date/Time of download for validation purposes
##later-on, if that would be required. Similarly, maintain the Directory (curDir) from where run_analysis.R was started.

download <- function() {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  dest <- "./Dataset.zip"
  
  download.file(url, dest)
  dataDownload <- date()
  
  unzip(dest)
  CurDir <- getwd()
}  

##Step 0.1: Set the Working Directory to the unzipped folder of the DataSet

run_analysis <- function() {

  setwd("UCI HAR Dataset/")

## Step 2-3: Read the extracted (input) files. From the Features.txt and Activity_labels.txt file, 
## structure via the v2 column structural column. Google was my friend as to why use the ["V2"] inclusion in the entire coding!

features <-read.table("features.txt")["V2"]
activity_labels <-read.table("activity_labels.txt")["V2"]

## Step 2-3: Representing (grep) the link between the Mean / Std columns and the Features, based on the mean|std naming
ind <- grep("mean|std",features$V2) 

## Step 2-3: Obtaining the data from the Test folder
setwd("test")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
test_subject <- read.table("subject_test.txt")

feat(test_x) <- features$V2
feat(test_y) <- "labels"
feat(test_subject) <- "subjects"

## Step 2-3: Obtaining the data from the Train folder
setwd("../train/")
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
train_subject <- read.table("subject_train.txt")

feat(train_x) <- features$V2
feat(train_y) <- "labels"
feat(train_subject) <- "subjects"

## Go back to starting WD
setwd(CurDir)

## Step 2-3: Only the relevant statisics are obtained, via subsetting, from the mstd_ind vector and test/train sets
## Starting with the X subset, combining it into a subset_combination

ind2 <-colnames(test_x)[ind]
subset1 <-cbind(test_subject,test_y,subset(test_X, ind2))
subset2 <-cbind(train_subject,train_y,subset(train_X, ind2))
subset_comb <-rbind(subset1, subset2)

## Step 4-5: Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_dataset <- aggregate(subset_comb,list(Subject=subset_comb$subjects, Labels=subset_comb$labels), mean)

write.table(tidy_dataset, file="./tidydata.txt", row.names=FALSE)

}
