
library(shiny)
library(vistime)
library(dplyr)
library(plotly)
library(mapdata)
library(data.table)
library(countrycode)

olympics_df <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)
source("data/timeline.R")
source("data/map_data.R")

timeline_data <- get_timeline_data(olympics_df)

shinyUI(fluidPage(
  
  titlePanel("Olympics Data"),
  
  tabsetPanel(
    tabPanel("Timeline", fluid = TRUE,
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("season", h3("Season:"), 
                         c(unique(timeline_data$Season)),
                         selected = c("Summer", "Winter")),
      selectInput(
        "nation", h3("Nation/Group:"),
        c(timeline_data$region),
        selected = "nation"),
      tableOutput(
        "nationData"
      )
    ),
    mainPanel(
      plotlyOutput("timelinePlot")
    )
    )),
    tabPanel("Map", fluid = TRUE,
      sidebarLayout(
        sidebarPanel(
      radioButtons(
        "medal_input", 
        label = h3("Medal Type:"), 
        choices = list("Gold" = "Gold", 
                       "Silver" = "Silver", 
                       "Bronze" = "Bronze")),
      
      helpText("Note: 2 countries are not represented in this map,
               Kosovo (a partially recognized state, and 
               Individual Olympic Athletes. There are 6 medals
               between them: 2 gold, 1 silver and 3 bronze."),
      
      selectInput(
        "country_input",
        label = h3("Country:"),
        choices = final_counts$name.y
      ),
      
      tableOutput("country_output")
    ),
    mainPanel(
      plotlyOutput("mapPlot")
    )
      )
    )
  )
  )
)
