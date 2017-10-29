#Preparing a clean global environment
rm(list = ls())

#installing necessary packages
install.packages("reshape2")
library(reshape2)

#loading activity labels and features file
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt",colClasses = "character")
features <- read.table("UCI HAR Dataset/features.txt",colClasses = "character")

# Extracting only the data containing mean and standard deviation within it
features_extracted <- grep(".*mean.*|.*std.*", features[,2])
features_descriptive <- features[features_extracted,2]

#Replacing the word to a proper descriptive one
features_descriptive = gsub('-mean', 'Mean', features_descriptive)
features_descriptive = gsub('-std', 'Std', features_descriptive)
features_descriptive <- gsub('[-()]', '', features_descriptive)


# Load the training datasets along with activities and subjects
train <- read.table("UCI HAR Dataset/train/X_train.txt")
train <-train[features_extracted]
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)


# Load the testing datasets along with activities and subjects
test <- read.table("UCI HAR Dataset/test/X_test.txt")
test <- test[features_extracted]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

# merge datasets and adding labels to it
int_Data <- rbind(train, test)
colnames(int_Data) <- c("subject", "activity", features_descriptive)

# Transforming into factor datatype
int_Data$activity <- factor(int_Data$activity, levels = activity_label[,1], labels = activity_label[,2])
int_Data$subject <- as.factor(int_Data$subject)

#Melting and decasting the data to a proper tidy dataset
melted_data <- melt(int_Data, id = c("subject", "activity"))
final_data <- dcast(melted_data, subject + activity ~ variable, mean)

#Displays the final tidy data_set
View(final_data)

#writing the final output to tidy,txt file in the current directory
write.table(final_data, "tidy.txt", row.names = FALSE, quote = FALSE)