#create scatterplot that displays the relationship between
#the size of an Olympic team and their medal count

library("dplyr")
library("ggplot2")

events <- read.csv("./data/athlete_events.csv")

region  <- events %>%
  group_by(NOC) %>%
  summarize(
    n()
  )

medal <- evens %>%
  group_by(Medal) %>%
  summarize(
    n()
  )



ggplot(events, aes(x = Team, y = Medal)) +
  geom_point(size = 2)
