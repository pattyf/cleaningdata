#
# run_analysis.R
#
# This script processes the UCI HAR data described at: 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
# The script does the following in the following order:
# Reads in the UCI HAR data files
# Renames columns to provide more descriptive variable names (step 4 in assignment)
# Replaces descriptive activity codes with activity names (step 3 in assignment)
# Extracts only the measurements on the mean and standard deviation for each measurement. (step 2 in assignment)
# Merges the training and test data sets to create one data set (step 1 in assignment)
# Step 5:  From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
# Saves the output from step 5 to a file
#
# IMPORTANT NOTE
# The script requires you update the working directory and have the HAR files
# in the working directory
######################################################################################################

#clean start
rm(list = ls())

#load libraries
library(dplyr)

# HEY YOU NEED TO UPDATE THE WORKING DIR LINE BELOW
setwd('/Users/pattyf/Documents/coursera/dataclean/UCI_har_data')

# The file features.txt contains the readable names for the 561 measured or calculated HAR values.
## These names can be used to rename the columns in x_test and x_train to make the data more readable
## The file applies to both test and train data sets.
feature_names561 <- read.table('features.txt')
length(feature_names561)

# The files X_test.txt  and X_train.txt contain the training and test data values 
# for the 561 variables identified in features.txt
test_data <- read.table('./test/X_test.txt')
train_data <- read.table('./train/X_train.txt')

#Rename the columns in xtest and xtrain with the values in fnames561
colnames(test_data) <-feature_names561[,2]
colnames(train_data) <-feature_names561[,2]

# Extracts only the measurements on the mean and standard deviation for each measurement.
# In other words, keep only the columns in the test and train data that include mean or std in their name
# (But not those with Mean in the col name as those are already averages of sample windows)
test_data <- subset(test_data, select = grepl("mean|std", names(test_data)))
train_data <- subset(train_data, select = grepl("mean|std", names(train_data)))

# The file activities.txt contains the readable names of the activity categories for which
# the data values where measured. 
# The file applies to both test and train data sets
activities <- read.table('activity_labels.txt')

# Rename the columns in activities to be more descriptive
activities <- rename(activities, activity_code = V1, activity_name = V2)

# The files y_test.txt and y_train.txt are the tables of 2947 rows by 1 column(V1) 
# where the column identifies the activity codes for each record
test_activities <- read.table('./test/y_test.txt')
train_activities <- read.table('./train/y_train.txt')

#rename the columns in ytest and ytrain
test_activities <- rename(test_activities, activity_code = V1)
train_activities <- rename(train_activities, activity_code = V1)

# Join the activity_names in the ativities dataframe to the ytest and ytrain data frames
# by activity_code
test_activities <- inner_join(test_activities,activities)
train_activities <- inner_join(train_activities,activities)

# The subject_test.txt files contain the data identifying the subject ID
# for each data record
test_subjects <- read.table('./test/subject_test.txt')
train_subjects <- read.table('./train/subject_train.txt')

#rename the column to make it understandable
test_subjects <- rename(test_subjects, subject_id = V1)
train_subjects <- rename(train_subjects, subject_id = V1)
 
# Add the Subject and Activities columns to the test and training data
test_data <- cbind(test_subjects,test_activities,test_data)
train_data <- cbind(train_subjects,train_activities,train_data)

# Combine test and training data into one data frame
all_data <- rbind(test_data,train_data)
 
# Drop activity_code bc it is not needed with activity name
all_data <- select(all_data,-c(activity_code))

# Find the mean of each measured mean and standard devation variable for each subject and activitiy
avg_by_activity_and_subject <- all_data %>% group_by(activity_name,subject_id) %>% summarise_each(funs(mean))

#Write out the result  - use write.csv which is a variant of write.table
write.csv(avg_by_activity_and_subject,file="har_data_averages.csv",row.names=FALSE)

