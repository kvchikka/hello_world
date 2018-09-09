if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/data.zip",method="curl")
unzip(zipfile="./data/data.zip",exdir="./data")
datapath <- file.path("./data" , "UCI HAR Dataset")
datafiles<-list.files(datapath, recursive=TRUE)
datafiles

dataATest  <- read.table(file.path(datapath, "test" , "Y_test.txt" ),header = FALSE)
dataATrain <- read.table(file.path(datapath, "train", "Y_train.txt"),header = FALSE)

dataSTrain <- read.table(file.path(datapath, "train", "subject_train.txt"),header = FALSE)
dataSTest  <- read.table(file.path(datapath, "test" , "subject_test.txt"),header = FALSE)

dataFTest  <- read.table(file.path(datapath, "test" , "X_test.txt" ),header = FALSE)
dataFTrain <- read.table(file.path(datapath, "train", "X_train.txt"),header = FALSE)

Subject <- rbind(dataSubjectTrain, dataSubjectTest)
Activity<- rbind(dataActivityTrain, dataActivityTest)
Features<- rbind(dataFeaturesTrain, dataFeaturesTest)
names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeatureNames <- read.table(file.path(datapath, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
CombinedData <- cbind(Subject, Activity)
Data <- cbind(Features, CombinedData)
subFeatureNames<-FeatureNames$V2[grep("mean\\(\\)|std\\(\\)", FeatureNames$V2)]
sNames<-c(as.character(subFeatureNames), "subject", "activity" )
Data<-subset(Data,select=sNames)

activitylabels <- read.table(file.path(datapath, "activity_labels.txt"),header = FALSE)
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "accelerometer", names(Data))
names(Data)<-gsub("Gyro", "gyroscope", names(Data))
names(Data)<-gsub("Mag", "magnitude", names(Data))
names(Data)<-gsub("BodyBody", "body", names(Data))
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "courseraprojectweek4.txt",row.name=FALSE)
