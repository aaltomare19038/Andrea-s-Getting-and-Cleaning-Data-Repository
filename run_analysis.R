#COURSERA GETTING AND CLEANING DATA
#COURSE PROJECT


####################################################
#1. CREATE A WORKING DIRECTORY
####################################################
getwd()
if(!file.exists("./Project")){dir.create("./Project")}
setwd("./Project")

####################################################
#2. ASSIGN OBJECTS FOR ALL LINKS NEEDED IN SCRIPT
####################################################
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
features_list <- "UCI HAR Dataset\\features.txt"
test_set <- "UCI HAR Dataset\\test\\X_test.txt"
test_labels <- "UCI HAR Dataset\\test\\y_test.txt"
test_set_subjects <- "UCI HAR Dataset\\test\\subject_test.txt"
training_set <- "UCI HAR Dataset\\train\\X_train.txt"
training_labels <- "UCI HAR Dataset\\train\\y_train.txt"
training_set_subjects <- "UCI HAR Dataset\\train\\subject_train.txt"
activity_labels_link <- "UCI HAR Dataset\\activity_labels.txt"
tidy_dataset_link <- "TidyData.txt"



####################################################
#3. RETRIEVE THE ZIP FILE,
#DOWNLOAD TO WORKING DIRECTORY, AND UNZIP
####################################################
download.file(zipURL, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./Project")

####################################################
#4. READ IN THE COLUMN NAMES FOR THE TRAINING AND 
#TEST VOLUNTEER SUBJECTS
####################################################
features  <- read.table(features_list)
head(features)

#WE ONLY WANT THE COLUMN NAMES IN SECOND COLUMN.
names <- data.frame(t(features[-1]))
colnames(names) <- features[, 1]
head(names)

####################################################
#5. CREATE TEST VOLUNTEER SUBJECT DATA FRAME
####################################################
test_data <- read.table(test_set, col.names = names)
head(test_data, n=1)

test_labels <- read.table(test_labels, col.names = "ActivityID")
head(test_labels)

test_subjects <- read.table(test_set_subjects, col.names = "SubjectID")
head(test_subjects)

final_test <- cbind(test_data,test_labels, test_subjects)
table(final_test$ActivityID)
table(final_test$SubjectID)

####################################################
#6. CREATE TRAINING VOLUNTEER SUBJECT DATA FRAME
####################################################
training_data <- read.table(training_set, col.names = names)
head(training_data, n=1)

training_labels <- read.table(training_labels, col.names = "ActivityID")
head(training_labels)

training_subjects <- read.table(training_set_subjects, col.names = "SubjectID")
head(training_subjects)

final_training <- cbind(training_data, training_labels,training_subjects)
table(final_training$ActivityID)
table(final_training$SubjectID)

####################################################
# 7. STEP 1. MERGES THE TRAINING AND TEST SETS TO CREATE
# ONE DATA SET.
####################################################
merged_data <- merge(final_training, final_test, all=TRUE)
table(merged_data$ActivityID)
table(final_training$SubjectID)

####################################################
#8. STEP 2. EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN
#AND STANDARD DEVIATION FOR EACH MEASUREMENT
####################################################
cols <- grep("mean|std|ActivityID|SubjectID", names(merged_data), value=TRUE)
final <- merged_data[, cols]
head(final)

#REMOVE MEANFREQ FROM DATASET
final <- final[,-grep("meanFreq", colnames(final))]

####################################################
#9. STEP 3. USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE 
#ACTIVITIES IN THE DATA SET.
####################################################
activity_labels <- read.table(activity_labels_link, col.names = c("ActivityID","Activity"))
head(activity_labels)
final <- merge(final,activity_labels, by="ActivityID", all=TRUE)
table(final$ActivityID)
table(final$Activity)
table(final$SubjectID)

####################################################
#10. STEP 4. APPROPRIATELY LABELS THE DATA SET WITH 
#DESCRIPTIVE VARIABLE NAMES
####################################################
names(final) <- gsub("^t","Time",names(final))
names(final) <- gsub("^f","Frequency", names(final))
names(final) <- gsub("Acc", "Accelerometer", names(final))
names(final) <- gsub("Gyro", "Gyroscope", names(final))
names(final) <- gsub("Mag", "Magnitude", names(final))
names(final) <- gsub("BodyBody", "Body", names(final))
names(final) <- gsub("\\.","", names(final))
names(final) <- gsub("mean", "Mean", names(final))
names(final) <- gsub("std", "Std", names(final))

col_idx <- grep("SubjectID", names(final))
final <- final[,c(col_idx, 1:ncol(final))[-col_idx]]
str(final)
####################################################
#11. STEP 5. FROM THE DATA SET IN STEP 4, CREATE A 
#SECOND, INDEPENDENTLY TIDY DATA SET WITH THE 
#AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND
#EACH SUBJECT
####################################################
library(dplyr)
TidyData <- final %>%
  group_by(SubjectID, Activity) %>%
  summarise_all(funs(mean))
print(TidyData)
write.table(TidyData, tidy_dataset_link , row.name=FALSE)

