
server_listing_page <- function(input, output, session) {

observe({
  if(input$panel1=="Taxa"){
    updateSelectInput(session, "tx_select", "Choose a Region",
                      choices = setNames(as.list(c("",unique(regions$Lead_Region))),c("All",unique(regions$Lead_Region))),
                      selected = "")
  }else if(input$panel1=="Regions"){
    updateSelectInput(session, "tx_select", "Choose a Taxon",
                      choices = setNames(as.list(c("",unique(regions$Group))),c("All",unique(regions$Group))),
                      selected = "")
  }
})

#create treemaps displaying hierarchy of listings by taxa, group, region
observeEvent(input$tx_select, {
  dat1 <- isolate({filter(regions, grepl(input$tx_select, Group))%>%
                    group_by(Lead_Region, Status)%>%
                    summarize(count = sum(count))})
  dat2 <- isolate({filter(regions, grepl(input$tx_select, Lead_Region))%>%
                    group_by(Group, Status)%>%
                    summarize(count = sum(count))})

if(input$panel1=="Regions"){
  tm_tx <- treemap(dat1,
    index = c("Lead_Region", "Status"),
    vSize = "count", type = "categorical", vColor = "Status",
    fontsize.labels = c(16, 0),
    align.labels = list(c("left","top"), c("center","center")),
    bg.labels = 0, palette = list_pal[names(name_pal)%in%dat1$Status])
  tm_tx$tm$color[tm_tx$tm$level == 1] <- NA
}

if(input$panel1=="Taxa"){
tm_rg <- treemap(dat2,
          index = c("Group", "Status"),
          vSize = "count", type = "categorical", vColor = "Status",
          fontsize.labels = c(16, 0),
          align.labels = list(c("left","top"), c("center","center")),
          bg.labels = 0, palette = list_pal[names(name_pal)%in%dat2$Status])
  tm_rg$tm$color[tm_rg$tm$level == 1] <- NA
}

output$spectree <- renderHighchart({
 highchart()%>%
    hc_add_series_treemap(tm_tx, allowDrillToNode = TRUE, layoutAlgorithm = "squarified",
                          levels = list(list(level = 1,
                                             borderColor = "white",
                                             borderWidth = 5,
                                             dataLabels = list(enabled = "true",
                                                               align = "left",
                                                               verticalAlign = "top",
                                                               style = list(fontSize = "14px"))),
                                        list(level = 2,
                                             borderColor = "grey",
                                             borderWidth = 3,
                                             dataLabels = list(enabled = FALSE,
                                                               align = "center",
                                                               verticalAlign = "middle"))))%>%
    hc_title(text = paste("ESA Listings", input$tx_select))%>%
    hc_tooltip(pointFormat = "<b>{point.name}<\b><br>
                              Listings: {point.value}")
})

output$regtree <- renderHighchart({
  highchart()%>%
    hc_add_series_treemap(tm_rg, allowDrillToNode = TRUE, layoutAlgorithm = "squarified",
                          levels = list(list(level = 1,
                                             borderColor = "white",
                                             borderWidth = 5,
                                             dataLabels = list(enabled = "true",
                                                               align = "left",
                                                               verticalAlign = "top",
                                                               style = list(fontSize = "14px"))),
                                        list(level = 2,
                                             borderColor = "grey",
                                             borderWidth = 3,
                                             dataLabels = list(enabled = FALSE,
                                                               align = "center",
                                                               verticalAlign = "middle"))))%>%
    hc_title(text = paste("ESA Listings", input$tx_select))%>%
    hc_tooltip(pointFormat = "<b>{point.name}<\b><br>
               Listings: {point.value}")
})

})

output$regbars <- renderHighchart({
hchart(summarise(group_by(regions, Lead_Region, Status), n = sum(count)),
       type = "column", x = Lead_Region, y = n, group = Status)%>%
#  hc_title(text = "ESA Listings by FWS Region")%>%
  hc_yAxis(title = list(text = "Number of Listed Species", style = list(color = "black")),
           labels = list(style = list(color = "black")),
           stackLabels = list(enabled = "true"))%>%
  hc_xAxis(categories = c("Reg. 1", "Reg. 2", "Reg.3", "Reg. 4", "Reg. 5", "Reg. 6", "Reg. 7", "Reg. 8", "NMFS"),
           title = list(text = NULL),
           labels = list(style = list(color = "black")))%>%
  hc_plotOptions(column = list(stacking = "normal"))%>%
  hc_tooltip(headerFormat = "<b>{point.x}</b><br>", pointFormat = "{series.name}: {point.y}<br>Total: {point.stackTotal}")%>%
  hc_colors(list_pal)
})

output$specbars <- renderHighchart({
  hchart(summarise(group_by(regions, Group, Status), n = sum(count)),
         type = "column", x = Group, y = n, group = Status)%>%
#    hc_title(text = "ESA Listings by Taxonomic Group")%>%
    hc_yAxis(title = list(text = "Number of Listed Species", style = list(color = "black")),
             labels = list(style = list(color = "black")),
             stackLabels = list(enabled = "true"))%>%
    hc_xAxis(title = list(text = NULL),
             labels = list(style = list(color = "black")))%>%
    hc_plotOptions(column = list(stacking = "normal"))%>%
    hc_tooltip(headerFormat = "<b>{point.x}</b><br>", pointFormat = "{series.name}: {point.y}<br>Total: {point.stackTotal}")%>%
    hc_colors(list_pal)
  })


output$time <- renderPlotly({
  plot_ly(ungroup(years), x = ~Year, y = ~count)%>%
    add_trace(type = "scatter", mode = "lines", color = ~Status, colors = list_pal)%>%
    add_trace(data = totals, x = ~Year, y = ~total,
              type = "scatter", mode = "lines", name = "Total", line = list(color = "black"))%>%
    layout(hovermode = "closest",
           xaxis = list(title = "Year"),
           yaxis = list(title = "Number of Listings"),
           legend = list(x = 0.05, y = 0.95, bordercolor = "black", borderwidth = 1))
})

observeEvent(event_data("plotly_click"),{
  st <- switch(event_data("plotly_click")$curveNumber[[1]]+1,
               "Candidate","Endangered","Experimental","Proposed","Similarity","Threatened","")
  yr <- event_data("plotly_click")$x[[1]]

  output$timeTbl <- DT::renderDataTable({
    filter(TECP_date, grepl(yr, First_Listed), grepl(st, Federal_Listing_Status))%>%
    select(Scientific_Name, Common_Name)%>%
    datatable(rownames = FALSE, selection = "single", colnames = c("Species", "Common Name"))
  })
})

}
