library(shiny)

data <- read.csv("./data/athlete_events.csv", stringsAsFactors = FALSE)
source("map_data.R")

ui <- shinyUI(fluidPage(
  titlePanel("Medal Counts"),
  
  sidebarLayout(
    position = "left",
    sidebarPanel(
      radioButtons(
        "medal_input", 
        label = h3("Choose which medal type you'd like to see"), 
        choices = list("Gold" = "Gold", 
                       "Silver" = "Silver", 
                       "Bronze" = "Bronze")),
      
      helpText("Note: 2 countries are not represented in this map,
               Kosovo (a partially recognized state, and 
               Individual Olympic Athletes. There are 6 medals
               between them: 2 gold, 1 silver and 3 bronze."),
      
      selectInput(
        "country_input",
        label = h3("Country"),
        choices = final_counts$name.y
      ),
      
      tableOutput("country_output")
    ),
    
    mainPanel(
      plotlyOutput("plot")
    )
  )
))