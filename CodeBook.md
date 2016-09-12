
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

  dim(activity_labels)
  6 2

  dim(features)
  561   2

  dim(subject_train)
  7352    1

  dim(X_train)
  7352  561

 X_train <- mapply(as.numeric,X_train)
  dim(X_train)

  dim(y_train)
  7352    1

  dim(subject_test)
  2947    1

 dim(X_test)
 2947  561

  dim(y_test)
  2947    1

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
	 - converted from scientific notation to standard numeric representation
	 

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
See run_analysis.R
