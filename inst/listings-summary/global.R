library(dplyr)
library(DT)
library(esacounties)
library(geojsonio)
library(highcharter)
library(leaflet)
library(maptools)
library(rgdal)
library(treemap)
library(shinydashboard)
library(shinyjs)
library(viridis)

num_es <- nrow(filter(TECP_domestic, Federal_Listing_Status == "Endangered"))
num_th <- nrow(filter(TECP_domestic, Federal_Listing_Status == "Threatened"))
num_pr <- nrow(filter(TECP_domestic, startsWith(Federal_Listing_Status, "Proposed")))
num_cn <- nrow(filter(TECP_domestic, Federal_Listing_Status == "Candidate"))



#species_ls <- unique(esacounties$Scientific)
#names(species_ls) <- unique(esacounties$Common)

#county_attrib <- read.csv("US_counties_attrib.csv")
#county_attrib$GEOID <- as.character(county_attrib$GEOID)
#county_attrib$GEOID <- ifelse(nchar(county_attrib$GEOID) == 4,
#                              paste0("0", county_attrib$GEOID),
#                              county_attrib$GEOID)

#county_map <- readLines("C:/Users/mevans/repos/ESA_expenditures/data/US_counties_TIGERd_topo.topojson")%>%
#  paste(collapse="\n")

#county_map <- readShapeSpatial("C:/Users/mevans/GIS/cb_2015_us_county_500k.shp")
#county_map <- uscountygeojson



#sum_species <- dplyr::group_by(species, count)%>%
#  summarise(cumm = n())%>%
#  arrange(count)




#county_map@data <- left_join(county_map@data, counties, by = "GEOID")

list_pal <- c("yellow","red","black","green","purple","orange")

