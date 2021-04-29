## Data Visualisation for disdat data

# https://cran.r-project.org/web/packages/disdat/index.html
# disdat: Data for Comparing Species Distribution Modeling Methods,These data are described and made available by Elith et al. (2020) https://doi.org/10.17161%2Fbi.v15i2.13384  
# The dataset is available on Open Science Framework and as an R package and can be used as a benchmark for modeling approaches and for testing new ways to evaluate the accuracy of SDMs.
# https://osf.io/kwc4v/ (cartella data)
# AWT (Australian Wet Tropics)
# Prepared by Karen Richardson, Caroline Bruce, Catherine Graham
#13 variables:  see AWT\01_metadata_AWT_environment.csv
#Coordinate reference system: UTM, zone 55, spheroid GRS 1980, datum GDA94
#EPSG:28355
#Units: m
#Raster cell size: 80 m


install.packages("disdat")
library(disdat)

setwd("C:/provadd/") # Windows

# Correlation matrix

awt <- disBg("AWT")
head(awt)

#  siteid    spid        x       y occ group bc01 bc04 bc05      bc06 bc12 bc15
# 1 100001 pseudo1 423335.8 7888328   0    NA 21.6 1.08 30.2 11.600000 1274  105
# 2 100002 pseudo1 484215.8 7842888   0    NA 23.7 1.06 31.7 12.900000  940  107
# 3 100003 pseudo1 349095.8 8043368   0    NA 18.8 1.02 27.8  9.400001 2177   74
# 4 100004 pseudo1 403655.8 7886248   0    NA 20.5 1.13 29.8 10.300000 1194  102
# 5 100005 pseudo1 366695.8 7970888   0    NA 21.2 1.05 30.1 11.100000 1341   93
# 6 100006 pseudo1 474055.8 7860328   0    NA 22.9 1.04 30.7 12.900000 1059  109
## bc17 bc20 bc31 bc33      slope topo       tri
# 1   56 19.5   55 0.16 40.7042000   29 540.28050
# 2   41 19.8   76 0.09  0.5810088    3  21.67948
# 3  170 18.5   18 0.65 19.6593600   26 776.79150
# 4   58 19.5   52 0.18  0.0000000    0 138.15930
# 5   87 19.4   44 0.27  9.7593110   22 622.67810
# 6   45 19.7   69 0.11 12.9008700    0 771.08560


# Density plots

install.packages("GGally")
library(GGally)
# Registered S3 method overwritten by 'GGally':
# method from   
# +.gg   ggplot2



# https://www.rdocumentation.org/packages/ggplot2/versions/3.3.3
install.packages("ggplot2")
library(ggplot2) # GGally: Extension to ggplot2

# create density plot for species presence-only vs background data
# first prepare the species records in the right format for the tidyverse package:
po <- disPo("AWT") # presence-only data
bg <- disBg("AWT") # background data
spdata <- rbind(po, bg)
spdata$occ <- as.factor(spdata$occ)
levels(spdata$occ) <- c("Landscape", "Species")
levels(spdata$occ)
## [1] "Landscape" "Species"

# now plot the data - specify the variable by its column name, as seen below in "aes(x = bc01,.....)"
ggplot(data = spdata, aes(x = bc01, fill = occ)) +
  geom_density(alpha = 0.4) +
  xlab("Annual mean temperature") +
  scale_fill_brewer(palette = "Dark2") +
  guides(fill = guide_legend(title = "")) +
  theme_bw()


# Example code for calculating the mean nearest-neighbor distance for one region - here, we use AWT:

install.packages("sf")
library(sf)
# Linking to GEOS 3.9.0, GDAL 3.2.1, PROJ 7.2.1

# https://www.rdocumentation.org/packages/tidyverse/versions/1.3.1
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
library(tidyverse) # caricherà i pacchetti di riordino principali:
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

# presence-only data
awt_sf <- st_as_sf(disPo("AWT"), coords = c("x", "y"), crs = 28355)

# a function to calculate the min distance (excluding self-distance)

mindist <- function(x) {
  mindis <- vector(mode = "numeric", length = nrow(x))
  for(i in 1:nrow(x)){
    mindis[i] <- min(x[i, -i])
  }
  return(mindis)
}

awt_min_dist <- awt_sf %>% 
  group_by(spid) %>% 
  nest() %>% 
  mutate(distM = map(data, ~st_distance(x = .)),
         minDist = map(distM, ~mindist(x = .)),
         meanDist = map_dbl(minDist, ~mean(x = .)))

# The code produces a “tibble”. You could, for instance, summarise the meanDist column: summary(awt_min_dist$meanDist).
meanDist
# Errore: oggetto "meanDist" non trovato
summary(awt_min_dist$meanDist)

# Mapping species data
# This code shows how to map the species presence-only and the evaluation presence-absence data. For doing this we use tmap and mapview packages.
# Plotting static map
# We use tmap package to plot species data on one of the polygon borders.

library(disdat)
library(sf)

# https://www.rdocumentation.org/packages/tmap/versions/3.3-1/topics/tmap-package
install.packages("tmap") # visualizzazione mappa tematica, assomiglia alla sintassi di ggplot2
library(tmap)

install.packages("grid")
library(grid)

r <- disBorder("NSW") # a polygon file showing border of the region
podata <- disPo("NSW") # presence-only data
padata <- disPa("NSW", "db") # presence-absence of group db for species 'nsw14'

