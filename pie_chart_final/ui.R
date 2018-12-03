library(shiny)
library(ggplot2)
library(dplyr)
original_data <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)
distinct_game <- distinct(original_data, Games)
distinct_game_order <- arrange(distinct_game, Games)
medal_type <- c("Gold", "Bronze", "Silver")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Medal Winners' Sex Distribution"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("game",
                   "Choose a specific game",
                   choices = distinct_game_order),
       checkboxGroupInput("medal", "Choose types of medal",
                          choices = medal_type, selected = medal_type)
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot", width = 600, height = 600)
    )
  )
))
