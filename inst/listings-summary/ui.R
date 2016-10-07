#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

header <-  dashboardHeader(title = "ESA Listing Quickfacts")
sidebar <-  dashboardSidebar(
    sidebarMenu(id = "sidebarmenu",
      menuItem("Listings", tabName = "listings", icon = icon("stats")), 
      conditionalPanel("input.sidebarmenu ==='listings'",
                       selectInput("tx_select", "Choose a Taxon", 
                           choices = setNames(as.list(c("",unique(regions$Group))),c("All",unique(regions$Group))), 
                           selected = "", multiple = FALSE)),
      menuItem("Area", tabName = "area", icon = icon("globe")),
      menuItem("Recovery", tabName = "recover")
    )
  )
body <- dashboardBody(  
  tabItems(
   tabItem(tabName = "listings",
    fluidRow(
     valueBox(num_es, "Endangered Species", color = "red", width = 3),
     valueBox(num_th, "Threatened Species", color = "orange", width = 3),
     valueBox(num_pr, "Proposed for Listing", color = "green", width = 3),
     valueBox(num_cn, "Candidate Species", color = "yellow", width = 3)
    ),
    fluidRow(
     h2("Summary of Listings"),
     tabsetPanel(id = "panel1",
      tabPanel("Taxa",
       box(highchartOutput("specbars")), 
       box(highchartOutput("spectree"))
      ),
      tabPanel("Region",
       box(highchartOutput("regbars")), 
       box(highchartOutput("regtree"))
      )#,
#      tabPanel("Timeline",
#       box(highchartOutput("time"))
      )
     )
    ),
  
  tabItem(tabName = "area",
#  shinyjs::useShinyjs(),
    fluidRow(
      h2("Listing Areas"),
      tabsetPanel(id = "panel2",
        tabPanel("MAP",
          box(leafletOutput("map", height = 800), width = 9, height = 800
          ),
          box(DT::dataTableOutput("specTble"), width = 3, height = 800
          )
        ),
  
      tabPanel("GRAPH",
        fluidRow(
         column(8, box(highchartOutput("sp_cumm"), width = NULL, height = 400),
               box(highchartOutput("cn_cumm"), width = NULL, height = 400)
         ),
         column(4, br()))
      )
     )
    )
  )
)
)
dashboardPage(header, sidebar, body)

