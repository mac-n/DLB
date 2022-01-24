# DLB

This is the R code for the paper Distinguishing Lewy Body Dementia from Alzheimer’s Disease using Machine Learning on Heterogeneous Data: A Feasibility Study submitted to EMBC 2022

The data used here can be made available on reasonable request from author JPMK upon reasonable request.
All codes are written in R version 3.5.2

# Preprocessing
The file "Preprocessing - data cleaning and missing value imputation.R" creats the dataset that is used as input throughout, with missing values imputed by missForest

#R ecreating Results Section III-A

The file "Section III-A Extract RFI and draw graph.R" extracts Random Forest Importance from the dataset and generates the graph in the paper. 

# Recreating Results Section III-B

The file "Section III-B Build and validate RIPPER classifiers.R" builds the association rules classifiers shown in Tables II and III using the RIPPER algorithm, outputs the rules, accuracy, sensitivity and specificity over the whole dataset of each into files, and runs LOOCV to test each classifier against its out of sample case

# Recreating Results Section III-C

The file "Section III-C Create noise data and compare classifier results.R" creates 100 instances of permuted "noise" data, applies the RIPPER algorithm to each to create classifiers, and compares the in-sample accuracy of these classifiers to the in-sample accuracy of classifiers shown in Tables II and III
