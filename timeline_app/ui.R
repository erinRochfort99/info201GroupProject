
library(shiny)
library(vistime)
library(dplyr)
library(plotly)

olympics_df <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)
source("data/timeline.R")
timeline_data <- get_timeline_data(olympics_df)

shinyUI(fluidPage(
  
  titlePanel("Olympics Data"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("season", "Season:", 
                         c(unique(timeline_data$Season)),
                         selected = c("Summer", "Winter")),
      selectInput(
        "nation", "Nation/Group:",
        c(timeline_data$region),
        selected = "nation"),
      tableOutput(
        "nationData"
      )
    ),

    mainPanel(
       plotlyOutput("timelinePlot")
    )
  )
))
