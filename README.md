# cleaningdata
Coursera cleaning data project

This repo contains a script to process the data found here:
 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

These data need to be downloaded to the script working directory before processing the script.

A full description is available at the site where the data was obtained: 
 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The script run_analysis.R processes these data as follows:

- Reads in the UCI HAR data files
- Renames columns to provide more descriptive variable names (step 4 in assignment)
- Replaces descriptive activity codes with activity names (step 3 in assignment)
- Extracts only the measurements on the mean and standard deviation for each measurement. (step 2 in assignment)
- Merges the training and test data sets to create one data set (step 1 in assignment)
- Step 5:  From the data set in step 4, creates a second, independent tidy data set with the average 
- of each variable for each activity and each subject.
- Saves the output from step 5 to a file called "har_data_averages.csv

