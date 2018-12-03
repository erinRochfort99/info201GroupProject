#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(dplyr)
library(shiny)
rsconnect::showLogs()
original <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    #filter data
    original[is.na(original)] <- "Not applied"
    useful_data <- select(original, Sex, Year, Games, Season, Medal)
    goldmedals <- filter(useful_data, Medal == input$medal)
    data_with_date <- filter(goldmedals, Games == input$game)
    rm(original, useful_data, goldmedals)
    gold_f <- filter(data_with_date, Sex == "F")
    gold_m <- filter(data_with_date, Sex == "M")
    #calculate the data
    num_f <- nrow(gold_f)
    num_m <- nrow(gold_m)
    total <- num_f + num_m
    percent_f <- round(num_f / total * 100)
    percent_m <- round(num_m / total * 100)
    value = c(percent_m, percent_f)
    lbls <- paste(value, "%", sep = "")
    #make the plot
    midpoint <- cumsum(value) - value / 2
    pie_info <- data.frame(group = c("Male", "Female"), value = value)
    ggplot(pie_info, aes(x = " ", y = value, fill = group)) +
      geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
      labs(x = "", y = "", title = "Medal Owners' Sex Distribution", fill = "Sex") +
      theme(plot.title = element_text(size=20, face="bold")) +
      coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = lbls), size = 7)
  })
})

