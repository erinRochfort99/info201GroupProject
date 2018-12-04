# library(vistime)
# 
olympics_df <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)

get_timeline_data <- function(df) {
olympics_df <- select(olympics_df, Year, NOC, Team, Season, Games)
olympics_df <- olympics_df[with(olympics_df, order(Year)), ]
filtered_olympics_df <-  olympics_df[!duplicated(olympics_df[, "NOC"]),]

filtered_olympics_df <- mutate(filtered_olympics_df, Date = Year)

count <- 0
for(season in filtered_olympics_df$Season) {
  count <- count + 1
  if (season == "Winter") {
    filtered_olympics_df[count, ]$Date <- paste0(filtered_olympics_df[count, ]$Date, "-02-01")
  } else {
    filtered_olympics_df[count, ]$Date <- paste0(filtered_olympics_df[count, ]$Date, "-07-01")
  }
}

regions_df <- read.csv("data/noc_regions.csv", stringsAsFactors = FALSE) %>%
  select(NOC, region)

combined_region_NOC <- full_join(filtered_olympics_df, regions_df, by = "NOC") %>%
  slice(c(-42,-231))

count <- 0
for (region in combined_region_NOC$region) {
  count <- count + 1
  if(is.na(region)) {
    combined_region_NOC[count, ]$region <- combined_region_NOC[count, ]$Team
  }
}
combined_region_NOC <- mutate(combined_region_NOC,
                              "region_games" = paste0(combined_region_NOC$region, ", ", combined_region_NOC$Games))
combined_region_NOC <- combined_region_NOC[order(combined_region_NOC$region),]

# timeline <- vistime(combined_region_NOC, start = "Date", end = "Date", events = "NOC", groups = "Season",
#                     title = "Years That Specific Countries First Entered the Olympics",
#                     tooltips = "region_games", showLabels = FALSE)
return (combined_region_NOC)
}