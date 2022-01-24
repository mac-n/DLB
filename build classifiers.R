library(missForest)
library(FSelector)
library(RWeka)
MIDASlongcropped<-MIDAS_data_csv_format[,colnames(MIDAS_data_csv_format_cropped)]
MIDASlongcropped<-MIDASlongcropped[MIDASlongcropped$PAPER_Analysis_Group==2,]
MIDASlongcropped$PAPER_Analysis_Group<-NULL


MIDASlongcropped$Final_diag<-as.factor(MIDASlongcropped$Final_diag)

MIDASlongcropped$VAR00053<-NULL
forestobject<-missForest(data.matrix(MIDASlongcropped[,2:ncol(MIDASlongcropped)]))

colSums(is.na(MIDASlongcropped))

imputethis<-data.matrix(MIDASlongcropped[,2:ncol(MIDASlongcropped)])
fun =function(x){
  return(length(levels(x)))
}
imputethis<-data.frame(imputethis)
#imputethis[,which(sapply(imputethis,fun)<6)]<-sapply(imputethis[,which(sapply(imputethis,fun)<6)],as.ordered)
imputethis<-data.matrix(imputethis)
set.seed(100)
forestobject<-missForest(imputethis)
MIDASimputed<-data.frame(MIDASlongcropped)
MIDASimputed[,2:ncol(MIDASimputed)]<-forestobject$ximp
levels(MIDASimputed$Final_diag)<-c("DLB","AD")
set.seed(100)

classifierswithBI=list()

classifiersnoBI=list()
#MIDASimputedfull<-MIDASimputed
MIDASimputed<-MIDASimputed[,-(206:221)]

for (i in 1:nrow(MIDASimputed)){
  classifiersnoBI[[i]]<-JRip(Final_diag~.,data=MIDASimputed[-i,])
 
  classifierswithBI[[i]]<-JRip(Final_diag~.,data=MIDASimputedfull[-i,])
  print(i)
}

library(purrr)
library(modelr)
perms<-permute_(MIDASimputedfull, 100, columns=colnames(MIDASimputedfull)[2:ncol(MIDASimputedfull)],.id ="Final_diag")


testclassifiers<-map(perms$perm, ~JRip(Final_diag~.,data=.))
permutedclassifiersloocv<-list()
for (i in 1:33){
  permutedclassifiersloocv[[i]]<-JRip(Final_diag~.,data=perms$perm[[3]][[1]][-i,])
  
  
}

permutedcmlist<-list()
permutedaccuracy<-rep(0,33)
for (i in 1:33){
  permutedaccuracy[i]<-confusionMatrix(predict(permutedclassifiersloocv[[i]],perms$perm[[3]][[1]]),perms$perm[[3]][[1]]$Final_diag)$byClass["Balanced Accuracy"]
  }