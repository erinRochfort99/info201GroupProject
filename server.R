library("shiny")
library("dplyr")
library("ggplot2")

events <- read.csv("./data/athlete_events.csv")

my_server <- function(input, output)({
  output$medalChoice <- renderUI({
    checkboxGroupInput("medal", "Choose what medals to display", distinct(events, Medal)$Medal)
  })
  
 # output$scatter <- renderPlot{
    
 # }
  
  output$pract <- renderText({
    paste("practice")
  })
  
  
})



shinyServer(my_server)
