library(purrr)
library(modelr)

#create permuted noise data (shuffle the columns)
perms<-permute_(MIDASimputedfull, 100, columns=colnames(MIDASimputedfull)[2:ncol(MIDASimputedfull)],.id ="Final_diag")

#build classifiers on the noise data
testclassifiers<-map(perms$perm, ~JRip(Final_diag~.,data=.))

#extract classifier accuracy (based on training data) from the classifiers
accuracyvec<-rep(0,100)
for (i in 1:length(testclassifiers)){
  accuracyvec[i]<-summary(testclassifiers[[i]])$details["pctCorrect"]
}

#extract training data accuracy from the classifiers in Tables II and III

accuracy2vec<-rep(0,33)
accuracy3vec<-rep(0,33)
for (i in 1:length(classifierswithBI)){
  accuracy2vec[i]<-summary(classifierswithBI[[i]])$details["pctCorrect"]
  accuracy3vec[i]<-summary(classifiersnoBI[[i]])$details["pctCorrect"]
}

#combine them into one vector
accuracy4vec<-c(accuracy2vec,accuracy3vec)

#t test to compare noise-based classifiers with the real results
t.test(accuracy4vec,accuracyvec)
