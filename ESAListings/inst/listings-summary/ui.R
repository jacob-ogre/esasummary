#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

header <-  dashboardHeader(title = "ESA Listing Quickfacts",
                           tags$li(class = "dropdown", p(tags$b("Defenders of Wildlife"), br(), tags$b("Endangered Species Program"))),
                           tags$li(class = "dropdown", img(height = "50px", src = "01_DOW_LOGO_COLOR_300-01.png"))                           )
sidebar <-  dashboardSidebar(
    sidebarMenu(id = "sidebarmenu",
      menuItem(h4("Listings"), tabName = "listings", icon = icon("bar-chart")),
      conditionalPanel("input.sidebarmenu ==='listings'& input.panel1 != 'Timeline'",
                       selectInput("tx_select", "Choose a Taxon",
                           choices = setNames(as.list(c("",unique(regions$Group))),c("All",unique(regions$Group))),
                           selected = "", multiple = FALSE)),
      menuItem(h4("Geography"), tabName = "area", icon = icon("globe"))
#      conditionalPanel("input.sidebarmenu === 'area' & input.panel2 === 'U.S. Map'"),
#      conditionalPanel("input.sidebarmenu === 'area' & input.panel2 === 'Range Sizes'"),
#      menuItem("Recovery", tabName = "recover")
    )
  )
body <- dashboardBody(
  tabItems(
   tabItem(tabName = "listings", h2("Summary of Listings"),
    fluidRow(
     valueBox(num_es, "Endangered Species", color = "red", width = 3),
     valueBox(num_th, "Threatened Species", color = "orange", width = 3),
     valueBox(num_pr, "Proposed for Listing", color = "green", width = 3),
     valueBox(num_cn, "Candidate Species", color = "yellow", width = 3)
    ),
    fluidRow(
     tabsetPanel(id = "panel1",
      tabPanel("Timeline",
       fluidRow(
        column(9,
          box(plotlyOutput("time"), width = NULL, height = 450)
        ),
        column(3,
          h2("Timeline of Listings"),
          h4("This chart tracks the number of species listings over time.
              Click on a line to see the species listed in a given year.",br(), br()),
          DT::dataTableOutput("timeTbl"))
       )
      ),
      tabPanel("Taxa",
       fluidRow(column(1, br()),
        column(10,
        h3("Listings by Taxonomic Group", align = "center"),
        h4("The bar chart below breaks down the number of listed species by taxa,
        and listing status.", br(), "The treemap at right organizes this information hierarchicaly,
        with box sizes corresponding to the number of listed species. The treemap can be used to
        visualize the breakdown of taxa within specific Regions.  Chose a Region using the sidebar selector.
        To see the number of listed species in a given category by mousing over the boxes.
        Finally, click on a Taxa to zoom in for detailed information on listings per category.")),
        column(1, br())
       ),
       fluidRow(
       box(highchartOutput("specbars")),
       box(highchartOutput("regtree"))
       )
      ),
      tabPanel("Regions",
       fluidRow(column(1, br()),
        column(10,
         h3("Listings by Region", align = "center"),
         h4("The bar chart below breaks down the number of listed species by FWS Region,
            and listing status.", br(), "The treemap at right organizes this information hierarchicaly,
            with box sizes corresponding to number of listed species. The treemap can be used to
            visualize how listings for specific taxa are distributed among regions.  Choose a Taxon using the sidebar selector.
            You can see the number of listed species in a given category by mousing over the boxes.
            Finally, click on a Region to zoom in for detailed information on listings per category.")),
        column(1, br())
       ),
       fluidRow(
       box(highchartOutput("regbars")),
       box(highchartOutput("spectree"))
       )
      )
     )
    )
    ),

  tabItem(tabName = "area",
#  shinyjs::useShinyjs(),
    fluidRow(

      tabsetPanel(id = "panel2",
        tabPanel("U.S. Map",
          fluidRow(
            column(9, box(leafletOutput("map", height = 800), width = NULL, height = 800)
            ),
            column(3,
          h2("Geography of Listings"),
          h4("This map shows the number of listed species in each
             U.S. county.  It can be used to identify 'hot spots' -
             areas with a high concentration of listed species - such as
             southern California.  To see all the species listed in a county,
             click near the center of the county."),
          DT::dataTableOutput("specTble")
            )
          )
        ),

      tabPanel("Range Sizes",
        fluidRow(
         column(8, box(plotlyOutput("sp_cumm"), width = NULL, height = 450),
               box(plotlyOutput("cn_cumm"), width = NULL, height = 450)
         ),
         column(4, h2("Distributions of Listed Species"),
                   h4("The majority of listed species occupy limited ranges.
                  The upper graph illustrates the distribution of listed
                  species' range sizes, in terms of the number of
                  U.S. counties in which they occur.  Clicking on this graph
                  will display a table of species with the selected range size.", br(), br(),
                  "Similarly, most counties have few listed species, although
                  this distribution is less skewed than the sizes
                  of species' ranges.  In 75% of U.S. counties, there are
                  8 or fewer listed species."),
                DT::dataTableOutput("rngTble"))
        )
      )
     )
    )
   )
  )
)
dashboardPage(header, sidebar, body)

