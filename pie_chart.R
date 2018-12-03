library(ggplot2)
library(dplyr)

original_data <- read.csv("../data/athlete_events.csv", stringsAsFactors = FALSE)

distinct_game <- distinct(original_data, Games)
distinct_game_order <- arrange(distinct_game, Games)
distinct_medal <- distinct(original_data, Medal)

make_pie <- function(original) {
  original[is.na(original)] <- "Not applied"
  useful_data <- select(original, Sex, Year, Games, Season, Medal)
  goldmedals <- filter(useful_data, Medal == "Gold")
  rm(original, useful_data)
  gold_f <- filter(goldmedals, Sex == "F")
  gold_m <- filter(goldmedals, Sex == "M")
  num_f <- nrow(gold_f)
  num_m <- nrow(gold_m)
  total <- num_f + num_m
  percent_f <- round(num_f / total * 100)
  percent_m <- round(num_m / total * 100)
  value = c(percent_m, percent_f)
  lbls <- paste(value, "%", sep = "")
  midpoint <- cumsum(value) - value / 2
  pie_info <- data.frame(group = c("Male", "Female"), value = value)
  pie_chart <- ggplot(pie_info, aes(x = " ", y = value, fill = group)) +
    geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
    labs(x = "", y = "", title = "Medal Owners' Gender Sex Distribution", fill = "Sex") +
    theme(plot.title = element_text(size=14, face="bold")) +
    coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = lbls))
  return(pie_chart)
}

make_pie(original_data)

output$text <- renderText({
  goldmedals <- filter(useful_data, Medal == input$medal)
  data_with_date <- filter(goldmedals, Games == input$game)
  rm(original, useful_data, goldmedals)
  gold_f <- filter(data_with_date, Sex == "F")
  gold_m <- filter(data_with_date, Sex == "M")
  #calculate the data
  num_f <- nrow(gold_f)
  num_m <- nrow(gold_m)
  paste0("The number of " + input$medal + " that belongs to female atheletes is " + num_f + ".")
  paste0("The number of " + input$medal + " that belongs to male atheletes is " + num_m + ".")
})

textOutput("text"),
