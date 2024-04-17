# this script creates an app for demonstrating value boxes in shiny

library(shiny)
library(bslib)

# define the ui
ui <- page_sidebar(
  title = "Hello Value Box",
  sidebar = sidebar(
    "Sidebar content"
  ),
  value_box(
    title = "Total number of participants",
    value = 34,
    max_height = "100px"
  ),
  layout_columns(
    col_widths = c(3),
    value_box(
      title = "Total number of participants",
      value = 34,
      max_height = "100px"
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)