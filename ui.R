library("shiny")

my_ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      radioButtons("medalChoices", "Choose what medals to display", 
                   choices = list(
                     "Gold" ="Gold", 
                     "Silver" = "Silver", 
                     "Bronze" = "Bronze", 
                     "All" = "All"
                   ))
    ),
    mainPanel(
      plotOutput("scatter"),
      textOutput("pract")
    )
  )
)

shinyUI(my_ui)