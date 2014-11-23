---
title: "CodeBook"
output: html_document
---

This document is basically divided in two sections: in the first section there is the list of variables used in 'run_analysis.R' with their explanation, while, in the second section, there are explained: data, trasformations and the choices I made to perform the cleaning.

### Explanation of the varibles used in 'run_analysis.R'
* **subjectTest** : data frame imported from the file 'subject_test.txt'
* **activityTest** : data frame imported from the file 'y_test.txt'
* **featureTest** : data frame imported from the file 'X_test.txt'

* **subjectTrain** : data frame imported from the file 'subject_train.txt'
* **activityTrain** : data frame imported from the file 'y_train.txt'
* **featureTrain** : data frame imported from the file 'X_train.txt'

* **subjectMerged** : data frame where subjectTest and subjectTrain are merged by rows (with rbind) 
* **activityMerged** : data frame where activityTest and activityTrain are merged by rows (with rbind) 
* **featureMerged** : data frame where featureTest and featureTrain are merged by rows (with rbind) 

* **featuresList** : data frame imported from the file 'features.txt'

* **mean_or_std_index** : the featureMerged variable contains 561 columns. Indeed, there are 561 features and each of these is identified by an identifying number, called index. Therefore, in this variable, the indices of the obtained variables (mean or standard deviation) are stored.

* **MeanStd_featureMerged** : subset of featureMerged with only mean and standard deviation features

* **activityList** : data frame that contains the names of the six activities with their corresponding numbers

* **rowIndex** : index to scan the rows of activityMerged. I scan this data frame to replace the numbers of the activities with their corresponding names. For example 1 -> WALKING, 2 -> WALKING_UPSTAIRS, ...
* **activityNumber** : the identifying number of an activity (1, 2, 3, ...)
* **activityName** : the activities' names (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, ...)


* **colIndex** : index to scan the columns of MeanStd_featureMerged. I scan this data frame to replace the numbers of the feautures with their corresponding names. For example  1 -> tBodyAcc-mean()-X, 2 -> tBodyAcc-mean()-Y, ... .      
NOTE: If I execute:
```
names(MeanStd_featureMerged)
```
before the replacing, I obtain:
```
 [1] "V1"   "V2"   "V3"   "V4"   "V5"   "V6"   "V41"  "V42"  "V43"  "V44"  "V45"  "V46"  "V81"  "V82"  "V83" ...
```
They keep the number of the corresponding feature. So that the final index is given by just removing the initial "V".
* **featureNumber** : the numbers of the features (1, 2, 3, ...)
* **featureName** : the names of the features (tBodyAcc-mean()-X, tBodyAcc-mean()-Y, tBodyAcc-mean()-Z, ...)

* **boundData** : the data frame where I bind (by columns with cbind):
    1. subjectMerged,
    2. activityMerged 
    3. MeanStd_featureMerged

* **tidyData** : data frame where I store the average of each variable (feature) for each activity and each subject. I initialized it with activities and subjects organized in this way:

|     | subject | activity           |
| --- | ------- |------------------- |
| 1   | 1       | LAYING             |
| 2   | 1       | SITTING            |
| 3   | 1       | STANDING           |
| 4   | 1       | WALKING            |
| 5   | 1       | WALKING_DOWNSTAIRS |
| 6   | 1       | WALKING_UPSTAIRS   |
| 7   | 2       | LAYING             |
| 8   | 2       | SITTING            |
| 9   | 2       | STANDING           |
| ... | ...     | ...                |
| 178 | 30      | WALKING            |
| 179 | 30      | WALKING_DOWNSTAIRS |
| 180 | 30      | WALKING_UPSTAIRS   |

* **variableIndex** : index to scan the columns of boundData. Each column is a feature and through the 'by()' function I calculate the average value for each subject and each activity. 

* **meanVariable** : is a 'by' object containing the average value of a feature for each subject and activity

* **flatMean** : I use this variable to squeeze meanVarible. NOTE: the order follows the structure of 'tidyData'

### Explanation of the data, traformations and choices I made.
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

