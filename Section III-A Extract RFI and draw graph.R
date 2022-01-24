library(randomForest)
library(lattice)

#build randomForest model

forest<-randomForest(formula = Final_diag ~ ., data = MIDASimputed)

#create graph of random forest importance


Fig1data<-data.frame(forest$importance)
Fig1data$colour<-"blue"
Fig1data$colour[205:220]<-"red"


stripplot(Fig1data$MeanDecreaseGini,jitter.data=TRUE,amount=0.2,col=Fig1data$colour,xlab="Random Forest Importance",pch=16)
