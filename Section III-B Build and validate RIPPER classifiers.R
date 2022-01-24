library(RWeka)
library(caret)

#set up the list variables for building RIPPER based classifiers
classifierswithBI=list()
classifiersnoBI=list()
#dataset with brain imaging
MIDASimputedfull<-MIDASimputed
#dataset without brain imaging
MIDASimputed<-MIDASimputed[,-(206:221)]

#build the classifiers shown in Tables II and III using LOOCV and RIPPER
for (i in 1:nrow(MIDASimputed)){
  classifiersnoBI[[i]]<-JRip(Final_diag~.,data=MIDASimputed[-i,])
  classifierswithBI[[i]]<-JRip(Final_diag~.,data=MIDASimputedfull[-i,])
  print(i)
}

#print out data for Tables II and III (classifier rules and accuracy on whole dataset) into file
library(caret)
sink('withoutbrainimaging.txt')


for (i in 1:33){
  print(i)
  print(classifiersnoBI[[i]])
  print(confusionMatrix(predict(classifiersnoBI[[i]],MIDASimputedfull),MIDASimputed$Final_diag))
}
sink()
sink('withbrainimaging.txt')
for (i in 1:33){
  print(i)
  print(classifierswithBI[[i]])
  print(confusionMatrix(predict(classifierswithBI[[i]],MIDASimputedfull),MIDASimputed$Final_diag))
}
library(caret)
sink('withoutbrainimaging.txt')


for (i in 1:33){
  print(i)
  print(classifiersnoBI[[i]])
  print(confusionMatrix(predict(classifiersnoBI[[i]],MIDASimputedfull),MIDASimputed$Final_diag))
}
sink()
sink('withbrainimaging.txt')
for (i in 1:33){
  print(i)
  print(classifierswithBI[[i]])
  print(confusionMatrix(predict(classifierswithBI[[i]],MIDASimputedfull),MIDASimputed$Final_diag))
}
sink()

#test the classifiers on the out of sample data 

#set up vectors to hold results
predictionswithBI<-rep(0,33)
predictionswithoutBI<-rep(0,33)

#perform the predictons
for (i in 1:length(classifierswithBI)){
  predictionswithBI[i]<-predict(classifierswithBI[[i]],MIDASimputedfull[i,])
  predictionswithoutBI[i]<-predict(classifiersnoBI[[i]],MIDASimputed[i,])
}

predictionswithoutBI<-as.factor(predictionswithoutBI)
levels(predictionswithoutBI)<-levels(MIDASimputedfull$Final_diag)
confusionMatrix(MIDASimputedfull$Final_diag,predictionswithoutBI)
predictionswithBI<-as.factor(predictionswithBI)
levels(predictionswithBI)<-levels(MIDASimputedfull$Final_diag)
confusionMatrix(MIDASimputedfull$Final_diag,predictionswithBI)
