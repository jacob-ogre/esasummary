county_map <- readShapeSpatial("C:/Users/mevans/GIS/cb_2015_us_county_500k.shp")
  
  #join species counts by county table to dataframe of shapefile
county_map@data <- left_join(county_map@data, counties, by = "GEOID")

palfx <- colorNumeric(palette = c("midnightblue","yellow"), domain = c(0,75), na.color = "yellow")
county_map@data$style<-pal(county_map@data$count)

test_geo <- geojson_json(county_map)
test_geo <- geojson_read("county_geo.json")

#read topoJSON in list format
test_topo <- jsonlite::fromJSON(readLines("county_topo3.json")%>%paste(collapse="\n"))

#read topoJSON in character vector format
test_topo <- readLines("county_topo_rb76.json")%>%paste(collapse="\n")

test_geo$features <- lapply(test_geo$features, function(x) {
  x$properties$style <- list(fillColor = palfx(x$properties$count))
  x})

geojson_out <- jsonlite::toJSON(test_geo,pretty = TRUE)
write(geojson_out,file="county_geo2.json")


#change color scales by 'count' value in topoJson
for(i in 1:300){
  topo_prac <- str_replace_all(topo_prac,
                  sprintf("\"count\":\\[%s\\],\"style\":\\{\"fillColor\":\\[\"#[:alnum:]*",i),
                  sprintf("\"count\":\\[%s\\],\"style\":\\{\"fillColor\":\\[\"%s",i,palfx(i)))
}

cur_map <- leaflet()%>%
    addTopoJSON(topo_prac, weight = 0.75, color = "black", fillOpacity = 0.5)%>%
    addProviderTiles("Stamen.TonerLite")%>%
    setView(lng=-95, lat=38, zoom = 4) %>%
    mapOptions(zoomToLimits = "never")%>%
  addLegend(title = "Number of<br>Listed Species",
            position = "bottomleft", 
            pal = palfx, 
            values = seq(0, 80, 10))