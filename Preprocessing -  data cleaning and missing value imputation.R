#MIDAS data can be made available upon reasonable request from the corresponding author
library(missForest)

#data cleaning and tidying.
MIDASlongcropped<-MIDAS_data_csv_format[,colnames(MIDAS_data_csv_format_cropped)]
MIDASlongcropped<-MIDASlongcropped[MIDASlongcropped$PAPER_Analysis_Group==2,]
MIDASlongcropped$PAPER_Analysis_Group<-NULL
MIDASlongcropped$Final_diag<-as.factor(MIDASlongcropped$Final_diag)
MIDASlongcropped$VAR00053<-NULL

#checking missingness
colSums(is.na(MIDASlongcropped))

#impute training data separately from the outcome. 
imputethis<-data.matrix(MIDASlongcropped[,2:ncol(MIDASlongcropped)])
set.seed(100)
forestobject<-missForest(imputethis)

#bring the outcome and imputed values together
MIDASimputed<-data.frame(MIDASlongcropped)
MIDASimputed[,2:ncol(MIDASimputed)]<-forestobject$ximp

#change level names for ease of interpretation
levels(MIDASimputed$Final_diag)<-c("DLB","AD")
