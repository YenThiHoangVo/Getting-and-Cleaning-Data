library(dplyr)

## read train data
X_train <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")

## read test data
X_test <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")

## read variable names
var_names <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/features.txt")

## read activity labels
activity_labels <- read.table("~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")

## merge the training and test sets
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
Sub <- rbind(Sub_train, Sub_test)

## extract variables of interest (e.g., mean, std)
var_of_interest <- var_names[grep("mean\\(\\)|std\\(\\)", var_names[,2]),]
X <- X[, var_of_interest[,1]]

## add a column named activity in the Y data set
colnames(Y) <- "activity" 
Y$activitylabel <-factor(Y$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y[,-1]

## label the activity in the Y data set
colnames(X) <- var_names[var_of_interest[,1],2]

## create a tidy data set with the average of each var for each activity and subject
colnames(Sub) <- "subject"
final_data <- cbind(X, activitylabel, Sub)
final_mean <- final_data %>% group_by(activitylabel, subject) %>% summarise_each(funs(mean))
write.table(final_mean, file = "~/Downloads/Getting and Cleaning Data/UCI HAR Dataset/tidydata.txt", 
            row.names = FALSE, col.names = TRUE)
