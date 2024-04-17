# this script creates an app for demonstrating the navigation containers in shiny

library(shiny)
library(bslib)

# define the ui
ui <- page_sidebar(
  title = "Navigation containers",
  sidebar = sidebar(
    p("This is where we would generally have our input controls")
  ),
  navset_tab(
    nav_panel(
      title = "Plots",
      plotOutput("plot")
    ),
    nav_panel(
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