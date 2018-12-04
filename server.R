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
    used_data[is.na(used_data)] <- 0
    ggplot(used_data, aes(x = TeamSize, y = medal)) +
      geom_point()+
      geom_smooth(method = lm, se = FALSE)+
      labs(title = "Team Size vs. Medal Count")

  })

  output$pract <- renderText({
    paste("The scatter plot above utilizes ", input$medalChoices, " medal counts to display the relationship
          between Olympic Team Size and the number of medals they are awarded.")
  })
  
})



shinyServer(my_server)
