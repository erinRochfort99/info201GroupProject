# timeline visual

library(ggplot2)
library(scales)
library(lubridate)
library(dplyr)

olympics_df <- read.csv("athlete_events.csv", stringsAsFactors = FALSE)
olympics_df <- select(olympics_df, Year, NOC, Season, Games)
olympics_df <- olympics_df[with(olympics_df, order(Year)), ]
filtered_olympics_df <-  olympics_df[!duplicated(olympics_df[, "NOC"]),]

positions <- c(0.5, -0.5, 1.0, -1.0, 1.5, -1.5)
directions <- c(1, -1)
unique_games <- unique(filtered_olympics_df$Games)
line_pos <- data.frame(
  "Games" = unique(unique_games),
  "Position" = rep(positions, length.out = length(unique_games)),
  "Direction" = rep(directions, length.out = length(unique_games))
)

w_positions_df <- full_join(filtered_olympics_df, line_pos, by = "Games")

text_offset <- 0.05
w_positions_df$games_count <- ave(w_positions_df$Games == w_positions_df$Games, w_positions_df$Games, FUN = cumsum)
w_positions_df$text_position <- (w_positions_df$games_count * text_offset * w_positions_df$Direction) + w_positions_df$Position

year_buffer <- 1
year_date_range <- seq(min(w_positions_df$Year) - year_buffer, max(w_positions_df$Year) + year_buffer, by = 1)
year_format <- format(year_date_range, trim = TRUE)
year_df <- data.frame(year_date_range)

timeline_plot <- ggplot(w_positions_df, aes(x = Year, y = 0, col = Season)) +
  labs(col = "Season") +
  geom_hline(yintercept = 0, color = "black", size = 0.3) +
  geom_segment(data=w_positions_df[w_positions_df$games_count == 1,],
               aes(y=Position,yend=0,xend=Year), color='black', size=0.2) +
  geom_point(aes(y=0), size=3) +
  theme(axis.line.y=element_blank(),
        axis.text.y=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.x =element_blank(),
        axis.ticks.x =element_blank(),
        axis.line.x =element_blank(),
        legend.position = "bottom"
  ) +
  geom_text(data= year_df, aes(x = year_date_range, y = -0.1, label = year_format),
            size=2.5, vjust=0.5, color='black', angle=90)