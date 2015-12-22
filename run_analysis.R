library (dplyr)

#read activity labels
activity_labels<-read.table("~/data/UCI_HAR/activity_labels.txt")

#read train data
X_train<-read.table("~/data/UCI_HAR/train/X_train.txt")
dim(X_train)
head(X_train)

#read subject id train data
subject_train<-read.table("~/data/UCI_HAR/train/subject_train.txt")

#add id to train data set
X_train<-cbind(X_train,subject_train)
dim(X_train)

#read and add activity
activity_train<-read.table("~/data/UCI_HAR/train/y_train.txt")
X_train<-cbind(X_train, activity_train)
dim(X_train)

#read test data
X_test<-read.table("~/data/UCI_HAR/test/X_test.txt")
dim(X_test)
head(X_test)

#read subject id test data
subject_test<-read.table("~/data/UCI_HAR/test/subject_test.txt")

#add id to test data set
X_test<-cbind(X_test,subject_test)
dim(X_test)

#read and add activity
activity_test<-read.table("~/data/UCI_HAR/test/y_test.txt")
X_test<-cbind(X_test, activity_test)
dim(X_test)

#join train and test dataset
X_full<-rbind(X_test,X_train)
dim(X_full)

#read colunm names
features<-read.table("~/data/UCI_HAR/features.txt")
features[,2]<-as.character(features$V2)
str(features)
features[562:563,2]<-c("id","activity")

colnames(X_full)<-features[,2]

# eliminate duplicated colunm name
X_clean<-X_full[, !duplicated(colnames(X_full))]
dim(X_clean)

#filter mean and std names
X_clean<-select(X_clean, contains("mean"), contains("std"), matches("id"), matches("activity"))
dim(X_clean)

summ<-aggregate(X_clean, by=list(X_clean$id, X_clean$activity), mean)

fun_activity_name<-function(x){
        activity_labels[activity_labels$V1==x,"V2"]
}
activity_name<-sapply(summ$activity, fun_activity_name)
#organize de data set, delect 2 columns and change id and activity positions 

clean_summ<-summ[,3:88]
id_subject<-summ[,"id"]

final_summ<-cbind(id_subject, activity_name, clean_summ)
head(final_summ)

write.table(final_summ, 'project.txt', row.names = FALSE)