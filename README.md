---
title: "README"
output: html_document
---

This README file should explain how all the scripts work and how they are connected.
In this programming assignment I produced just ONE script as specified in the istructions:
"You should create one R script called run_analysis.R that does the following. "

Brief guide to run the script.

You can download the raw data from the following link <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.
In order to let the source code work you have to unzip the data in the following path "./3", where "./" is the working directory of R.

Please save the script directly in the working directory so you can run it by typing 'source("run_analysis.R")'

The output of the script 'tidyData.txt' is exported in the same directory "./3".
You can correctly open it with EXCEL using the space character as separator.

### Explanation of the script.
These are the instrucitons to do the Programming Assignment.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

I decided to follow step by step these instrctions. Each step is divided into substeps.

1. Merges the training and the test sets to create one data set.
    1. Reading test data. 
        1. I load 'subject_test.txt' and store it in subjectTest.
        2. I load 'y_test.txt' and store it in activityTest.
        3. I load 'X_test.txt' and store it in featureTest.
        subjectTest, activityTest and featureTest are data frames.
    2. Reading training data. 
        1. I load 'subject_train.txt' and store it in subjectTrain.
        2. I load 'y_train.txt' and store it in activityTrain.
        3. I load 'X_train.txt' and store it in featureTrain.
        subjectTrain, activityTrain and featureTrain are data frames.
    3. I merge training and test data. 
        1. I merge subjectTest and subjectTrain in subjectMerged.
        2. I merge activityTest and activityTrain in activityMerged.
        3. I merge featureTest and featureTrain in featureMerged.
    4. Now my data set is made up by:
        * subjectMerged
        * activityMerged
        * featureMerged
    
2. Extracts only the measurements on the mean and standard deviation for each measurement.
    1. Loading the list of features in featureList. This is necessary to select only the desired features (mean() or std()). featureList is a data frame.
    2. From featureList, I extract the indices corresponding to the features that contain only a mean or a standard deviation. I store the resulting list of indices in mean_or_std_index.
    3. I create a new dataframe MeanStd_featureMerged where I store the mean or standard deviation features from featureMerged. MeanStd_featureMerged is therefore a subset of featureMerged.
    4. Now my data set is made up by:
        * subjectMerged
        * activityMerged
        * MeanStd_featureMerged

3. Uses descriptive activity names to name the activities in the data set.
The numbers of the activities are stored in activityMerged. I need to replace them with the corresponding associated names.
    1. I load 'activity_labels.txt' and store it in activityList. In this way, I have the list of activities with their corresponding numbers in the activityList data frame.
    2. I scan activityMerged and for each observation (row):
        1. take the identifying number of the activity in that row
        2. search for the corresponding name
        3. replace the number with the activity name in activityMerged
    3. Now my dataset is made up by:
        * subjectMerged
        * activityMerged (with the names of the activities instead of their numbers)
        * MeanStd_featureMerged

4. Appropriately labels the data set with descriptive variable names. I have to appropriately the names of the columns.
    1. Rename the column of the subjects with the label 'Subject'
    2. Rename the column of the activities with the label 'Activity'
    3. Rename all the columns of the mean or standard deviation features. Currently the names are 'V1', 'V2', ... The number next to the 'V' letter is the index of that feature in the featureList (containing the names of the features and their corresponding numbers). Then, for each column:
        1. Take the current name of the column.
        2. Remove the 'V' character and get only the numeric index.
        3. Get the name of the feature with that index (from featureList)
        4. Rename the column with the obtained name.
    4. I merge the three data frames: subjectMerged, activityMerged, MeanStd_featureMerged into one data frame boundData. Now this is my whole data set.
    
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    1. I initialize a new data frame tidyData with two columns: the subject and the activity. NOTE: the structure of the variable 'tidyData' is reported in the first section of the codebook. 
    2. Now I have to calculate the average of each variable (feature) for each subject and activity. Then, for each variable (feature):
        1. I calculate the average of a particular feature for each combination of subject and activity and I store it in meanVariable. To perform this operation I use the function 'by', that work similarly to 'tapply' for dataframes. As 'INDICES' parameter of the 'by' function, I provide a list of two indices: the subjects and the activities. 
        2. meanVariable is a 'by' object, I need to squeeze it to append the resulting  column to tidyData. Therefore, flatMean contains the squeezed data. VERY IMPORTANT NOTE: the squezing order follows the structure of the first two columns of tidyData (subject and activity).
        3. I append the new column to tidyData
        4. I rename the new appended column with the appropriate name
    3. I write the obtained data frame into a file called 'tidyData.txt' as requested.

