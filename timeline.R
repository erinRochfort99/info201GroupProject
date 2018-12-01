library(vistime)

olympics_df <- read.csv("athlete_events.csv", stringsAsFactors = FALSE)
olympics_df <- select(olympics_df, "Date" = Year, NOC, Season, Games)
olympics_df <- olympics_df[with(olympics_df, order(Date)), ]
filtered_olympics_df <-  olympics_df[!duplicated(olympics_df[, "NOC"]),]
if (filtered_olympics_df$Season == "Winter") {
  filtered_olympics_df$Date <- paste0(filtered_olympics_df$Date, "-02-01")
} else {
  filtered_olympics_df$Date <- paste0(filtered_olympics_df$Date, "-07-01")
}
filtered_olympics_df <- mutate(filtered_olympics_df, "NOC_Games" = paste(NOC, ",",Games))


timeline <- vistime(filtered_olympics_df, start = "Date", end = "Date", events = "NOC", groups = "Season",
                    title = "Years That Specific Countries First Entered the Olympics",
                    tooltips = "NOC_Games", showLabels = FALSE)