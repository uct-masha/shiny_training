# this script creates an app for demonstrating accordions in shiny

library(shiny)
library(bslib)

# define the ui
ui <- page_sidebar(
  title = "Hello Cards",
  sidebar = sidebar(
    "Sidebar content"
  ),
  accordion(
    open = FALSE,
    accordion_panel(
      title = "Plots",
      plotOutput("plot")
    ),
    accordion_panel(
      title = "Tables",
      tableOutput("table")
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    hist(rnorm(100))
  })
  
  output$table <- renderTable({
    mtcars
  })
}

shinyApp(ui, server)