# this script creates an app with the the page_fluid() layout function

library(shiny)
library(bslib)

# define the ui
ui <- page_fluid(
  title = "Hello Shiny",
  h1("Page fluid example"), 
  sliderInput(
    inputId = "bins",
    label = "Number of bins",
    min = 1, 
    max = 50,
    value = 30
  ),
  plotOutput("distPlot")
)

# define the server
server <- function(input, output, session) {
  output$distPlot <- renderPlot({
    
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(
      x,
      breaks = bins,
      col = "#007bc2",
      border = "white",
      xlab = "Waiting time to next eruption (in mins)",
      main = "Histogram of waiting times"
    )
  })
}

shinyApp(ui, server)