# Getting and Cleaning Data Course
# Programming Assignment Instructions

#You should create one R script called run_analysis.R that does the following:

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

#==============================================================================
# 1. Merges the training and the test sets to create one data set.

# 1.1 Reading Test Data
subjectTest<-read.table("./3/UCI HAR Dataset/test/subject_test.txt",header=FALSE,sep="")
activityTest<-read.table("./3/UCI HAR Dataset/test/y_test.txt",header=FALSE,sep="")
featureTest<-read.table("./3/UCI HAR Dataset/test/X_test.txt",header=FALSE,sep="")

# 1.2 Reading Training Data
subjectTrain<-read.table("./3/UCI HAR Dataset/train/subject_train.txt",header=FALSE,sep="")
activityTrain<-read.table("./3/UCI HAR Dataset/train/y_train.txt",header=FALSE,sep="")
featureTrain<-read.table("./3/UCI HAR Dataset/train/X_train.txt",header=FALSE,sep="")

# 1.3 Merging Test and Training Data
subjectMerged<-rbind(subjectTest,subjectTrain)
activityMerged<-rbind(activityTest,activityTrain)
featureMerged<-rbind(featureTest,featureTrain)

# Now my dataset is made up by:
# subjectMerged
# activityMerged
# featureMerged

#==============================================================================
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# 2.1 Reading the list of features 
featureList<-read.table("./3/UCI HAR Dataset/features.txt",header=FALSE,sep="")

# 2.2 Extracting the index of "mean()" or "std()" measurements 
#     Vector containing the index of either the mean or std measure of featureMerged
mean_or_std_index<-grep("mean()|std()",featureList[,2])

# 2.3 Creating a new data frame with only the selected ("mean" and "std") features
MeanStd_featureMerged  <- featureMerged[,mean_or_std_index]

# Now my dataset is made up by:
# subjectMerged
# activityMerged
# MeanStd_featureMerged

#==============================================================================
# 3. Uses descriptive activity names to name the activities in the data set.

# 3.1 Reading the activity list 
activityList<-read.table("./3/UCI HAR Dataset/activity_labels.txt",header=FALSE,sep="")

#Now I have
# activityList    <- with the names of activities and their identifying numbers
# activityMerged  <- with the ifentifying numbers of the sampled activities

# 3.2 I scan activityMerged. For each observation (row):
#     (i)   get the activityNumber
#     (ii)  get the corresponding activityName from activityList
#     (iii) replace the activityNumber with the activityName in activityMerged
for(rowIndex in 1:nrow(activityMerged)){
        activityNumber<-activityMerged[rowIndex,1]
        activityName<-as.character(activityList[activityNumber,2])
        activityMerged[rowIndex,1]<-activityName
}

# Now my dataset is made up by:
# subjectMerged
# activityMerged  (with the names of activities instead of their numbers)
# MeanStd_featureMerged

#==============================================================================
# 4. Appropriately labels the data set with descriptive variable names. 

# 4.1 Rename the variable name that refers to the subjects
names(subjectMerged)<-"Subject"

# 4.2 Rename the varible name that refers to the activities
names(activityMerged)<-"Activity"

# 4.3 Rename the varibles' names that refer to the corresponding features
# NOTE: in step 2.1, I loaded the featureList.
# I scan MeanStd_featureMerged. For each selected features [mean, std] (column):
#     (i)   get the current variable name ("V1", "V2", ...)
#     (ii)  remove the "V" character and trasform the resulting string ("1", "2", ...) in a numeric type: featureNumber
#     (iii) get the corresponding featureName in the featureList (I think this is the best name)
#     (iv)  replace the current name with featureName in MeanStd_featureMerged

for(colIndex in 1:ncol(MeanStd_featureMerged)){
        currentVariableName<-names(MeanStd_featureMerged)[colIndex]
        featureNumber<-as.numeric(sub("V","",currentVariableName))
        featureName<-as.character(featureList[featureNumber,2])
        names(MeanStd_featureMerged)[colIndex]<-featureName
}

# Now my dataset is made up by:
# 1. subjectMerged   
# 2. activityMerged  (with the names of activity instead of their number)
# 3. MeanStd_featureMerged
# All variable names are set

# 4.4 I put together a new data frame from the previous 3 data frames
boundData<-cbind(subjectMerged,activityMerged,MeanStd_featureMerged)

# Now my whole dataset is made up by:
# 1. boundData

#==============================================================================
# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

# 5.1 I create a new data frame called 'tidyData' with 2 columns:
#     (i)  subject
#     (ii) activity

tidyData<-data.frame( subject=gl(30,6) , activity=rep(sort(unique(boundData$Activity)),30) )

# This is the way how the data frame 'tidyData' is organized:
# for each subject the list of activities is reported in the second column
#
# NOTE: the activities are SORTED by name
#
#    subject           activity
#1         1             LAYING
#2         1            SITTING
#3         1           STANDING
#4         1            WALKING
#5         1 WALKING_DOWNSTAIRS
#6         1   WALKING_UPSTAIRS

#7         2             LAYING
#8         2            SITTING
#9         2           STANDING
#..        ..               ...

# 5.2 Now, for each couple (subject,activity) I calculate the average of each variable.

# NOTE: I should use the function 'by' for dataframes, which works similarly to 'tapply'. 

# For each variable (feature) of boundData (I start from column numebr 3 because the 
# first two columns contains subject and activty):
#     (i)   Calculate the average of that feature for each subject and activity.
#           I store the result in a 'by' object named meanVariable.           
#     (ii)  I squeeze the values of meanVariable in flatMean
#     (iii) Append flatMean to tidyData. So tidyData has a new column
#     (iv)  Rename the column with the name of the feature

for(variableIndex in 3:ncol(boundData)){
        
        meanVariable<-by(boundData[,variableIndex],list(boundData$Activity,boundData$Subject),mean)
        flatMean<-do.call(rbind,as.list(meanVariable))
        
        # I temporarily use 'newColumn'
        tidyData$newColumn<-flatMean
        
        # Replace 'newColumn' with the name of the specified feature
        names(tidyData)[variableIndex]<-names(boundData)[variableIndex]
}

# 5.3 Write the completed data frame into a file
write.table(tidyData,file="./3/tidyData.txt",row.name=FALSE,sep=" ")