# select the species to plot
species <- "nsw14"
# convert the data.frame to sf objects for plotting
po <- st_as_sf(podata[podata$spid == species, ], coords = c("x", "y"), crs = 4326) # subset the species
pa <- st_as_sf(padata, coords = c("x", "y"), crs = 4326)

# create map showing training data

train_sample <- tm_shape(r) + # create tmap object
  tm_polygons() + # add the border
  tm_shape(po) + # create tmap object for the points to overlay
  tm_dots(size = 0.2, col = "blue", alpha = 0.6, legend.show = FALSE) + # add the points
  tm_compass(type = "8star", position = c("left", "top")) + # add north arrow
  tm_layout(main.title = "Training data", main.title.position = "center") + # manage the layout
  tm_grid(lwd = 0.2, labels.inside.frame = FALSE, alpha = 0.4, projection = 4326, # add the grid
          labels.format = list(big.mark = ",", fun = function(x){paste0(x, "º")})) # add degree symbol

# create map showing testing data
pa[,species] <- as.factor(padata[,species])
test_sample <- tm_shape(r) +
  tm_polygons() +
  tm_shape(pa) +
  tm_dots(species, size = 0.2, palette = c("red", "blue"), title = "Occurrence", alpha = 0.6) +
  tm_layout(main.title = "Testing data", main.title.position = "center") +
  tm_grid(lwd = 0.2, labels.inside.frame = FALSE, alpha = 0.4, projection = 4326,
          labels.format = list(big.mark = ",", fun = function(x){paste0(x, "º")}))

# create a layout for putting the maps side-by-side
grid.newpage()
pushViewport(viewport(layout=grid.layout(1,2)))
print(train_sample, vp=viewport(layout.pos.col = 1))
print(test_sample, vp=viewport(layout.pos.col = 2))


disMapBook
# function (region, output_pdf, verbose = TRUE) 
# {
 #   regions <- unique(toupper(unlist(region)))
 #   if (regions[1] == "ALL") {
     #   regions <- c("AWT", "CAN", "NSW", "NZ", 
     #       "SA", "SWI")
#    }
  #  regions <- lapply(regions, .checkRegion)
  #  oldpar <- graphics::par(no.readonly = TRUE)
#    on.exit(graphics::par(oldpar))
#    grDevices::pdf(output_pdf, width = 8.5, height = 10)
 #   for (r in regions) {
     #   poly <- disBorder(r)
    #    presences <- disPo(r)
  #      species <- unique(presences$spid)
    #    if (verbose) {
     #       cat(paste(toupper(r), "has", length(species), 
      #          "species\n"))
     #   }
    #    i <- 0
    #    graphics::par(mfrow = c(2, 2))
      #  for (s in species) {
       #     if (r %in% c("AWT", "NSW")) {
          #      grp <- presences[presences$spid == s, "group"][1]
       #         evaluation <- disPa(r, grp)
        #    }
        #    else {
        #        evaluation <- disPa(r)
       #     }
     #       i <- i + 1
       #     npres <- nrow(presences[presences$spid == s, ])
        #    plot(sf::st_geometry(poly))
       #     graphics::points(presences[presences$spid == s, c("x", 
      #          "y")], pch = 16, col = grDevices::rgb(0, 
    #            0, 255, maxColorValue = 255, alpha = 125))
       #     graphics::mtext(sprintf("Species: %s\nPresences: %s", 
       #         s, npres))
        #    pres <- which(evaluation[, s] == 1)
        #    abse <- which(evaluation[, s] == 0)
        #    plot(sf::st_geometry(poly))
        #    graphics::points(evaluation[abse, c("x", "y")], 
       #         pch = 16, col = grDevices::rgb(255, 0, 0, maxColorValue = 255, 
                  alpha = 50))
          #  graphics::points(evaluation[pres, c("x", "y")], 
           #     pch = 16, col = grDevices::rgb(0, 0, 255, maxColorValue = 255, 
            #      alpha = 50))
       #     graphics::mtext(sprintf("Species: %s\nPresences: %s Absences: %s", 
         #       s, length(pres), length(abse)))
       #     if (verbose) 
        #        cat(i, " ")
      #  }
     #   if (verbose) 
     #       cat("\n")
 #   }
#    grDevices::dev.off()
# }
# <bytecode: 0x00000000350a1750>
# <environment: namesp

# Plotting interactive map
sf
# Errore: oggetto "sf" non trovato

mapview 
# standardGeneric for "mapview" defined from package "mapview"

#function (...) 
#standardGeneric("mapview")
# <bytecode: 0x00000000352c6f38>
# <environment: 0x00000000352cf088>
#Methods may be defined for arguments: ...
#Use  showMethods("mapview")  for currently available ones.

install.packages("mapview")
library(mapview)
# GDAL version >= 3.1.0 | setting mapviewOptions(fgb = TRUE)
# Warning message: package ‘mapview’ was built under R version 4.0.5 

library(sf)

# get presence-absence data
padata <- disPa(region = "NSW", group = "db") 
# use disCRS for each region for its crs code (EPSG)
disCRS("NSW", format = "EPSG")
# [1] "EPSG:4326"
# convert the data.frame to sf objects for plotting
pa <- st_as_sf(padata, coords = c("x", "y"), crs = disCRS("NSW"))
# select a species to plot
species <- "nsw14"

# plot presence-absence data
# you can add: map.types = "Esri.WorldImagery"
mapview(pa, zcol = species)
# file:///C:/Users/User/AppData/Local/Temp/RtmpcR72OE/viewhtml36e8c7749f7/index.html  # non si vede mappa
#https://cran.r-project.org/web/packages/disdat/vignettes/data_vis.html







