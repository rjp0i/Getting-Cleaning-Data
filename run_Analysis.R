# Step 1:
# Merge the training and the test sets to create one data set.

# read in the list of features, so we
# can use this file for the column names for the X_files
feature_names <- read.table("UCI HAR Dataset/features.txt")[,2]
# read in the 6 data files (3 for test, and 3 for train), naming the columns for the 
# X_ file using the features.txt file, 
#and naming the y_ column "activity" and the subject_ column "subject"
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",col.names="activity")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names=feature_names)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names="subject")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names="activity")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names=feature_names)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names="subject")
#now join the three test data.frames into one final one, and do the same with the training data set
Test <- cbind(y_test,subject_test,X_test)
Train <- cbind(y_train,subject_train,X_train)
#finally, simply rbind the Test and Train sets to get a final dataset
Alldata <- rbind(Test,Train)
write.table(Alldata,file="Alldata.txt",row.names=FALSE)
#End of Step 1

#Start Step 2 
#Extract only the measurements on the mean and standard deviation for each measurement.
#Use grep on the colnames to find the "mean" and "std".
#This probably isn't the most elegant way to do this step, but...
# I've decided to remove the FFT and sample windowed data (in the "angle" variable), 
#and only use the mean() and std() values for the tBody,tGravity data
# This gives me 20 "means" and 20 "std", so adding back in the Subject and Activity
# columns, the final data set has 42 columns

nonFFT <- Alldata[grep("fBody",colnames(Alldata),ignore.case=FALSE,invert=TRUE)]
nonFFTangle <- nonFFT[grep("angle",colnames(nonFFT),ignore.case=FALSE,invert=TRUE)]
meancols <- nonFFTangle[grep("mean",colnames(nonFFTangle),ignore.case=FALSE)]
stdcols <- nonFFTangle[grep("std",colnames(nonFFTangle),ignore.case=FALSE)]

actcol <- Alldata[grep("activity",colnames(Alldata),ignore.case=TRUE)]
subcol <- Alldata[grep("subject",colnames(Alldata),ignore.case=TRUE)]
meancols <- Alldata[grep("mean",colnames(Alldata),ignore.case=TRUE)]
stdcols <- Alldata[grep("std",colnames(Alldata),ignore.case=TRUE)]
#stick the data we want to keep back together into a single data frame
MeanStdData <- cbind(actcol,subcol,meancols,stdcols)
#End of Step 2

#Start Step 3
#Uses descriptive activity names to name the activities in the data set
# Currently there are 6 activities, just labeled with an integer from 1-6.
# The file activity_labels.txt has the descriptive name for each one. 
# This is a brute force way of changing to descriptive names

MeanStdData$activity[MeanStdData$activity == 1] <- "WALKING"
MeanStdData$activity[MeanStdData$activity == 2] <- "WALKING_UPSTAIRS"
MeanStdData$activity[MeanStdData$activity == 3] <- "WALKING_DOWNSTAIRS"
MeanStdData$activity[MeanStdData$activity == 4] <- "SITTING"
MeanStdData$activity[MeanStdData$activity == 5] <- "STANDING"
MeanStdData$activity[MeanStdData$activity == 6] <- "LAYING"

#End Step 3

#Start Step 4
#Appropriately label the data set with descriptive variable names.
#These are long names, so we will try to use camel case to make it a bit easier to 
#read, and remove all "punctuation" for usability
colnames(MeanStdData) <- gsub("-|\\.|\\()","",colnames(MeanStdData))
colnames(MeanStdData) <- gsub("mean","Mean",colnames(MeanStdData))
colnames(MeanStdData) <- gsub("std","Std",colnames(MeanStdData))
#End Step 4

#Start Step 5
#Create a second, independent tidy data set with the average of each variable 
#for each activity and each subject. 
# Let's aggregate, by the variables (3:42) for both activity and subject
allout <- aggregate(MeanStdData[,3:42], list(subject = MeanStdData$subject,activity=MeanStdData$activity),mean)
# we should rename the columns by putting something descriptive 
# like AggMeanOf in the colnames for the variables. They all start with
# tBody or tGravity, so that should be a help
colnames(allout) <- gsub("tBody", "AggMeanOfTBody",colnames(allout))
colnames(allout) <- gsub("tGravity", "AggMeanOfTGravity",colnames(allout))

#Now, lets just write it out
write.table(allout,file="MeanAggregateData.txt",row.names=FALSE)
#End Step 5
