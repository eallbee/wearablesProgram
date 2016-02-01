######################################################################
# Load the Training Datasets
print("loading train.x")
train.x <- read.table("./train/X_train.txt")
print("loading train.y")
train.y <- read.table("./train/y_train.txt")
print("loading train.subject")
train.subject <- read.table("./train/subject_train.txt")

# Load the Test Datasets
print("loading test.x")
test.x <- read.table("./test/X_test.txt")
print("loading test.y")
test.y <- read.table("./test/y_test.txt")
print("loading test.subject")
test.subject <- read.table("./test/subject_test.txt")

# Load the activity labels
print("loading activity.labels")
activity.labels <- read.table("activity_labels.txt")

# Load the features
print("loading features.txt")
features <- read.table("features.txt")

# merge test and training datasets to finalUCIHAR datasets
print("merging x")
finalUCIHAR.x <- rbind(train.x, test.x)
print("merging y")
finalUCIHAR.y <- rbind(train.y, test.y)
print("merging subject")
finalUCIHAR.subject <- rbind(train.subject, test.subject)

# extract just mean and standard 
# Grep the names for the word "mean" or "std" to return a vector of the column indexes
print("getting mean & std columns")
meanStandardDeviation <- grep("-(mean|std)\\(\\)", features[, 2])

#use the vector of the column indexes to get a final dataset with just the mean and 
#standard deviations
print("subsetting the mean & std columns")
finalUCIHAR.x <- finalUCIHAR.x[,meanStandardDeviation]
finalUCIHAR.y[,1] <- activity.labels[finalUCIHAR.y[,1],2]

# set the column names of the new datasets
print("setting the column names for x")
names(finalUCIHAR.x) <- features[meanStandardDeviation, 2]


print("setting the column names for y")
names(finalUCIHAR.y) <- "activity"

print("setting the column names for subject")
names(finalUCIHAR.subject) <- "subject"

#combine all the datasets into one big one
print("combining all datasets")
finalUCIHAR.combined <- cbind(finalUCIHAR.x, finalUCIHAR.y, finalUCIHAR.subject)

print("averaging all columns")
#get the averages of all the columns
#finalUCIHAR.averages <- ddply(finalUCIHAR.combined, .(finalUCIHAR.subject, finalUCIHAR.y), function(x) colMeans(x[, 1:66]))
finalUCIHAR.averages <- aggregate(finalUCIHAR.combined, by=list(activity = finalUCIHAR.combined$activity, subject=finalUCIHAR.combined$subject), mean)

#remove the un-needed columns
finalUCIHAR.averages <- finalUCIHAR.averages[3:68]

print("writing to text file")
#write the averages to a file for upload
write.table(finalUCIHAR.averages, "finalUCIHAR_averages.txt", row.name=FALSE)
