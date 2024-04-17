# app using bslib for layout

library(shiny)
library(bslib)

# Define the UI for the app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Hello Shiny",
  sidebar = sidebar(
    # Input: Slider for the number of bins
    sliderInput(
      inputId = "bins",
      label = "Number of bins",
      min = 1, 
      max = 50,
      value = 30
    )
  ),
  # Output: Histogram ----
  plotOutput(outputId = "distPlot")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # Histogram of the old faithful geyser data ----
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

shinyApp(ui = ui, server = server)