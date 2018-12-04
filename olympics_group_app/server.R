library(shiny)
library(vistime)
library(dplyr)
library(plotly)
library(mapdata)
library(data.table)
library(countrycode)

olympics_df <- read.csv("data/athlete_events.csv", stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  # Erika's
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
  
  # Jocelyn's
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
    
    paste(input$country_input, "has won a total medal count of ", total, "medals.")
  })
  # Erin's
  events <- select(olympics_df, Team, NOC, Medal)
  
  output$scatter <- renderPlot({
    used_data <- count_medal(events, input$medalChoices)
    used_data <- left_join(team_count, used_data, by = "Team")
    used_data[is.na(used_data)] <- 0
    specific_color <- ""
    if (input$medalChoices == "Gold") {
      specific_color <- "blue"
    } else if (input$medalChoices == "Silver") {
      specific_color <- "red"
    } else if (input$medalChoices == "Bronze"){
      specific_color <- "gold2"
    } else {
      specific_color <- "green3"
    }
    ggplot(used_data, aes(x = TeamSize, y = medal)) +
      geom_point(color = specific_color, size = 4) +
      geom_smooth(method = lm, se = FALSE, color = "black") +
      labs(title = paste0("Team Size vs. ", input$medalChoices, " Medal Count"))
  })
  
  output$nationGroupData <- renderText(
    paste0(input$nation_group, " has a team size of ",
           team_count[which(team_count$Team == input$nation_group),]$TeamSize,
           " and has ", get_value(input$medalChoices, input$nation_group),
           " ", name_medal(input$medalChoices), " medals.")
  )
  
  output$click_info <- renderPrint({
    used_data <- count_medal(events, input$medalChoices)
    used_data <- left_join(team_count, used_data, by = "Team")
    used_data[is.na(used_data)] <- 0
    nearPoints(used_data, input$plot1_click)
  })
  
  output$pract <- renderText({
    paste("The scatter plot above utilizes ", input$medalChoices, " medal counts to display the relationship
          between Olympic Team Size and the number of medals they are awarded.")
  })
  
  # Jenny's
  output$distPlot <- renderPlot({
    data_table <- fixData(olympics_df, input)
    midpoint <- cumsum(data_table$value) - data_table$value / 2
    pie_info <- data.frame(group = c("Male", "Female"), value = data_table$value)
    ggplot(pie_info, aes(x = " ", y = data_table$value, fill = group)) +
      geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
      labs(x = "", y = "", title = paste("Sex Distribution of Medals by Game", "(Chart 1)", sep = "\n"), fill = "Sex") +
      theme(plot.title = element_text(size=20, face="bold")) +
      coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = data_table$lbls), size = 7)
  })
  
  output$distPlot2 <- renderPlot({
    data_table <- fixData2(olympics_df, input)
    midpoint <- cumsum(data_table$value) - data_table$value / 2
    pie_info <- data.frame(group = c("Male", "Female"), value = data_table$value)
    ggplot(pie_info, aes(x = " ", y = data_table$value, fill = group)) +
      geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
      labs(x = "", y = "", title = paste("Sex Distribution of Medals by Nation", "(Chart 2)", sep = "\n"), fill = "Sex") +
      theme(plot.title = element_text(size=20, face="bold")) +
      coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = data_table$lbls), size = 7)
  })
  
  output$text <- renderText({
    data_info <- fixData(olympics_df, input) %>%
    slice(1)
    paste0("According to the data for the ", input$game," Olympic games, female athletes won ", data_info$num_f, " ",
           " medals, whereas male athletes won ", data_info$num_m, " medals overall. ",
           input$group, " has a gender distribution of medals consisting of ", data_info$percent_f, 
           "% females and ", data_info$percent_m, "% males.",
           " From this data it can be inferred that there are more male events than female events",
           " in the Olympics, but that the amount of female events has been increasing since the Summer 1900 games.")
  })
})
