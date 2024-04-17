# this script creates an app for demonstrating cards in shiny

library(shiny)
library(bslib)

# define the ui
ui <- page_sidebar(
  title = "Hello Cards",
  sidebar = sidebar(
    "Sidebar content"
  ),
  card(
    card_title("Card title"),
    plotOutput("plot")
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    hist(rnorm(100))
  })
}

shinyApp(ui, server)