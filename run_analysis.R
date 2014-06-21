## The code below will import the data and will clean it up


## Download the file and read into the data set
#temp <- tempfile()
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              #temp)

temp <- paste(getwd(),"/getdata_projectfiles_UCI HAR Dataset.zip", sep="")
              
## Read train data set
traindata <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
traindataact <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
trainsubj <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))

traindata <- cbind(traindata, traindataact, trainsubj)

## Read test data set
testdata <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
testdataact <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
testsubj<- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))

testdata <- cbind(testdata, testdataact, testsubj)



## Merge two data sets to create one
dataset <- rbind(traindata, testdata)

## Import variable names
Varnames <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
## Assign variables to the data set
colnames(dataset) <- Varnames$V2
names(dataset)[562] <- "activity"
names(dataset)[563] <- "subject"

## Only mean / std variables are required
reqcol <- c("mean", "std")
vars <- grep(paste(reqcol, collapse="|"), Varnames$V2)
vars <- c(vars, 562, 563)

## Select the mean / std variables
datasetfilt <- dataset[, vars]

## Assign activity labels
## Import labels

label <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
datasetfilt$activity <- factor(datasetfilt$activity, labels = label$V2, 
                               levels = sort(unique(datasetfilt$activity)))

## Creates a second, independent tidy data set with the average of each 
## variable for each activity and each subject. 

tidydata <- aggregate(x = datasetfilt, by = list(datasetfilt$activity, 
                                                 datasetfilt$subject), 
                      FUN = "mean")
write.csv(tidydata, file="tidydata.csv")
write(tidydata, file="tidydata.txt", sep="\t")