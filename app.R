library(maptools)
library(esacounties)
library(rgdal)
library(geojsonio)
library(highcharter)
library(dplyr)

data(uscountygeojson)
data(esacounties)

#county_map <- readShapeSpatial("C:/Users/mevans/GIS/cb_2015_us_county_500k.shp")
county_map <- uscountygeojson

species <- dplyr::group_by(esacounties, Scientific)%>%
  summarise(count = n())%>%
  arrange(count)
sum_species <- dplyr::group_by(species, count)%>%
  summarise(cumm = n())%>%
  arrange(count)

counties<-group_by(esacounties, GEOID)%>%
  summarise(count = n())

counties$species <- sapply(counties$GEOID, function(x,y) y$Scientific[y$GEOID == x], y = esacounties)

county_map@data <- left_join(county_map@data, counties, by = "GEOID")

#county map showing # of species

highchart()%>%
  hc_add_series_map(county_map, counties, value = "count", joinBy = c("fips","GEOID"))%>%
  hc_colorAxis(min = 0, max = 75, minColor = "#efecf3", maxColor = "#990041")%>%
  hc_legend(title = list(text = "Number of Listed Species", align = "right"))

highchart()%>%
  hc_add_series_map(county_map, get_counties("Canis lupus"), value = "Scientific", joinBy = c("fips","GEOID"))
  
#
hchart(species, type = "line", x = row_number(count), y = count)%>%
  hc_yAxis(title = list(text = "Log Number of Counties"),
           type = "logarithmic")%>%
  hc_tooltip(pointFormat = "# of Counties: {point.count}<br>% Species: {point.x/sum(count)}")
  