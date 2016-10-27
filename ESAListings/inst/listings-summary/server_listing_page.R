
server_listing_page <- function(input, output, session) {

#create treemaps displaying hierarchy of listings by taxa, group, region
observeEvent(input$tx_select, {
  dat1 <- isolate({filter(regions, grepl(input$tx_select, Group))%>%
                    group_by(Lead_Region, Status)%>%
                    summarize(count = sum(count))})
  tm_tx <- list()
  for(i in unique(dat1$Lead_Region)){
    ls1 <- list(name = i, id = i, value = sum(dat1$count[dat1$Lead_Region == i]), color = NA)
    tm_tx[[length(tm_tx)+1]] <- ls1
  }
  for(i in 1:length(dat1$count)){
    ls2 <- list(parent = dat1$Lead_Region[i], name = dat1$Status[i], value = dat1$count[i], color = stat_pal(strsplit(dat1$Status[i]," ")[[1]][1]))
    tm_tx[[length(tm_tx)+1]] <- ls2
  }

  output$regtree <- renderHighchart({
    highchart()%>%
      hc_add_series(data = tm_tx, type = "treemap", allowDrillToNode = TRUE, layoutAlgorithm = "squarified",
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
      #hc_title(text = paste("ESA Listings", input$tx_select))%>%
      hc_tooltip(pointFormat = "<b>{point.name}<\b><br>
                              Listings: {point.value}")
  })

  output$regbars <- renderHighchart({
    hchart(left_join(rg_combos, dat1),
           type = "column", x = Lead_Region, y = count, group = Status)%>%
      #  hc_title(text = "ESA Listings by FWS Region")%>%
      hc_yAxis(title = list(text = "Number of Listed Species", style = list(color = "black")),
               labels = list(style = list(color = "black")),
               stackLabels = list(enabled = "true"))%>%
      hc_xAxis(categories = c("Reg. 1", "Reg. 2", "Reg.3", "Reg. 4", "Reg. 5", "Reg. 6", "Reg. 7", "Reg. 8", "NMFS"),
               title = list(text = NULL),
               labels = list(style = list(color = "black")))%>%
      hc_plotOptions(series = list(stacking = "normal"))%>%
      hc_tooltip(headerFormat = "<b>{point.x}</b><br>", pointFormat = "{series.name}: {point.y}<br>Total: {point.stackTotal}")%>%
      hc_colors(list_pal[c(2,1,3,4)])
  })
})


observeEvent(input$rg_select, {
  dat2 <- isolate({filter(regions, grepl(input$rg_select, Lead_Region))%>%
                    group_by(Group, Status)%>%
                    summarize(count = sum(count))})

  tm_rg <- list()
  for(i in unique(dat2$Group)){
    ls1 <- list(name = i, id = i, value = sum(dat2$count[dat2$Group == i]), color = NA)
    tm_rg[[length(tm_rg)+1]] <- ls1
  }
  for(i in 1:length(dat2$count)){
    ls2 <- list(parent = dat2$Group[i], name = dat2$Status[i], value = dat2$count[i], color = stat_pal(strsplit(dat2$Status[i]," ")[[1]][1]))
    tm_rg[[length(tm_rg)+1]] <- ls2
  }

output$spectree <- renderHighchart({
  highchart()%>%
    hc_add_series(data = tm_rg, type = "treemap", allowDrillToNode = TRUE, layoutAlgorithm = "squarified",
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
    #hc_title(text = paste("ESA Listings", input$rg_select))%>%
    hc_tooltip(pointFormat = "<b>{point.name}<\b><br>
               Listings: {point.value}")
})

#if(input$plants){hc <- hchart(left_join(tx_combos, dat2[dat2$Group!= "Plants and Lichens", ]),
                              #type = "column", x = Group, y = count, group = Status)}

output$specbars <- renderHighchart({
  hchart(left_join(tx_combos[tx_combos$Group!= input$plants, ], dat2),
         type = "column", x = Group, y = count, group = Status)%>%
    #    hc_title(text = "ESA Listings by Taxonomic Group")%>%
    hc_yAxis(title = list(text = "Number of Listed Species", style = list(color = "black")),
             labels = list(style = list(color = "black")),
             stackLabels = list(enabled = "true"))%>%
    hc_xAxis(
             title = list(text = NULL),
             labels = list(style = list(color = "black")))%>%
    hc_plotOptions(column = list(stacking = "normal"))%>%
    hc_tooltip(headerFormat = "<b>{point.x}</b><br>", pointFormat = "{series.name}: {point.y}<br>Total: {point.stackTotal}")%>%
    hc_colors(list_pal[c(2,1,3,4)])
})
})


output$time <- renderPlotly({
  plot_ly(ungroup(years), x = ~Year, y = ~count)%>%
    add_trace(type = "scatter", mode = "lines", color = ~Status, colors = list_pal, text = ~paste(count,"species listed as<br>", Status, "in", Year, sep=" "), hoverinfo = "text")%>%
    add_trace(data = totals, x = ~Year, y = ~total, text = ~paste(total,"Total species listed in", Year, sep = " "), hoverinfo = "text",
              type = "scatter", mode = "lines", name = "Total", line = list(color = "grey"))%>%
    add_trace(data = totals, x = ~Year, y = ~cumm, text = ~paste(cumm, "species listed as of", Year, sep = " "), hoverinfo = "text",
              type = "scatter", mode = "lines", name = "Cumulative<br>(click to show)", visible = "legendonly")%>%
    layout(hovermode = "closest", font = list(color = "black"),
           xaxis = list(title = "Year"),
         yaxis = list(title = "Number of Listings"),
           legend = list(x = 0.05, y = 0.95, bordercolor = "black", borderwidth = 1))
})

observeEvent(event_data("plotly_click"),{
  st <- switch(event_data("plotly_click")$curveNumber[[1]]+1,
               "Endangered","Threatened","","")
  yr <- event_data("plotly_click")$x[[1]]

  output$timeTbl <- DT::renderDataTable({
    filter(TECP_date, grepl(yr, First_Listed), grepl(st, Federal_Listing_Status))%>%
    select(Scientific_Name, Common_Name)%>%
    datatable(rownames = FALSE, selection = "single", colnames = c("Species", "Common Name"))
  })
})

}
