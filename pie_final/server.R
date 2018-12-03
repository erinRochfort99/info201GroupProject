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
original <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)
source("data/calculation.R")
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    #filter data and calculate the data
    data_table <- fixData(original, input)
    #make the plot
    midpoint <- cumsum(data_table$value) - data_table$value / 2
    pie_info <- data.frame(group = c("Male", "Female"), value = data_table$value)
    ggplot(pie_info, aes(x = " ", y = data_table$value, fill = group)) +
      geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
      labs(x = "", y = "", title = "Medal Owners' Sex Distribution", fill = "Sex") +
      theme(plot.title = element_text(size=20, face="bold")) +
      coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = data_table$lbls), size = 7)
  })
  output$text <- renderText({
    data_info <- fixData(original, input)
    paste0("According to the data, female athletes won ", data_info$num_f,
           " medals; Male athletes won ", data_info$num_m, ".")
  })
})

