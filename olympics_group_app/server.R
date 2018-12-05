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
  output$timeline_analysis <- renderText({
    paste0("This timeline depicts the year and season that different nations/groups entered the Olympics ",
           "for the first time. Most countries seem to enter in the summer, however, a majority of the ",
           "countries that join in the winter season are Slavic countries or countries that are known for ",
           "their winter sports. It's worth pointing out that after the Berlin wall fell in 1991, many ",
           "countries in that region joined the Olympics for the first time for the Winter 1992 and ",
           "Winter 1994 Olympics. This could be due to the added freedom that these countries had after ",
           "that significant event.")
  })
  
  # Jocelyn's
  output$medal_input <- renderPrint({input$medal_input})
  
  output$outlier_input <- renderPrint({input$outlier_input})
  
  output$mapPlot <- renderPlotly({
    filtered <- filter(counts, Medal == input$medal_input)
    filtered <- full_join(filtered, country_codes, by = "iso")
    filtered$count[is.na(filtered$count)] <- 0
    
    if(input$outlier_input) {
      filtered <- filter(filtered, name.x != "USA") %>% 
        filter(name.x != "Russia") %>% 
        filter(name.x != "Germany")
    }
    
    filtered$hover <- with(filtered, paste(name.y, '<br>', Medal, count))
    
    if(input$medal_input == "Gold") {
      color = 'Blues'
    } else if(input$medal_input == "Silver") {
      color = 'Reds'
    } else {
      color = 'Greens'
    }
    
    l <- list(color = toRGB("grey"), width = 0.5)
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      showLand = TRUE,
      showcountries = TRUE,
      projection = list(type = 'Mercator')
    )
    p <- plot_geo(filtered) %>%
      add_trace(
        z = ~count, 
        color = ~count, 
        colors = color,
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
    
    paste(input$country_input, "has won a total of ", total, "medals.")
  })
  
  output$map_analysis <- renderText({
    paste0("This choropleth map shows the medal counts for each country 
           based off of medal type. In doing this, geographic groupings
           in winning medals can be shown. However, there are three countries,
           USA, Russia and Germany, that together make up more than half of
           all medals won When choosing the option to exclude these three
           countries from the map using the widget on the left, geographic groupings
           are more easily shown. Aside from USA, Russia and Germany, most medals
           are won by Western European countries, Australia, Canada and China which makes
           sense given their respective population sizes and economic well being.")
  })
  
  # Erin's
  events <- select(olympics_df, Team, NOC, Medal)
  
  output$scatter <- renderPlot({
    used_data <- count_medal(events, input$medalChoices)
    used_data <- left_join(team_count, used_data, by = "region")
    used_data[is.na(used_data)] <- 0
    specific_color <- ""
    if (input$medalChoices == "Gold") {
      specific_color <- "blue"
    } else if (input$medalChoices == "Silver") {
      specific_color <- "red"
    } else if (input$medalChoices == "Bronze"){
      specific_color <- "green3"
    } else {
      specific_color <- "gold2"
    }
    ggplot(used_data, aes(x = Team_Size, y = Medal_Count)) +
      geom_point(color = specific_color, size = 4) +
      geom_smooth(method = lm, se = FALSE, color = "black") +
      labs(title = paste0("Team Size vs. ", input$medalChoices, " Medal Count (select a point)")) +
      xlab("Medal Count") + ylab("Team Size")
  })
  
  output$nationGroupData <- renderText(
    paste0(input$nation_group, " has a team size of ",
           team_count[which(team_count$region == input$nation_group),]$Team_Size,
           " people and has ", get_value(input$medalChoices, input$nation_group),
           " ", name_medal(input$medalChoices), " medals.")
  )
  
  output$click_info <- renderPrint({
    used_data <- count_medal(events, input$medalChoices)
    used_data <- left_join(team_count, used_data, by = "region")
    used_data[is.na(used_data)] <- 0
    nearPoints(used_data, input$plot1_click)
  })
  
  output$pract <- renderText({
    paste("This scatter plot depicts the data for", tolower(input$medalChoices),
          "medal counts per group/nation, which is then used to display the relationship between",
          "Olympic team size of a group/nation and the number of medals that they have.",
          "From this data it can be concluded that the relationship between the size of",
          "an Olympic team and the number of medals they have is a positive relationship, as",
          "shown by the line of best fit in the graph. One country in particular stands out for 
          having a very large team and very high number of medals won: USA. Given how big the team is,
          one could argue that the USA is not very effective in winning medals, but at the same time,
          the dispropotionately large team size may contribute to the large number of medals won.")
  })
  
  # Jenny's
  output$distPlot <- renderPlot({
    data_table <- fixData(olympics_df, input)
    midpoint <- cumsum(data_table$value) - data_table$value / 2
    pie_info <- data.frame(group = c("Male", "Female"), value = data_table$value)
    ggplot(pie_info, aes(x = " ", y = data_table$value, fill = group)) +
      geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
      labs(x = "", y = "", title = paste("Sex Distribution of Medals for the", paste(input$game, "Olympic Games"),
                                         "(Chart 1)", sep = "\n"), fill = "Sex") +
      theme(plot.title = element_text(size=20, face="bold")) +
      coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = data_table$lbls), size = 7)
  })
  
  output$distPlot2 <- renderPlot({
    data_table <- fixData2(olympics_df, input)
    midpoint <- cumsum(data_table$value) - data_table$value / 2
    pie_info <- data.frame(group = c("Male", "Female"), value = data_table$value)
    ggplot(pie_info, aes(x = " ", y = data_table$value, fill = group)) +
      geom_bar(width = 1, stat = "identity") + scale_fill_manual(values=c("#FFC0CB", "#89CFF0")) +
      labs(x = "", y = "", title = paste("Sex Distribution of Medals for", input$group, "(Chart 2)", sep = "\n"),
           fill = "Sex") +
      theme(plot.title = element_text(size=20, face="bold")) +
      coord_polar("y", start=0) + geom_text(aes(x = 1.3, y = midpoint, label = data_table$lbls), size = 7)
  })
  
  output$text <- renderText({
    data_info1 <- fixData(olympics_df, input) %>%
      slice(1)
    data_info2 <- fixData2(olympics_df, input) %>%
    slice(1)
    paste0("According to the data for the ", input$game," Olympic games, female athletes won ", data_info1$num_f, " ",
           " medals, whereas male athletes won ", data_info1$num_m, " medals overall. ",
           input$group, " has a gender distribution of medals consisting of ", data_info2$percent_f, 
           "% females and ", data_info2$percent_m, "% males.",
           " From this data it can be inferred that throughout the Olympics' history there have been more male events",
           " than female events. However, the amount of female events has been increasing since the Summer 1900 games.",
           "It's also interesting to observe the differences in gender distribution of Olympic medals between ",
           "specific groups/nations. Some countries like Afghanistan still had an overwhelmingly large male team in Rio 2016 
           whereas China had a 51% female team.")
  })
})
