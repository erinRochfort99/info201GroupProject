library(shiny)
library(dplyr)
library(plotly)

data <- read.csv("./data/athlete_events.csv", stringsAsFactors = FALSE)
source("map_data.R")

server <- shinyServer(function(input, output) {
  
  output$medal_input <- renderPrint({input$medal_input})
  
  output$plot <- renderPlotly({
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
