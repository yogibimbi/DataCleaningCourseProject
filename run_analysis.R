library(dplyr)

dataDir = "UCI HAR Dataset"
test = "test"
train = "train"


columnHeaders = read.csv(paste(dataDir, "features.txt", sep = "/"), header = FALSE, stringsAsFactors = FALSE, sep = "")

# put together the test data
testSubjects = read.csv(paste(dataDir, test, paste("subject_", test , ".txt", sep = ""), sep = "/"), stringsAsFactors = FALSE, sep = "", header = FALSE)
names(testSubjects) = "subject"
testData = read.csv(paste(dataDir, test, paste("X_", test, ".txt", sep = ""), sep = "/"), stringsAsFactors = FALSE, sep = "", header = FALSE)
# 4. name the columns in a somewhat more understandable way
names(testData) = columnHeaders[, 2]
testLabels = read.csv(paste(dataDir, test, paste("y_", test, ".txt", sep = ""), sep = "/"), stringsAsFactors = FALSE, sep = "", header = FALSE)
names(testLabels) = "activity"
testDF = data.frame(testLabels, testData, testSubjects)

# put together training data
trainSubjects = read.csv(paste(dataDir, train, paste("subject_", train , ".txt", sep = ""), sep = "/"), stringsAsFactors = FALSE, sep = "", header = FALSE)
names(trainSubjects) = "subject"
# 4. name the columns in a somewhat more understandable way
trainData = read.csv(paste(dataDir, train, paste("X_", train, ".txt", sep = ""), sep = "/"), stringsAsFactors = FALSE, sep = "", header = FALSE)
names(trainData) = columnHeaders[, 2]
trainLabels = read.csv(paste(dataDir, train, paste("y_", train, ".txt", sep = ""), sep = "/"), stringsAsFactors = FALSE, sep = "", header = FALSE)
names(trainLabels) = "activity"
trainDF = data.frame(trainLabels, trainData, trainSubjects)

# 1. "merge" test and training data
allDF = rbind(testDF, trainDF)

# 2. get all headers that have an std or are mean
# (at least that is how I interpret item 2 of the assignment...:-S)
# by doing names() = c(), column names are changed, apparently, so, instead of columnHeaders, take names(allDF)
stdmeaners = c("activity", grep("\\b(std|mean)", names(allDF), value = TRUE, perl = TRUE), "subject")
stdmeanDF = allDF[, stdmeaners]

# 3. name the activites readably
activityLabels = read.csv(paste(dataDir, "activity_labels.txt", sep = "/"), header = FALSE, sep = "")
activities = factor(activityLabels[, 2])
stdmeanDF = mutate(stdmeanDF, activity = activities[activity])

# 5. group by subject and activity, then summarize
groupedDF = stdmeanDF %>% group_by(subject, activity) %>% summarise(tBodyAcc.mean...Y = mean(tBodyAcc.mean...Y))