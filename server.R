library("shiny")
library("dplyr")
library("ggplot2")

events <- read.csv("./data/athlete_events.csv")
events <- select(events, Team, NOC, Medal)

source("scatterPlot.R")

##########
my_server <- function(input, output)({
  
  output$scatter <- renderPlot({
    used_data <- count_medal(events, input$medalChoices)
    used_data <- left_join(team_count, used_data, by = "Team")
    ggplot(used_data) +
      geom_point(aes(x = TeamSize, y = medal))+
      labs(title = "Team Size vs. Medal Count")
    
  })
  
  output$pract <- renderText({
    paste("practice")
  })
  
  
})



shinyServer(my_server)
