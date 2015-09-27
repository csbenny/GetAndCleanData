library(dplyr)

##1. Merges the training and the test sets to create one data set.
rootdata <- file.path(getwd(), "UCI HAR Dataset")
traindataset <- file.path(rootdata, "train")
testdataset <- file.path(rootdata, "test")

featurenames <- read.table(file.path(rootdata, "features.txt"))

trainset <- read.table(file=file.path(traindataset, "X_train.txt"), col.names=featurenames[,2])
trainset$Activity <- read.table(file=file.path(traindataset, "y_train.txt"), col.names=c("Activity"))[[1]]
trainset$Subject <- read.table(file=file.path(traindataset, "subject_train.txt"), col.names=c("Subject"))[[1]]

testset <- read.table(file=file.path(testdataset, "X_test.txt"), col.names=featurenames[,2])
testset$Activity <- read.table(file=file.path(testdataset, "y_test.txt"), col.names=c("Activity"))[[1]]
testset$Subject <- read.table(file=file.path(testdataset, "subject_test.txt"), col.names=c("Subject"))[[1]]

mergedset <- rbind(trainset, testset)

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
df_with_mean_or_std <- select(mergedset, matches("mean|std|Activity|Subject", ignore.case=TRUE))

##3. Uses descriptive activity names to name the activities in the data set
activitynames <- read.table(file=file.path(rootdata, "activity_labels.txt")) 
df_with_mean_or_std <- mutate(df_with_mean_or_std, Activity = factor(df_with_mean_or_std[["Activity"]], labels = activitynames[,2]))

##4. Appropriately labels the data set with descriptive variable names. 
colnames(df_with_mean_or_std) <- gsub("\\.","", tolower(colnames(df_with_mean_or_std)))

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summarized_df <- aggregate(x=df_with_mean_or_std, 
                           by=list(grpbyactivity=df_with_mean_or_std[["activity"]],grpbysubject=df_with_mean_or_std[["subject"]]), 
                           FUN="mean")
summarized_df <- select(summarized_df, -(activity:subject))
summarized_df <- arrange(summarized_df, grpbyactivity)

write.table(x=summarized_df, file=file.path(getwd(), "projectresult.txt"),row.names=FALSE)