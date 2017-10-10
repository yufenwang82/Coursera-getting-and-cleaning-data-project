
## download data

url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./project.zip")
unzip(zipfile="./project.zip",exdir=getwd())


## readind files into R 

# Reading trainings tables:
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dim(x_train)
dim(y_train)
dim(subject_train)

# Reading testing tables:
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
dim(x_test)
dim(y_test)
dim(subject_test)

# Reading feature vector:
features <- read.table('./UCI HAR Dataset/features.txt')
dim(features)

# Reading activity labels:
activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt')
dim(activity_labels)


## assign column names to train and test set

colnames(x_train)<-features[,2]
colnames(y_train)<-"activity_id"
colnames(x_test)<-features[,2]
colnames(y_test)<-"activity_id"
colnames(subject_train)<-"subject_id"
colnames(subject_test)<-"subject_id"
colnames(activity_labels)<-c("activity_id","activity_type")

## merge datasets

train<-cbind(subject_train,x_train,y_train)
test<-cbind(subject_test,x_test,y_test)
train_and_test<-rbind(train,test)

## Extracts only the measurements on the mean and standard deviation for each measurement.

column_name<-colnames(train_and_test)
mean<-grep("mean",column_name)
std<-grep("std",column_name)
id<-grep("id",column_name)

data<-train_and_test[,c(id,mean,std)]
names(data)

## Uses descriptive activity names to name the activities in the data set

library(dplyr)
data<-left_join(data,activity_labels,by="activity_id")
names(data)

##Appropriately labels the data set with descriptive variable names.

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data<-aggregate(.~subject_id+activity_id+activity_type,data,FUN='mean')
head(tidy_data)
write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)


