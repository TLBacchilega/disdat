### Modeling NCEAS data

library(disdat) # pacchetto già installato
install.packages("forcats")
library(forcats) # for handling factor variables

# https://www.rdocumentation.org/packages/randomForest/versions/4.6-14/topics/randomForest

install.packages("randomForest") # Classification and Regression with Random Forest
library(randomForest)
# randomForest 4.6-14
# Type rfNews() to see new features/changes/bug fixes.

#Attaching package: ‘randomForest’

#The following object is masked from ‘package:ggplot2’:

    #margin

#Warning message:
#package ‘randomForest’ was built under R version 4.0.5 



install.packages("dplyr")
# Warning message:
#In file.copy(savedcopy, lib, recursive = TRUE) :
  #problem copying C:\Users\User\Documents\R\win-library\4.0\00LOCK\dplyr\libs\x64\dplyr.dll to C:\Users\User\Documents\R\win-library\4.0\dplyr\libs\x64\dplyr.dll: Permission denied

library(dplyr)
# Attaching package: ‘dplyr’

#The following object is masked from ‘package:randomForest’:

    #combine

#The following objects are masked from ‘package:stats’:

    #filter, lag

#The following objects are masked from ‘package:base’:

    #intersect, setdiff, setequal, union





install.packages("ROCR")
library(ROCR)



# Creating target group background (TGB) sample

install.packages("raster")
library(raster)



