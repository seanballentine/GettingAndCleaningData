library(dplyr)
library(magrittr)
library(data.table)
library(reshape2)

#Download all the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(getwd(), 'CourseraData.zip'))
unzip('CourseraData.zip')

#First we read in all the data
x_train <- fread("UCI HAR Dataset\\train\\X_train.txt")
y_train <- fread("UCI HAR Dataset\\train\\y_train.txt")
subject_train <- fread("UCI HAR Dataset\\train\\subject_train.txt")
x_test <- fread("UCI HAR Dataset\\test\\X_test.txt")
y_test <- fread("UCI HAR Dataset\\test\\y_test.txt")
subject_test <- fread("UCI HAR Dataset\\test\\subject_test.txt")
feat_names <- fread("UCI HAR Dataset\\features.txt")
activities <- fread("UCI HAR Dataset\\activity_labels.txt")

#Next I give proper names the the activity and subject columns to distinguish them when I join
names(subject_train) <- "Subject"
names(subject_test) <- "Subject"
y_train <- left_join(y_train,activities)
y_test <- left_join(y_test,activities)
names(y_train) <- c("Activity_Index", "Activity_Name")
names(y_test) <- c("Activity_Index", "Activity_Name")
names(x_train) <- feat_names$V2
names(x_test) <- feat_names$V2
#We can drop the Index column now that names are on the data
y_train$Activity_Index <- NULL
y_test$Activity_Index <- NULL

#Drop all but mean and std measurements
x_train <- x_train[,grep("(mean|std)\\(\\)",names(x_train)), with=FALSE]
x_test <- x_test[,grep("(mean|std)\\(\\)",names(x_test)), with=FALSE]


#Next I add the activity and subject indicator to the data
train <- cbind(subject_train,y_train,x_train)
test <- cbind(subject_test,y_test,x_test)

#Now I join the test and train datasets together
data <- rbind(train,test)

#Clean up the environment
rm(x_test,y_test,subject_test,x_train,y_train,subject_train,train,test, feat_names, activities)


#Expand and resummarize data to get one row for each subject and activity combo
data_melt <- melt(data = data, id = c("Subject", "Activity_Name"))
data_tidy <- dcast(data = data_melt, Subject + Activity_Name ~ variable, fun.aggregate = mean)


#Write final data set to working directory
fwrite(x = data_tidy, file = "tidyData.txt", quote = FALSE)