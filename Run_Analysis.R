#0. prepare LIBs
library(reshape2)
# only one lib need to be imported

setwd("D:\\new papers\\coursera\\r_programming")

rawDataDir <- "UCI HAR Dataset"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "final project"

if (!file.exists(rawDataDir)) {
    dir.create(rawDataDir)
    download.file(url = rawDataUrl, destfile = rawDataDFn)
}
if (!file.exists(dataDir)) {
    dir.create(dataDir)
    unzip(zipfile = rawDataDFn, exdir = dataDir)
}


#1. Read the data from the files
# train data
X_train <- read.table(paste(sep = "", "UCI HAR Dataset/train/X_train.txt"))
Y_train <- read.table(paste(sep = "", "UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", "UCI HAR Dataset/train/subject_train.txt"))

# test data
X_test <- read.table(paste(sep = "", "UCI HAR Dataset/test/X_test.txt"))
Y_test <- read.table(paste(sep = "", "UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", "UCI HAR Dataset/test/subject_test.txt"))

# merge {train, test} data
x_data <- rbind(X_train, X_test)
y_data <- rbind(Y_train, Y_test)
s_data <- rbind(s_train, s_test)

# feature info
feature <- read.table(paste(sep = "", "UCI HAR Dataset/features.txt"))

# activity labels
a_label <- read.table(paste(sep = "", "UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

#2. Now we solve the second problem
# extract feature cols & names named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)


#3. Uses descriptive activity names to name the activities in the data set
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


#4. Appropriately labels the data set with descriptive variable names. 
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

#5. write the file
write.table(tidyData, "final project\\tidy_dataset.txt", row.names = FALSE, quote = FALSE)
