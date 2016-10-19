#create 'counties' dataset
counties<-group_by(esacounties, GEOID)%>%
  summarise(count = n())

counties$Species <- sapply(counties$GEOID, function(x,y) y$Scientific[y$GEOID == x], y = esacounties)

counties <- dplyr::left_join(counties, select(county_attrib, GEOID, INTPTLAT, INTPTLON, County_name),by = "GEOID")

counties <- left_join(counties, select(county_attrib, GEOID, NAME), by = "GEOID")

#create species dataset
species <- dplyr::group_by(esacounties, Scientific)%>%
  summarise(count = n())%>%
  arrange(count)

#create regions dataset
regions <- group_by(TECP_domestic, Lead_Region, Species_Group, Federal_Listing_Status)

regions$Group <- sapply(regions$Species_Group, function(x) 
  if(x == "Ferns and Allies"|x == "Flowering Plants"|x == "Conifers and Cycads"|x == "Lichens"){
    "Plants and Lichens"} 
  else if(x == "Snails"|x=="Clams"){
    "Molluscs"}else{x})

regions$Status <- sapply(regions$Federal_Listing_Status, function(x) 
  if(x == "Proposed Endangered"|x == "Proposed Threatened"){
    "Proposed"} 
  else{x})

regions <- group_by(regions, Lead_Region, Group, Status)%>%
  summarise(count=n())

regions <- as.data.frame(regions)
regions$Lead_Region[regions$Lead_Region != "NMFS"] <- paste("Region", regions$Lead_Region[regions$Lead_Region != "NMFS"])

years <- mutate(TECP_date,Year = substr(First_Listed,9,12))%>%
  select(Year, Federal_Listing_Status)

years$Status <- sapply(years$Federal_Listing_Status, function(x) 
  if(x == "Proposed Endangered"|x == "Proposed Threatened"){
    "Proposed"} 
  else{x})

years <- group_by(years, Year,Status)%>%
  summarise(count = n())%>%
#  tidyr::spread(Status,count)

years$Year <- as.integer(years$Year)

impute <- data.frame(Year = rep(seq(min(years$Year,na.rm=TRUE),
                          max(years$Year,na.rm=TRUE),1),6), 
           Status = rep(unique(years$Status),
                        each = max(years$Year, na.rm =TRUE) - 1966))

years <- right_join(years, impute, by = c("Year", "Status"))
years$count[is.na(years$count)] <- 0

totals <- summarise(group_by(years, Year), total = sum(count))