#You should create one R script called run_analysis.R that does the following.
#1- Merges the training and the test sets to create one data set.
#2- Extracts only the measurements on the mean and standard deviation for each measurement.
#3- Uses descriptive activity names to name the activities in the data set
#4- Appropriately labels the data set with descriptive variable names.
#5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Read test data
testFeatureVector <- read.table("test/X_test.txt") #[-1,1]
testActivityLabels<- read.table("test/y_test.txt",col.names = c("ActivityLabelId")) #[1,6]
testSubjects<- read.table("test/subject_test.txt",col.names = c("SubjectLabelId")) #[1,30]

#Read train data
trainFeatureVector <- read.table("train/X_train.txt") #[-1,1]
trainActivityLabels<- read.table("train/y_train.txt",col.names = c("ActivityLabelId")) #[1,6]
trainSubjects<- read.table("train/subject_train.txt",col.names = c("SubjectLabelId")) #[1,30]


##                              1- Merges the training and the test sets to create one data set.
#Merging the data set of test data
testFeatureVector_ActivityLabels <- cbind(testFeatureVector, testActivityLabels)
testFeatureVector_ActivityLabels_Subjects <- cbind(testFeatureVector_ActivityLabels,testSubjects)


#Merging the data set of train data
trainFeatureVector_ActivityLabels <- cbind(trainFeatureVector, trainActivityLabels)
trainFeatureVector_ActivityLabels_Subjects <- cbind(trainFeatureVector_ActivityLabels,trainSubjects)

fullData <- rbind(testFeatureVector_ActivityLabels_Subjects,trainFeatureVector_ActivityLabels_Subjects)

#Cleaning global env memory
rm(testFeatureVector,testActivityLabels,testSubjects)
rm(trainFeatureVector,trainActivityLabels,trainSubjects)
rm(testFeatureVector_ActivityLabels,testFeatureVector_ActivityLabels_Subjects,trainFeatureVector_ActivityLabels,trainFeatureVector_ActivityLabels_Subjects)

##                              #4- Appropriately labels the data set with descriptive variable names.
## For simplification, I chose to add the names of the columns in the dataframe before I filter on the names that have mean and std dev
featureVectorColNames <- read.table("features.txt")
colnames(fullData)<- featureVectorColNames$V2
colnames(fullData)[562] = "ActivityLabelId"
colnames(fullData)[563] = "SubjectLabelId"


#                               #2- Extracts only the measurements on the mean and standard deviation for each measurement.

fullDataFiltered <- cbind(fullData[,grep("mean|std",colnames(fullData))],fullData[,562:563])

                                #3- Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt",col.names = c("Id","ActivityLabel"))
fullDataFilteredWithLabels <- merge(fullDataFiltered,activity_labels,by.x = "ActivityLabelId",by.y = "Id", all = TRUE)
fullDataFilteredWithLabels <- within(fullDataFilteredWithLabels, rm(ActivityLabelId)) #Remove column not needed

                                #5- From the data set in step 4, creates a second, independent tidy data set with the average of
                                        #each variable for each activity and each subject.

install.packages("dplyr")
library(dplyr)
summary <- fullDataFilteredWithLabels %>% 
        group_by(fullDataFilteredWithLabels$SubjectLabelId,fullDataFilteredWithLabels$ActivityLabel) %>% 
        summarise_all(funs(mean))

summary <- within(summary, rm(ActivityLabel, SubjectLabelId)) #Remove column not needed
colnames(summary)[1] = "SubjectLabelId"
colnames(summary)[2] = "ActivityLabel"


#write.table(summary,file = "summary.txt",row.name=FALSE)










