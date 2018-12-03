
library(shiny)
library(vistime)
library(dplyr)
library(plotly)

olympics_df <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)
#source("data/timeline.R")

shinyServer(function(input, output) {
  timeline_data <- get_timeline_data(olympics_df)

  filteredData <- reactive({
    timeline_data[timeline_data$Season %in% input$season, ]
  })
  
  
  output$timelinePlot <- renderPlotly({
    
    vistime(filteredData(), start = "Date", end = "Date", events = "NOC", groups = "Season",
            title = "Years That Specific Countries First Entered the Olympics",
            tooltips = "region_games", showLabels = FALSE)
  })
  
  output$nationData <- renderText(
    paste0(input$nation, " first entered the Olympics for the ",
           timeline_data[which(timeline_data$region == input$nation), ]$Games[1], " Olympic Games.")
    )
})
