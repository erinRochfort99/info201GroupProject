#create scatterplot that displays the relationship between
#the size of an Olympic team and their medal count

library("dplyr")
library("ggplot2")

events <- read.csv("./data/athlete_events.csv")
events <- select(events, Team, NOC, Medal)

team_count  <- events %>%
  count(Team)
colnames(team_count)[2] <- "TeamSize"

count_medal <- function(data, medal){
  data <- events %>%
    filter(Medal == medal) %>%
    count(Team) 
  colnames(data)[2] <- "medal"
  return(data)
}


#gold_count <- count_medal(events, "Gold")
#silver_count <- count_medal(events, "Silver")
#bronze_count <- count_medal(events, "Bronze")



#sum <- left_join(team_count, gold_count, by = "Team")
#sum <- left_join(sum, silver_count, by = "Team") 
#sum <- left_join(sum, bronze_count, by = "Team")
#sum[is.na(sum)] <- 0
#sum$All = sum$Gold + sum$Silver + sum$Bronze


#ggplot(sum) +
#  geom_point(aes(x = TeamSize, y = All))

