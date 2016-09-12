
Objective: 
Follow the 5 steps given in the readme file to produce two data sets meeting 
tidy data guidelines as outlined in class notes, and by Hadley Wickam. The finished 
work should also include a readme and codebook (this one) explaining everything.

The original data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
We received the full set of raw data, and also some partially analyzed results. The raw data
is basically a time series (50HZ) of 3D accelerations and gyroscopic movements captured then processed using 
frequency filtering techniques, and finially a FFT transformation. This raw data is therefore
processed into the semi-finished data represented by the test and train datasets. To this extent the inertial 
folders contain data no longer relevant to the analysis now required. We can ignore those folders.

Tasks and Process steps undertaken in the R script:

1) Merges the training and the test sets to create one data set. Reviewing the files dims makes it apparent how they must be constructed.

#  dim(activity_labels)
#  6 2

#  dim(features)
#  561   2

#  dim(subject_train)
#  7352    1

#  dim(X_train)
#  7352  561

#  X_train <- mapply(as.numeric,X_train)
#  dim(X_train)

#  dim(y_train)
#  7352    1

#  dim(subject_test)
#  2947    1

# dim(X_test)
# 2947  561

#  dim(y_test)
#  2947    1

Column data file is the features file, and the data was partitioned randomly into two data files called
X_test, and X_train. The activity and suject files were also appended column wise to make a final set.

2) "Extracts only the measurements on the mean and standard deviation for each measurement".
The question is ambiguous, but I interpreted this to meam we take all occurances of these words. 
In doing so I reduced the feature data columns from 561 to 86. 

3) "Uses descriptive activity names to name the activities in the data set".
Here I substituted the desrciptive names (like 'walking, sitting') in place of the factor numbers

4) "Appropriately labels the data set with descriptive variable names"
The names can be simplified to a more readable format by the following transformations:
     - reduce to lower case
	 - replace () with blank spaces
	 - replace blank spaces with underscore characters
	 

Tidydata_part1.csv is the result. The full transformation code is to be found in the script comments
step by step. The file is large so use the download button to view it.

The final readable columns are below:
activity
subject
tbodyacc_mean_x
tbodyacc_mean_y
tbodyacc_mean_z
tbodyacc_std_x
tbodyacc_std_y
tbodyacc_std_z
tgravityacc_mean_x
tgravityacc_mean_y
tgravityacc_mean_z
tgravityacc_std_x
tgravityacc_std_y
tgravityacc_std_z
tbodyaccjerk_mean_x
tbodyaccjerk_mean_y
tbodyaccjerk_mean_z
tbodyaccjerk_std_x
tbodyaccjerk_std_y
tbodyaccjerk_std_z
tbodygyro_mean_x
tbodygyro_mean_y
tbodygyro_mean_z
tbodygyro_std_x
tbodygyro_std_y
tbodygyro_std_z
tbodygyrojerk_mean_x
tbodygyrojerk_mean_y
tbodygyrojerk_mean_z
tbodygyrojerk_std_x
tbodygyrojerk_std_y
tbodygyrojerk_std_z
tbodyaccmag_mean
tbodyaccmag_std
tgravityaccmag_mean
tgravityaccmag_std
tbodyaccjerkmag_mean
tbodyaccjerkmag_std
tbodygyromag_mean
tbodygyromag_std
tbodygyrojerkmag_mean
tbodygyrojerkmag_std
fbodyacc_mean_x
fbodyacc_mean_y
fbodyacc_mean_z
fbodyacc_std_x
fbodyacc_std_y
fbodyacc_std_z
fbodyacc_meanfreq_x
fbodyacc_meanfreq_y
fbodyacc_meanfreq_z
fbodyaccjerk_mean_x
fbodyaccjerk_mean_y
fbodyaccjerk_mean_z
fbodyaccjerk_std_x
fbodyaccjerk_std_y
fbodyaccjerk_std_z
fbodyaccjerk_meanfreq_x
fbodyaccjerk_meanfreq_y
fbodyaccjerk_meanfreq_z
fbodygyro_mean_x
fbodygyro_mean_y
fbodygyro_mean_z
fbodygyro_std_x
fbodygyro_std_y
fbodygyro_std_z
fbodygyro_meanfreq_x
fbodygyro_meanfreq_y
fbodygyro_meanfreq_z
fbodyaccmag_mean
fbodyaccmag_std
fbodyaccmag_meanfreq
fbodybodyaccjerkmag_mean
fbodybodyaccjerkmag_std
fbodybodyaccjerkmag_meanfreq
fbodybodygyromag_mean
fbodybodygyromag_std
fbodybodygyromag_meanfreq
fbodybodygyrojerkmag_mean
fbodybodygyrojerkmag_std
fbodybodygyrojerkmag_meanfreq
angletbodyaccmean_gravity
angletbodyaccjerkmean_gravitymean
angletbodygyromean_gravitymean
angletbodygyrojerkmean_gravitymean
anglex_gravitymean
angley_gravitymean
anglez_gravitymean

5) "From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."
Tidydata_part2.csv is the result. Again, the question is ambiguous. We know that there are multiple readings for each subject:activity combination. The 
request is therefore for the average of these combinations per variable, not the average of one then the average of the other. 


