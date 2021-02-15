Tidy Data Project Submission on Human Activity Recognition Using Smartphone Data Set

This respository contains Andrea Altomare's completed submission for the Coursera Getting and 
Cleaning Data Peer-Reviewed Assignment. It contains tidy data from the "Human Activity Recognition
Using Smartphones Data Set"

Original Data Set can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

Files Included in the Repository are:
1. CodeBook.md - this code book describles all the variables, the data, and any transformations or work
		 performed to clean the data
2. run_analysis.R - an R script that completes the following using the original dataset above:
	- Merges the training and the test sets to create one data set.
        - Extracts only the measurements on the mean and standard deviation for each measurement. 
        - Uses descriptive activity names to name the activities in the data set
        - Appropriately labels the data set with descriptive variable names. 
        - From the data set in step 4, creates a second, independent tidy data set with the 
          average of each variable for each activity and each subject.
3. TidyData.txt - an exported final tidy dataset from the final lines of the run_analysis.R script
