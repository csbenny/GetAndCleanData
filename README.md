# Getting And Cleaning Data Project

## Background 
This project aims to demonstrate the ability of collect, work and clean a data set. 

One of the most exciting areas in all of data science right now is wearable computing. 
In this project, we are using the data collected from experiments in which the accelerometers in the Samsung Galaxy S smartphone was used. 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The dataset can be downloaded from below URL.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## How to produce the result text file
1. Download the dataset from the aforementioned URL
2. Open RStudio and set your working directory
3. Unzip the downloaded zip file in Step 1 under the working directory 
4. Run the R script by running `source("run_analysis.R")` in RStudio
5. Once the run completed, you would find the output file **projectresult.txt** generated in the working directory

## File references
1. projectresult.txt: Tidy dataset result
2. CodeBook.md: It describes the variables, the data and any transformation or work was performed in cleaning up the data