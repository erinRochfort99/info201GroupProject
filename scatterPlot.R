#create scatterplot that displays the relationship between
#the size of an Olympic team and their medal count

library("dplyr")
library("ggplot2")

events <- read.csv("./data/athlete_events.csv")
events <- select(events, Team, NOC, Medal)

ha <- filter(events, Medal != "NA")

team_count  <- events %>%
  count(Team)
colnames(team_count)[2] <- "TeamSize"

count_medal <- function(data, medal){
  if(medal == "All"){
    data <- events %>%
      filter(Medal != "NA") %>%
      count(Team) 
  }else{
    data <- events %>%
      filter(Medal == medal) %>%
      count(Team)
  }
  colnames(data)[2] <- "medal"
  return(data)
}

