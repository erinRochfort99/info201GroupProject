library("shiny")
library("dplyr")
library("ggplot2")

events <- read.csv("./data/athlete_events.csv")
events <- select(events, Team, NOC, Medal)

noc_count  <- events %>%
  count(NOC)
colnames(noc_count)[2] <- "TeamSize"

count_medal <- function(data, medal){
  data <- events %>%
    filter(Medal == medal) %>%
    count(NOC) 
  colnames(data)[2] <- paste0(medal, "Count")
  return(data)
}

gold_count <- count_medal(events, "Gold")
silver_count <- count_medal(events, "Silver")
bronze_count <- count_medal(events, "Bronze")

sum <- left_join(noc_count, gold_count, by = "NOC")
sum <- left_join(sum, silver_count, by = "NOC") 
sum <- left_join(sum, bronze_count, by = "NOC")
sum[is.na(sum)] <- 0
sum$totalMedals = sum$GoldCount + sum$SilverCount + sum$BronzeCount

##########
my_server <- function(input, output)({
  output$medalChoice <- renderUI({
    checkboxGroupInput("medal", "Choose what medals to display", distinct(events, Medal)$Medal)
  })
  
  output$scatter <- renderPlot({
    ggplot(sum) +
      geom_point(aes(x = TeamSize, y = totalMedals))+
      labs(title = "Team Size vs. Medal Count")
    
  })
  
  output$pract <- renderText({
    paste("practice")
  })
  
  
})



shinyServer(my_server)
