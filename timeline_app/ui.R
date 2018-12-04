
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
source("data/calculation.R")
source("data/scatterPlot.R")

distinct_game <- distinct(olympics_df, Games)
distinct_game_order <- arrange(distinct_game, Games)
medal_type <- c("Gold", "Bronze", "Silver")

timeline_data <- get_timeline_data(olympics_df)

shinyUI(fluidPage(
  
  titlePanel("Olympics Data"),
  
  tabsetPanel(
    # Erika
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
      )
    ),
    # Jocelyn
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
    ),
    # Erin
    tabPanel("Scatter Plot", fluid = TRUE,
      sidebarLayout(
        sidebarPanel(
          radioButtons("medalChoices", "Choose what medals to display", 
                       choices = list(
                         "Gold" ="Gold", 
                         "Silver" = "Silver", 
                         "Bronze" = "Bronze", 
                         "All" = "All"
                       ))
        ),
        mainPanel(
          plotOutput("scatter"),
          textOutput("pract")
        )
      )
    ),
    # Jenny
    tabPanel("Pie Chart", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 selectInput("game",
                             "Choose a specific game",
                             choices = distinct_game_order, selected = "2016 Summer"),
                 checkboxGroupInput("medal", "Choose types of medal",
                                    choices = medal_type, selected = medal_type)
               ),
               mainPanel(
                 plotOutput("distPlot", width = 600, height = 600),
                 textOutput("text")
               )
             )
    )
    )
  )
)
