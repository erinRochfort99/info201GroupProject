#create scatterplot that displays the relationship between
#the size of an Olympic team and their medal count

events <- read.csv("data/athlete_events.csv")
events <- select(events, Team, NOC, Medal)

regions_df <- read.csv("data/noc_regions.csv", stringsAsFactors = FALSE) %>%
  select(NOC, region)

combined_region_NOC <- full_join(events, regions_df, by = "NOC") %>%
  slice(c(-61081, -130722, -271117))

count <- 0
for (region in combined_region_NOC$region) {
  count <- count + 1
  if(is.na(region)) {
    combined_region_NOC[count, ]$region <- combined_region_NOC[count, ]$Team
  }
}

ha <- filter(combined_region_NOC, Medal != "NA")

team_count  <- combined_region_NOC %>%
  count(region)
colnames(team_count)[2] <- "Team_Size"

count_medal <- function(data, medal){
  if(medal == "All"){
    data <- combined_region_NOC %>%
      filter(Medal != "NA") %>%
      count(region) 
  }else{
    data <- combined_region_NOC %>%
      filter(Medal == medal) %>%
      count(region)
  }
  colnames(data)[2] <- "Medal_Count"
  return(data)
}

