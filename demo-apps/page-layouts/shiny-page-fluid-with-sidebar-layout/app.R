# this script creates an app using layout_sidebar within page_fluid

library(shiny)
library(bslib)

# Define the UI for app that draws a histogram ----
ui <- page_fluid(
  # App title ----
  title = "Hello Shiny",
  h1("Page fluid with a sidebar example"),
  layout_sidebar(
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