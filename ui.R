library("shiny")

my_ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      uiOutput("medalChoice")
    ),
    mainPanel(
      #plotOutput("scatter")
      textOutput("pract")
    )
  )
)

shinyUI(my_ui)