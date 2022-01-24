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
cmlistnoBI<-list()
cmlistBI<-list()
matrixwithbrainimaging<-matrix(nrow=33,ncol=3)
colnames(matrixwithbrainimaging)<-c("Accuracy","Sensitivity","Specificity")
matrixwithoutbrainimaging<-matrixwithbrainimaging
for (i in 1:33){
  print(i)
  #print(classifiersnoBI[[i]])
  cmlistnoBI[[i]]<-confusionMatrix(predict(classifiersnoBI[[i]],MIDASimputedfull),MIDASimputed$Final_diag)
  cmlistBI[[i]]<-confusionMatrix(predict(classifierswithBI[[i]],MIDASimputedfull),MIDASimputed$Final_diag)
  matrixwithbrainimaging[i,]<-c(cmlistBI[[i]]$byClass["Balanced Accuracy"],cmlistBI[[i]]$byClass["Sensitivity"],cmlistBI[[i]]$byClass["Specificity"])
  matrixwithoutbrainimaging[i,]<-c(cmlistnoBI[[i]]$byClass["Balanced Accuracy"],cmlistnoBI[[i]]$byClass["Sensitivity"],cmlistnoBI[[i]]$byClass["Specificity"])
  
}



accuracyvec<-rep(0,100)
for (i in 1:length(testclassifiers)){
accuracyvec[i]<-summary(testclassifiers[[i]])$details["pctCorrect"]
}

accuracy2vec<-rep(0,33)
accuracy3vec<-rep(0,33)
for (i in 1:length(classifierswithBI)){
  accuracy2vec[i]<-summary(classifierswithBI[[i]])$details["pctCorrect"]
  accuracy3vec[i]<-summary(classifiersnoBI[[i]])$details["pctCorrect"]
}
predictionswithBI<-rep(0,33)
predictionswithoutBI<-rep(0,33)

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