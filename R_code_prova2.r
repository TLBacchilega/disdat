### Modeling NCEAS data

# https://cran.r-project.org/web/packages/disdat/index.html
# https://cran.r-project.org/web/packages/disdat/vignettes/modeling.html
# A function disPredictors returns the names of all predictor variables in the dataset and disCRS returns the information about coordinate reference system of each region.
#the function disMapBook enables you to generate maps, in PDF format, showing the location of PO and PA data for all species within one or more regions

# Modeling all species with one modeling method - example

#NSW
#Provided by Simon Ferrier
#13 variables:  see NSW\01_metadata_NSW_environment.csv
#Coordinate reference system: unprojected WGS84 datum
#EPSG:4326
#Units: decimal degree
#Raster cell size: 0.000899322 degrees (approx 100m)

# The way we organise the species data for modeling suits the randomForest package - each modeling method has different requirements.

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

#setwd("C:/nomecartella/") # Windows


# da guardare! 

# Prepare for modeling:

# set output directory for prediction csv files:
outdir <- "~/Desktop/modeling_nceas"
# provide names for regions to be modeled - here we model all 6:
regions <- c("AWT", "CAN", "NSW", "NZ", "SA", "SWI")
# specify names of all categorical variables across all regions:
categoricalvars <- c("ontveg", "vegsys", "toxicats", "age", "calc")

# check the model's output directory
if(file.exists(outdir)){
  print("The directory already exists!")
} else{
  dir.create(file.path(outdir))
  print("The directory is created.")
}


#+   print("The directory already exists!")
#+ } else{
#+   dir.create(file.path(outdir))
#+   print("The directory is created.")
#+ }
#[1] "The directory is created."
#Warning message:
#In dir.create(file.path(outdir)) :
#  cannot create dir 'C:\Users\User\Documents\Desktop\modeling_nceas', reason 'No such file or directory'

# da guardare!
#n <- 0
#for(r in regions){
# reading presence-only and background species data for this region, one file per region:
# presences <- disPo(r)
#background <- disBg(r)
  
  # extract names for all species
  #species <- unique(presences$spid)
  
  # now for each species, prepare data for modeling and evaluation 
  # with randomForests, model, predict to the evaluation file with 
  # environmental data. 
  #for(s in species){
    # subset presence records of species for this species
    #sp_presence <- presences[presences$spid == s, ]
    # add background data
    #pr_bg <- rbind(sp_presence, background)
    
    # find the evaluation file – for some regions this means identifying the taxonomic group
    #if (r %in% c("AWT", "NSW")) {
     # grp <- sp_presence[, "group"][1]
      #evaluation <- disEnv(r, grp)
    #} else {
     # evaluation <- disEnv(r)
    #}



# convert categorical vars to factor in both training and testing data. We use the package forcats to ensure that the levels of the factor in the evaluation data match those in the training data, regardless of whether all levels are present in the evaluation data. 
    #for(i in 1:ncol(pr_bg)){
      #if(colnames(pr_bg)[i] %in% categoricalvars){
       # fac_col <- colnames(pr_bg)[i]
        #pr_bg[ ,fac_col] <- as.factor(pr_bg[ ,fac_col])
        #evaluation[ ,fac_col] <- as.factor(evaluation[ ,fac_col])
        #evaluation[ ,fac_col] <- forcats::fct_expand(evaluation[,fac_col], levels(pr_bg[,fac_col]))
        #evaluation[ ,fac_col] <- forcats::fct_relevel(evaluation[,fac_col], levels(pr_bg[,fac_col]))
      #}
    #}
    
    # extract the relevant columns for modelling
    #model_data <- pr_bg[, c("occ", disPredictors(r))]
    # convert the response to factor for RF model to return probabilities
    #model_data$occ <- as.factor(model_data$occ)
    
    # start modeling! We use the "try" notation so if a species fails to fit, the loop will continue.
    #n <- n + 1
    #if(inherits(try(
     # mod <- randomForest(occ ~ ., data = model_data, ntree = 500)
    #), "try-error")){print(paste("Error for species", s, "from", r))}
    
    # make and save the prediction
    #out_file <- evaluation[,1:3]
    #out_file$spid <- sp_presence$spid[1]
    #out_file$group <- sp_presence$group[1]
    #out_file$prediction <- predict(mod, evaluation, type = "prob")[,"1"] # prediction for presences
    #write.csv(out_file, paste(outdir, "/", r, "_", s, "_rf", ".csv", sep=""), row.names = FALSE)
    #print(n) # [1] 1
  #}
#}



# Evaluating the models


install.packages("dplyr")
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


#da guardare
# specify the output folder that contains species predictions, and in which to save the models results
#modelsdir <- "~/Desktop/modeling_nceas"

# get the names of all the prediction files
#sp_preds <- list.files(modelsdir, pattern = ".csv$", full.names = FALSE)

# a data.frame to save the evaluation result
#rf_eval <- data.frame(region = rep(NA, length(sp_preds)), 
 #                     species = NA, 
 #                     auc = NA)

# now a loop to evaluate each species, one at a time:
#n <- 0
#for(i in sp_preds){
 # pred <- read.csv(file.path(modelsdir, i), stringsAsFactors = FALSE)
  # get information on the species (s) and region (r) for each file:
  #r <- unlist(strsplit(i, "_"))[1]
  #s <- unlist(strsplit(i, "_"))[2]
  
  # now evaluate predictions, finding the right column for this species
  # find the evaluation file – for some regions this means identifying the taxonomic group
 # if (r %in% c("AWT", "NSW")) {
  #  grp <- pred[pred$spid == s, "group"][1]
   # evals <- disPa(r, grp)
  #} else {
   # evals <- disPa(r)
  #}
  
  #n <- n + 1
  #perf <- prediction(pred$prediction, evals[, s]) %>% 
   # performance("auc")
  #rf_eval$region[n] <- r
  #rf_eval$species[n] <- s
  #rf_eval$auc[n] <- as.numeric(perf@y.values)
  #print(s)
#}

#mean(rf_eval$auc)
#hist(rf_eval$auc)

# auc mean for region
#rf_eval %>% 
#  group_by(region) %>% 
 # summarise(mean(auc))












# Creating target group background (TGB) sample

# NSW has several groups of species, so is one of the more complex examples
#TGB example
# The code below assumes you have set your working directory, and the environmental rasters are in a sub-folder “env_grids”, with the rasters for each region within their respective regional folders


install.packages("raster")
library(raster)
# Carico il pacchetto richiesto: sp

#Attaching package: ‘raster’

# The following object is masked from ‘package:dplyr’:

#   select

#The following object is masked from ‘package:tidyr’:

#    extract




po <- disPo("NSW")
nsw.raster <- raster("env_grids/nsw/mi.tif")

table(po$group) # ba   db   nb   ot   ou   rt   ru   sr 
                # 187 1513  268  339  167   64  110  675 

target.groups <- list("bat"= "ba", "bird"= c("db", "nb"), "plant"= c("ot", "ou", "rt", "ru"), "reptile"= "sr") 
tgb.data <- list()

for(i in 1:4){
  getgroup <- match(po$group, target.groups[[i]])
  dat <- po[!is.na(getgroup),]
  samplecellID <- cellFromXY(nsw.raster,dat[,c("x","y")]) 
  dup <- duplicated(samplecellID)
  tgb.data[[i]] <- dat[!dup,]
}

names(tgb.data) <- names(target.groups)




