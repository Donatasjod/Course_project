## 1.Downloading files

if(!file.exists("./Course_project")) {dir.create("./Course_project")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./Course_project/dataset.zip")

## 2.Unzipping files

unzip(zipfile="./Course_project/dataset.zip",exdir="./Course_project")

## 3. Getting the list of files

paste_files<-file.path("./Course_project/", "UCI HAR Dataset")
list_files<-list.files(paste_files, recursive=TRUE)

## 4. Reading files into tables

##Values of Varible Activity consist of data from "Y_train.txt" and "Y_test.txt"
##values of Varible Subject consist of data from "subject_train.txt" and subject_test.txt"
##Values of Varibles Features consist of data from "X_train.txt" and "X_test.txt"
##Names of Varibles Features come from "features.txt"
##levels of Varible Activity come from "activity_labels.txt"

activity_test<-read.table(file.path(paste_files, "test" , "Y_test.txt" ),header = FALSE)
activity_train<-read.table(file.path(paste_files, "train", "Y_train.txt" ), header = FALSE)

subject_test<-read.table(file.path(paste_files, "test", "subject_test.txt" ), header = FALSE)
subject_train<-read.table(file.path(paste_files, "train", "subject_train.txt") , header = FALSE)

features_test<-read.table(file.path(paste_files, "test", "X_test.txt") , header = FALSE)
features_train<-read.table(file.path(paste_files, "train", "X_train.txt") , header = FALSE)

## 5. Merging tables by rows

activity<-rbind(activity_train, activity_test)
subject<-rbind(subject_train, subject_test)
features<-rbind(features_train, features_test)

## 6. Setting names

names(activity)<-c("activity")
names(subject)<-c("subject")
features_names<-read.table(file.path(paste_files, "features.txt"), header=FALSE)
names(features)<-features_names$V2

## 7. Putting descriptive activity names frome activity_labels into dataset

activity_labels<-read.table(file.path(paste_files, "activity_labels.txt"), header=FALSE)
activity[, 1] <- activity_labels[activity[, 1], 2]

## 8. Merging tables by columns

activity_subject<-cbind(activity, subject)
data<-cbind(features, activity_subject)

## 9. Creating subsets, selecting data
sub_features_names<-features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]
selected_names<-c(as.character(sub_features_names), "activity", "subject")
sub_data<-subset(data, select=selected_names)

##10. Changing column names

names(sub_data)<-gsub("^t", "time", names(sub_data))
names(sub_data)<-gsub("^f", "frequency", names(sub_data))
names(sub_data)<-gsub("Acc", "Accelerometer", names(sub_data))
names(sub_data)<-gsub("Gyro", "Gyroscope", names(sub_data))
names(sub_data)<-gsub("Mag", "Magnitude", names(sub_data))
names(sub_data)<-gsub("BodyBody", "Body", names(sub_data))

## 11. Creating tidy dataset

library(plyr)
tidy_data<-aggregate(. ~subject + activity, sub_data, mean)
tidy_data1<-tidy_data[order(tidy_data$subject, tidy_data$activity),]
write.table(tidy_data1, file="tidy_data.txt", row.name=FALSE)






