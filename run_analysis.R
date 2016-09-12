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
#dim(activity_labels)
#  6 2

features <- read.table(file = "./features.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(features)
#  561   2


subject_train <- read.table(file = "./subject_train.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(subject_train)
#  7352    1

X_train <- read.table(file = "./X_train.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(X_train)
# 7352  561

#  X_train <- mapply(as.numeric,X_train)
#  dim(X_train)


y_train <- read.table(file = "./y_train.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(y_train)
#  7352    1

subject_test <- read.table(file = "./subject_test.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(subject_test)
#  2947    1

X_test <- read.table(file = "./X_test.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(X_test)
#  2947  561

y_test <- read.table(file = "./y_test.txt", sep="", strip.white = TRUE, header=FALSE, nrows=1000000, fill=TRUE, colClasses = "character")
#dim(y_test)
#   2947    1

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




