
fixData <- function(dataf, input){
  
  dataf[is.na(dataf)] <- "Not applied"
  
  useful_data <- select(dataf, Sex, Year, Games, Season, Medal)
  goldmedals <- filter(useful_data, Medal == input$medal)
  data_with_date <- filter(goldmedals, Games == input$game)
  rm(dataf, useful_data, goldmedals)
  gold_f <- filter(data_with_date, Sex == "F")
  gold_m <- filter(data_with_date, Sex == "M")
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
