Getting-Cleaning-Data
=====================

Course Project for Getting and Cleaning Data Data Science Coursera Course

The R script run_Analysis.R was written to clean the wearable computing dataset found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Specifically, it operates assuming the data are unzipped in the current working directory, so that a subdirectory called 
"UCI HAR Dataset/" is located in the current working directory.

The script will read in these 7 files:
features.txt
test/y_test.txt
test/X_test.txt
test/subject_test.txt
train/y_train.txt
train/X_train.txt
train/subject_train.txt

Column names for the data in the X_ files are taken from the features.txt file. 
It then cbinds the y_ X_ and subject_ data frames for the test and train sets, respectively
and finally rbinds the resulting test and train data frames into a single dataframe "Alldata" containing all of the data.
This data frame is then written out in the file Alldata.txt

Next, grep is used to pare down the Alldata data frame so that it only contains columns relating the the Mean or Standard
Deviation. Note that I decided to not include the means which were calculated for the Fast Fourier Transform data (variable
name starting with "f"), or the means resulting from averaging the data signals in a signal window sample (variable name 
starting with "angle". This left a data frame with 42 variables, as opposed to 563 variables in Alldata.

The script then assigns descriptive activity names to the activities, which were originally just labelled (1,2,3,4,5,6)
Using the activity_labels.txt file in "UCI HAR Dataset/", I was able to reassign the values in the activity variable to the 
descriptive name: (WALKING,WALKING_UPSTAIRS,WALKING_DOWNSTAIRS,SITTING,STANDING,LAYING).

Next, the script cleans up the variable names (originally from features.txt) to remove the punctuation characters such as ().-
and the labels are rewritten in CamelCase to make it easy to read.

Finally, this data frame is used to create a new tidy data set containing the average of each variable for each activity and 
each subject.
This is done by simply aggregating the data frame BY the 40 dependent variables (in [,3:42]), over both Subject and Activity, 
and computing the Mean. It then renames the columns for the 40 dependent variables to reflect that the values are now
the aggregate mean by prepending "AggMeanOf" to the column names. The resulting data frame is then written out to a file
called "MeanAggregateData.txt"