Code used:
You can paste and run this as long as you have downloaed the files
Warning: reading the two data files may take 10 minutes and consume your full RAM!!! Thats the problem I had.

Start of code.................................................
##

## Tidydata assignment from week 4 (Coursera)
## this script will carry out all the steps for steps 1-5 outlines in the assignment.
## see the Github README for more detail

#need these packages in addition to the basic
library(dplyr)
library(tidyr)
library(stringr)
library(hms)

# Download the zip file to your wd before starting. My
# wd is different from yours. Beware if you do run this script.

# data files were download to my working directory
#use read.table to extract what is needed

activity_labels <- read.table(file = "./activity_labels.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(activity_labels)
#  6 2

features <- read.table(file = "./features.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(features)
#  561   2


subject_train <- read.table(file = "./subject_train.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(subject_train)
#  7352    1

X_train <- read.table(file = "./X_train.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(X_train)
#  7352  561

#  X_train <- mapply(as.numeric,X_train)
#  dim(X_train)


y_train <- read.table(file = "./y_train.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(y_train)
#  7352    1

subject_test <- read.table(file = "./subject_test.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(subject_test)
#  2947    1

X_test <- read.table(file = "./X_test.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
# dim(X_test)
# 2947  561

y_test <- read.table(file = "./y_test.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#  dim(y_test)
#  2947    1

# conclusions: 
#the dims make it clear which sets can be combines.

#prepare the column headers for a future step
# clean up the features data so that the numbers are removed and they will make tidy column names later
featureslabel <- strsplit(features$V2," ")
featureslabel <- tolower(featureslabel)
featureslabel <- str_replace_all(string=featureslabel,pattern= "[(]|[)]",replacement="")
featureslabel <- str_replace_all(string=featureslabel,pattern= "[,]|[-]",replacement="_")


# start the tidy up process with the 'test' data
names(X_test) <- featureslabel
X_test <- mapply(as.numeric,X_test)
tdtest1 <- cbind(subject_test,X_test)
tdtest2 <- cbind(y_test,tdtest1)
#good idea to save the group as part of the tidy data although not specifically requested
origin <- rep("test",2947)
tdtest3 <- cbind(origin,tdtest2)

colnames(tdtest3)[2] <- "activity"
colnames(tdtest3)[3] <- "subject"

#check the first few rows/columns
#tdtest3[1:3,1:5]


#
# now do the tidy up process on the 'train' data
names(X_train) <- featureslabel
X_train <- mapply(as.numeric,X_train)
tdtrain1 <- cbind(subject_train,X_train)
tdtrain2 <- cbind(y_train,tdtrain1)
tdtrain2[1:3,1:5]
dim(tdtrain2)
origin <- rep("train",7352)
tdtrain3 <- cbind(origin,tdtrain2)

colnames(tdtrain3)[2] <- "activity"
colnames(tdtrain3)[3] <- "subject"

#check the first few rows/columns
#tdtrain3[1:3,1:5]


# now we can consolidate both data sets (test and train) into one
#the origin data column was added to preserve the original random partitioning of the data into two groups
#it may be useful to later experiments and we should capture it
td1 <- rbind(tdtest3, tdtrain3)
#dim(td1)


#which columns qualifying as "only the mean and standard deviation for each measurement"
#Because of the ambiguity I MUST incluse all columns having occurences of these terms. They can
picknames <- which(grepl("origin|activity|subject|[Mm]ean|std",names(td1)),TRUE)
td2 <- td1[,picknames]
#td2[1:20,1:5] # as a test
#dim(td2)


# the data is now all neat and tidy except for one thing. We need to have descriptive names for the activities
td3 <-td2
td3$activity[td3$activity=="1"] <- "WALKING"
td3$activity[td3$activity=="2"] <- "WALKING_UPSTAIRS"
td3$activity[td3$activity=="3"] <- "WALKING_DOWNSTAIRS"
td3$activity[td3$activity=="4"] <- "SITTING"
td3$activity[td3$activity=="5"] <- "STANDING"
td3$activity[td3$activity=="6"] <- "LAYING"

#now the data is tidy
# unique(td3$activity) # is a check
# AT THIS POINT REQUIREMENTS 1-4 ARE MET.
write.csv(td3,file="./tidydata_part1.csv",quote=F, row.names=F)

# I uploaded a csv of this output. You can open directly
# or use read.csv.

#
#
#
#

#Begin work on question 5
#create factor variables to make aggregation easier
td4 <- td3
td4$activity <-as.factor(td4$activity)
td4$subject <-as.numeric(td4$subject)

#str(td4)

td5 <-select(td4,-origin,activity,subject,tbodyacc_mean_x:anglez_gravitymean)

td6 <- aggregate(. ~ activity+subject,td5,mean)
td7 <- arrange(td6,desc(activity),subject)
#td7[,1:5]

#this file is grouped by activity, and subject with the other variables displayed by mean
#I have saved a csv version to Github. Both were derived from running this R script.
write.csv(td7,file="./tidydata_part2.csv",quote=F, row.names=F)
# this completes question 5 of the assignment.
dim (features)


