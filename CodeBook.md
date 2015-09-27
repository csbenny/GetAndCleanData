# CodeBook

## Variables description
The variables in the output file **projectresult.txt** is an average of a specific piece of measurement feature data. Its name can tell: 
* Is it a time (t) or frequency (f) domain data ? 
* Is it a Body acceleration (bodyacc) / Gravity acceleration (gravityacc) data ? Any Mathematic / Statistical function (e.g. mean, std ... etc) applied ?
* X / Y / Z direction if it is a 3-axial signal data

For information about the variables used on the feature vector, please refer to the file **features_info.txt** in the downloaded dataset.

### List of Mathematic / Statistical functions

Function | Description
-------- | -----------
mean() | Mean value
std() | Standard deviation
mad() | Median absolute deviation 
max() | Largest value in array
min() | Smallest value in array
sma() | Signal magnitude area
energy() | Energy measure. Sum of the squares divided by the number of values. 
iqr() | Interquartile range 
entropy() | Signal entropy
arCoeff() | Autorregresion coefficients with Burg order equal to 4
correlation() | correlation coefficient between two signals
maxInds() | index of the frequency component with largest magnitude
meanFreq() | Weighted average of the frequency components to obtain a mean frequency
skewness() | skewness of the frequency domain signal 
kurtosis() | kurtosis of the frequency domain signal 
bandsEnergy() | Energy of a frequency interval within the 64 bins of the FFT of each window.
angle() | Angle between to vectors.

## Data description
From the downloaded dataset file, this project uses the below set of files.

Filename | Description
-------- | -----------
features.txt | List of all features
activity_labels.txt | Links the class labels with their activity name
train/X_train.txt | Training set
train/y_train.txt | Training labels
train/subject_train.txt | Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30
test/X_test.txt | Test set
test/y_test.txt | Test labels
test/subject_test.txt | Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30

For detailed information about the experiment, please refer to the file **README.txt** in the downloaded dataset.

## Data transformation
As the dataset we downloaded from the URL is raw data, we need to go through a series of steps in order to output a tidy dataset. 

### Step 1: Merges the training and the test sets to create one data set
As the obtained dataset has been randomly partitioned where 70% of the volunteers was selected for generating the training data and 30% the test data, we need to merge the two set together. 

As the data from either training / test set is spanned across three different files, we need to load the main data file (X_train.txt or X_test.txt) into a dataframe and then incorporate the corresponding activity label and subject into the dataframe.

```R
trainset <- read.table(file=file.path(traindataset, "X_train.txt"), col.names=featurenames[,2])
trainset$Activity <- read.table(file=file.path(traindataset, "y_train.txt"), col.names=c("Activity"))[[1]]
trainset$Subject <- read.table(file=file.path(traindataset, "subject_train.txt"), col.names=c("Subject"))[[1]]
```

Once we got the dataframes for both train and test set ready, we can simply merge them by using the `rbind` function.
```R
mergedset <- rbind(trainset, testset)
```

### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
As this project only concerns about the measures with mean and standard deviation, we can leverage the function `select` available in dplyr package and the special function `matches` to extract those measures from the merged dataframe.

```R
df_with_mean_or_std <- select(mergedset, matches("mean|std|Activity|Subject", ignore.case=TRUE))
```

### Step 3: Uses descriptive activity names to name the activities in thausee data set
As the data originated from the training label files are numerical value representing different kind of activities a particular subject performed, we need to transform them into a human understandable way. 

In order to do this, we can load the file **activity_labels.txt** and then leverage the function `mutate` from dplyr package to make the column 'Activity' presenting with the activity name.

```R
activitynames <- read.table(file=file.path(rootdata, "activity_labels.txt"))
df_with_mean_or_std <- mutate(df_with_mean_or_std, Activity = factor(df_with_mean_or_std[["Activity"]], labels = activitynames[,2]))
```

### Step 4: Appropriately labels the data set with descriptive variable names
If you look at the column names of the dataframe we have in step 3, they are all with different uppercase or even containing dot characters.
We need to make them all in lowercase and remove any dots if there are. 

This can be done by using the functions `tolower` and `gsub` to perform this tidy up operation
```R
colnames(df_with_mean_or_std) <- gsub("\\.","", tolower(colnames(df_with_mean_or_std)))
```

### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
After step 4, the dataframe is already in a good shape for performing any summary/aggregation operation in order to generate the data we are interested.

This project would like to know the average value for each of the variables for each activity and each subject. 
The function `aggregate` can get this desired data as follow:

```R
summarized_df <- aggregate(x=df_with_mean_or_std,
                           by=list(grpbyactivity=df_with_mean_or_std[["activity"]],grpbysubject=df_with_mean_or_std[["subject"]]),
                           FUN="mean")
```

If you look at the dataframe summarized_df:
* The ordering is not ordered by the activity and then by subject
* The column 'activity' are all populated with NA because they are not populated with numerical values after Step 3

For the reason that another two columns **grpbyactivity** and **grpbysubject** were generated after the aggreation function call, we can simply remove the two columns **activity** and **subject** from the dataframe and perform the ordering by calling the function `arrange` in dplyr package.

```R
summarized_df <- select(summarized_df, -(activity:subject))
summarized_df <- arrange(summarized_df, grpbyactivity)
```

Once all the above steps performed, the dataframe now contains the desired data and we can simply output to a txt file by performing the function call `write.table`

```R
write.table(x=summarized_df, file=file.path(getwd(), "projectresult.txt"),row.names=FALSE)
```
