#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

server_area_page <- function(input, output, session) {
  
  #county map showing # of species per county 
  output$map <- renderLeaflet({
      leaflet()%>%
      addTopoJSON(topo_prac, weight = 0.5, color = "black", fillOpacity = 0.5)%>%
      addProviderTiles("Stamen.TonerLite")%>%
      setView(lng=-95, lat=38, zoom = 4) %>%
      mapOptions(zoomToLimits = "never")%>%
      addLegend(title = "Number of<br>Listed Species",
                position = "bottomleft", 
                pal = palfx, 
                values = seq(0, 80, 10))%>%
      addCircleMarkers(data = counties,
                      lng = ~INTPTLON,
                      lat = ~INTPTLAT,
                      radius = 5, 
                      color = "black",
                      fillOpacity = 0,
                      stroke = FALSE,
                      popup = ~paste0(NAME," County<br>", count, " species<br>")
                      )
  })
  
  observe({
    if(!is.null(input$specTble_cell_clicked$value)) {
      #print(input$specTble_cell_clicked$value)
    spec_select <- filter(esacounties, 
                          Scientific == input$specTble_cell_clicked$value)%>%
                   select(GEOID)
    # print(spec_select$GEOID)
    leafletProxy("map")%>%
    clearShapes()%>%
    addCircles(data = filter(counties,GEOID %in% spec_select$GEOID),
                   lng = ~INTPTLON,
                   lat = ~INTPTLAT,
                   radius = 1000, 
                   color = "black",
                   fillOpacity = 1,
                   stroke = FALSE
    )
    }
  })
  
  observeEvent(input$map_marker_click,{
    click_lat <- input$map_marker_click[[3]]
    click_lon <- input$map_marker_click[[4]]
    gid <- counties$GEOID[counties$INTPTLAT == click_lat & counties$INTPTLON == click_lon]
    output$specTble <- DT::renderDataTable({
      filter(esacounties, GEOID == gid)%>%
      select(Scientific, Common)%>%
      datatable(rownames = FALSE, selection = "single")
      })
  })
  
  output$sp_cumm <- renderHighchart({
    #cummulative number of counties per species
    hchart(species, type = "line", x = round(row_number(count)/nrow(species), 3), y = count)%>%
      hc_title(text = "Range Sizes of Listed Species", align = "center")%>%
      hc_yAxis(title = list(text = "<b>Counties in Species Range<b>", style = list(color = "black")),
               type = "logarithmic",
               labels = list(style = list(color = "black")))%>%
      hc_xAxis(title = list(text = "<b>Percentage of Listed Species<\b>", style = list(color = "black")),
               max = 1, min = 0, tickColor = "black",
               labels = list(style = list(color = "black")))%>%
      hc_tooltip(headerFormat = "% of Species: {point.x}<br>",
                 pointFormat = "Counties in Range: {point.y}")
  })
  
  output$cn_cumm <- renderHighchart({
    #cummulative number of counties per species
    hchart(arrange(counties,count), type = "line", x = round(row_number(count)/nrow(counties), 3), y = count)%>%
      hc_title(text = "Listed Species per County", align = "center")%>%
      hc_yAxis(title = list(text = "<b>Listed Species in County<b>", style = list(color = "black")),
               type = "logarithmic", min = 1,
               labels = list(style = list(color = "black")))%>%
      hc_xAxis(title = list(text = "<b>Percentage of Counties<\b>", style = list(color = "black")),
               max = 1, min = 0, tickColor = "black",
               labels = list(style = list(color = "black")))%>%
      hc_tooltip(headerFormat = "% of Counties: {point.x}<br>",
                 pointFormat = "Species in County: {point.y}")
  })
}
