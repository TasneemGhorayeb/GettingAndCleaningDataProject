READ ME!
-----------
Steps taken to create summary data from the raw data

        -Using script run_analysis.R
        -Make sure needed data are in the same folder
        -Install dplyr

Important variables

        summary <- the final data

Steps
--------------
1- Read test data; feature vector, activity labels and subject ids.

2- Read train data; feature vector, activity labels and subject ids.

3- Merging all those different info togther via cbind(), now for the test data and the train data each row contains feature vector in addition to the activity and the related subject who did them.

4- Merging the data set of test data and train data together, they have the same number of columns so I just append them by rbind()

5- Now that  I have the full Data I rename columns to have more meaning full names

        colnames(fullData)<- featureVectorColNames$V2
        colnames(fullData)[562] = "ActivityLabelId"
        colnames(fullData)[563] = "SubjectLabelId"

6- I remove columns I do not need, without avg and std deviation in the name.

        fullDataFiltered <- cbind(fullData[,grep("mean|std",colnames(fullData))],fullData[,562:563])

7- Change the ActivityLevelId to be a Factor, by merging with the activity_labels dataframe from rhe activity_labels.txt file.

        fullDataFilteredWithLabels <- merge(fullDataFiltered,activity_labels,by.x = "ActivityLabelId",by.y = "Id", all = TRUE)

8- Install dplyr 

        install.packages("dplyr")
        library(dplyr)
9- Compute the summary
 
summary <- fullDataFilteredWithLabels %>% 
        group_by(fullDataFilteredWithLabels$SubjectLabelId,fullDataFilteredWithLabels$ActivityLabel) %>% 
        summarise_all(funs(mean))
        
10- Summary Data written in the summary.txt file