
server_listing_page <- function(input, output, session) {

observe({
  if(input$panel1=="Region"){
    updateSelectInput(session, "tx_select", "Choose a Region", 
                      choices = setNames(as.list(c("",unique(regions$Lead_Region))),c("All",unique(regions$Lead_Region))),
                      selected = "")
  }else if(input$panel1=="Taxa"){
    updateSelectInput(session, "tx_select", "Choose a taxon", 
                      choices = setNames(as.list(c("",unique(regions$Group))),c("All",unique(regions$Group))), 
                      selected = "")
  }
})
  
#create treemaps displaying hierarchy of listings by taxa, group, region
observeEvent(input$tx_select, {
  dat1 <- isolate({filter(regions, grepl(input$tx_select, Group))})
  #spec_pal <- names(list_pal[list_pal%in%dat1$Status])
  dat2 <- isolate({filter(regions, grepl(input$tx_select, Lead_Region))})
  #reg_pal <- names(list_pal[list_pal%in%dat2$Status])

if(input$panel1=="Taxa"){  
  tm_tx <- treemap(dat1,
    index = c("Lead_Region", "Status"),
    vSize = "count", type = "categorical", vColor = "Status",
    fontsize.labels = c(16, 0),
    align.labels = list(c("left","top"), c("center","center")),
    bg.labels = 0, palette = list_pal)
  tm_tx$tm$color[tm_tx$tm$level == 1] <- NA
}

if(input$panel1=="Region"){
tm_rg <- treemap(dat2,
          index = c("Group", "Status"),
          vSize = "count", type = "categorical", vColor = "Status",
          fontsize.labels = c(16, 0),
          align.labels = list(c("left","top"), c("center","center")),
          bg.labels = 0, palette = list_pal)
  tm_rg$tm$color[tm_rg$tm$level == 1] <- NA
}

output$spectree <- renderHighchart({  
 highchart()%>%
    hc_add_series_treemap(tm_tx, allowDrillToNode = TRUE, layoutAlgorithm = "squarified",
                          levels = list(list(level = 1, 
                                             borderColor = "black", 
                                             borderWidth = 5,
                                             dataLabels = list(enabled = "true",
                                                               align = "left",
                                                               verticalAlign = "top")),
                                        list(level = 2,
                                             borderColor = "grey", 
                                             borderWidth = 3,
                                             dataLabels = list(enabled = "true",
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
                                             borderColor = "black", 
                                             borderWidth = 5,
                                             dataLabels = list(enabled = "true",
                                                               align = "left",
                                                               verticalAlign = "top")),
                                        list(level = 2,
                                             borderColor = "grey", 
                                             borderWidth = 3,
                                             dataLabels = list(enabled = "true",
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
  hc_yAxis(title = list(text = "Number of Listed Species"),
        stackLabels = list(enabled = "true"))%>%
  hc_xAxis(categories = c("Reg. 1", "Reg. 2", "Reg.3", "Reg. 4", "Reg. 5", "Reg. 6", "Reg. 7", "Reg. 8", "NMFS"))%>%
  hc_plotOptions(column = list(stacking = "normal"))%>%
  hc_tooltip(headerFormat = "<b>{point.x}</b><br>", pointFormat = "{series.name}: {point.y}<br>Total: {point.stackTotal}")%>%
  hc_colors(c("yellow","red","black","green","purple","orange"))
})

output$specbars <- renderHighchart({
  hchart(summarise(group_by(regions, Group, Status), n = sum(count)), 
         type = "column", x = Group, y = n, group = Status)%>%
    hc_yAxis(title = list(text = "Number of Listed Species"),
             stackLabels = list(enabled = "true"))%>%
    hc_xAxis(title = list(text = "Taxanomic Group"))%>%
    hc_plotOptions(column = list(stacking = "normal"))%>%
    hc_tooltip(headerFormat = "<b>{point.x}</b><br>", pointFormat = "{series.name}: {point.y}<br>Total: {point.stackTotal}")%>%
    hc_colors(c("yellow","red","black","green","purple","orange"))
  })
}