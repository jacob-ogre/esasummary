library(shiny)

source("server_area_page.R")
source("server_listing_page.R")


shinyServer(function(input,output, session){
  server_area_page(input, output, session)
  server_listing_page(input, output, session)
  
})