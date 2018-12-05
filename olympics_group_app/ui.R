
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
source("data/calculation2.R")
source("data/scatterPlot.R")
source("data/scatterPlotTextHelper.R")

distinct_game <- distinct(olympics_df, Games)
distinct_game_order <- arrange(distinct_game, Games)
medal_type <- c("Gold", "Bronze", "Silver")

timeline_data <- get_timeline_data(olympics_df)

nation_data_edit <- timeline_data$region

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
          selectInput("nation", h3("Nation/Group:"),
                      c(timeline_data$region),
                      selected = "nation"),
          tableOutput(
                      "nationData"
          )
        ),
        mainPanel(
          plotlyOutput("timelinePlot"),
          textOutput("timeline_analysis")
        )
      )
    ),
    # Jocelyn
    tabPanel("Map", fluid = TRUE,
      sidebarLayout(
        sidebarPanel(
          helpText("Note: 2 countries are not represented in this map,
                  Kosovo (a partially recognized state), and 
                  Individual Olympic Athletes. There are 6 medals
                  between them: 2 gold, 1 silver and 3 bronze."),
          
          radioButtons(
                      "medal_input", 
                      label = h3("Medal Type:"), 
                        choices = list("Gold" = "Gold", 
                        "Silver" = "Silver", 
                        "Bronze" = "Bronze")),
      
          radioButtons(
            "outlier_input", 
            label = h4("Choose whether to include or exclude 3 outliers:
                       (USA, Russia and Germany)"), 
            choices = list("Include" = FALSE, 
                           "Exclude" = TRUE)),
      
          selectInput(
                      "country_input",
                      label = h3("Country:"),
                      choices = country_codes$name
          ),
          tableOutput("country_output")
        ),
        mainPanel(
          plotlyOutput("mapPlot"),
          textOutput("map_analysis")
        )
      )
    ),
    # Erin
    tabPanel("Scatter Plot", fluid = TRUE,
      sidebarLayout(
        sidebarPanel(
          radioButtons("medalChoices", h3("Choose which medals to display:"), 
                       choices = list(
                         "Gold" = "Gold", 
                         "Silver" = "Silver", 
                         "Bronze" = "Bronze", 
                         "All" = "All"
                       )),
          selectInput("nation_group", h3("Nation/Group:"),
                      c(nation_data_edit),
                      selected = "nation_group"),
          tableOutput(
            "nationGroupData"
          )
        ),
        mainPanel(
          fluidRow(
            column(width = 4,
                   plotOutput("scatter", height = 350, width = 800,
                              click = "plot1_click"
                   )
            )
          ),
          fluidRow(
            column(width = 10,
                   h4("Information for Chosen Point:"),
                   verbatimTextOutput("click_info")
            )
          ),
          textOutput("pract")
        )
      )
    ),
    # Jenny
    tabPanel("Pie Chart", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 selectInput("game", h4("Gender Distribution of Medals by Game and Medal Type (Chart 1):"),
                             choices = distinct_game_order, selected = "2016 Summer"),
                 checkboxGroupInput("medal", "Choose which types of medal:",
                                    choices = medal_type, selected = medal_type),
                 selectInput("group", h4("Gender Distribution of Medals by Nation/Group (Chart 2):"),
                             c(nation_data_edit),
                             selected = "group")
               ),
               mainPanel(
                 fluidRow(
                   splitLayout(cellWidths = c("50%", "50%"),
                               plotOutput("distPlot", width = 400, height = 400),
                               plotOutput("distPlot2", width = 400, height = 400))
                 ),
                 textOutput("text")
               )
             )
    )
    )
  )
)
