#source("./data/timeline.R")

fixData2 <- function(dataf, input){
  
  dataf[is.na(dataf)] <- "Not applied"

  useful_data <- select(dataf, Sex, Team, Games, NOC)
  
  regions_df <- read.csv("data/noc_regions.csv", stringsAsFactors = FALSE) %>%
    select(NOC, region)
  
  combined_region_NOC <- full_join(useful_data, regions_df, by = "NOC") %>%
    slice(c(-61081, -130722, -271117))
  
  count <- 0
  for (region in combined_region_NOC$region) {
    count <- count + 1
    if(is.na(region)) {
      combined_region_NOC[count, ]$region <- combined_region_NOC[count, ]$Team
    }
  }
  
  region_data <- filter(combined_region_NOC, region == input$group)

  rm(dataf, useful_data)
  gold_f <- filter(region_data, Sex == "F")
  gold_m <- filter(region_data, Sex == "M")
  num_f <- nrow(gold_f)
  num_m <- nrow(gold_m)
  total <- num_f + num_m
  percent_f <- round(num_f / total * 100)
  percent_m <- round(num_m / total * 100)
  value = c(percent_m, percent_f)
  lbls <- paste(value, "%", sep = "")
  data_table <- data.frame(num_f, num_m, total, percent_f, percent_m, value, lbls)
  return(data_table)
}