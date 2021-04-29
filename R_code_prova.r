## Data Visualisation for disdat data

# https://cran.r-project.org/web/packages/disdat/index.html
# disdat: Data for Comparing Species Distribution Modeling Methods,These data are described and made available by Elith et al. (2020) https://doi.org/10.17161%2Fbi.v15i2.13384

install.packages("disdat")
library(disdat)

install.packages("GGally")
library(GGally)
# Registered S3 method overwritten by 'GGally':
# method from   
# +.gg   ggplot2

# https://www.rdocumentation.org/packages/ggplot2/versions/3.3.3
install.packages("ggplot2")
library(ggplot2) # GGally: Extension to ggplot2



install.packages("sf")
library(sf)
# Linking to GEOS 3.9.0, GDAL 3.2.1, PROJ 7.2.1

install.packages("tidyverse")
library(tidyverse)
# Errore: package or namespace load failed for ‘tidyverse’ in loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck = vI[[j]]):
 # namespace ‘pillar’ 1.5.1 is already loaded, but >= 1.6.0 is required
# Inoltre: Warning message:
# package ‘tidyverse’ was built under R version 4.0.5 

remove.packages("pillar")
install.packages("pillar")
library(pillar)
install.packages("tidyverse")
library(tidyverse)
# -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
# v ggplot2 3.3.3     v purrr   0.3.4
# v tibble  3.1.0     v dplyr   1.0.5
# v tidyr   1.1.3     v stringr 1.4.0
# v readr   1.4.0     v forcats 0.5.1
#-- Conflicts ------------------------------------------ tidyverse_conflicts() --
# x dplyr::dim_desc() masks pillar::dim_desc()
# x dplyr::filter()   masks stats::filter()
# x dplyr::lag()      masks stats::lag()
#Warning messages:
#1: package ‘tidyverse’ was built under R version 4.0.5 
#2: package ‘ggplot2’ was built under R version 4.0.5 
#3: package ‘readr’ was built under R version 4.0.5 
#4: package ‘forcats’ was built under R version 4.0.5 



library(disdat)
library(sf)

# https://www.rdocumentation.org/packages/tmap/versions/3.3-1/topics/tmap-package
install.packages("tmap") # visualizzazione mappa tematica, assomiglia alla sintassi di ggplot2
library(tmap)

install.packages("grid")
library(grid)



install.packages("mapview")
library(mapview)
# GDAL version >= 3.1.0 | setting mapviewOptions(fgb = TRUE)
# Warning message: package ‘mapview’ was built under R version 4.0.5 

library(sf)




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



