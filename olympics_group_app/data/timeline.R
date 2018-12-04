
get_timeline_data <- function(df) {
  df <- select(df, Year, NOC, Team, Season, Games)
  df <- df[with(df, order(Year)), ]
  filtered_olympics_df <-  df[!duplicated(df[, "NOC"]),]

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

  return (combined_region_NOC)
}