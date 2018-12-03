library(shiny)
library(vistime)
library(dplyr)
library(plotly)
library(mapdata)
library(data.table)
library(countrycode)

olympics_df <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  timeline_data <- get_timeline_data(olympics_df)

  filteredData <- reactive({
    timeline_data[timeline_data$Season %in% input$season, ]
  })
  
  
  output$timelinePlot <- renderPlotly({
    
    vistime(filteredData(), start = "Date", end = "Date", events = "NOC", groups = "Season",
            title = "Years That Specific Countries First Entered the Olympics",
            tooltips = "region_games", showLabels = FALSE)
  })
  
  output$nationData <- renderText(
    paste0(input$nation, " first entered the Olympics for the ",
           timeline_data[which(timeline_data$region == input$nation), ]$Games[1], " Olympic Games.")
    )
  output$medal_input <- renderPrint({input$medal_input})
  
  output$mapPlot <- renderPlotly({
    filtered <- filter(counts, Medal == input$medal_input)
    filtered <- full_join(filtered, country_codes, by = "iso")
    filtered$count[is.na(filtered$count)] <- 0
    
    filtered$hover <- with(filtered, paste(name.y, '<br>', Medal, count))
    
    l <- list(color = toRGB("grey"), width = 0.5)
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      showLand = TRUE,
      projection = list(type = 'Mercator')
    )
    p <- plot_geo(filtered) %>%
      add_trace(
        z = ~count, 
        color = ~count, 
        colors = 'Blues',
        text = ~hover,
        locations = ~iso
      ) %>%
      colorbar(title = 'Counts') %>%
      layout(
        title = 'Worldwide Olympic Medal Counts',
        geo = g
      )
  })
  
  output$country_output <- renderText({
    country_filter <- filter(final_counts, name.y == input$country_input)
    total <- sum(country_filter$count)
    
    paste(input$country_input, "has won a total medal count of ", total, "medals")
  })
})
