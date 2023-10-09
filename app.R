#This is a Shiny web application. You can run the application by clicking the 'Run App' button above.
#Find out more about building applications with Shiny here: http://shiny.rstudio.com/

## Interactive Dashboard created with shiny

#First we need to define the UI:
  
library(shiny)
library(tidyverse)
ui <- fluidPage(
  titlePanel("Interactive Dashboard"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Select Year", min = min(nba_nuggets_shots$yearSeason),
                  max = max(nba_nuggets_shots$yearSeason), value = min(nba_nuggets_shots$yearSeason),
                  step = 1)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

#Second we need to define the server logic and third run the shinyApp: `shinyApp(ui, server)`. By defining `runtime: shiny` in the YAML, the dashboard is displayed in the html document.

server <- function(input, output) {
  output$plot <- renderPlot({
    filtered_data <- nba_nuggets_shots[nba_nuggets_shots$yearSeason == input$year, ]
    ggplot(filtered_data, aes(x = distanceShot, y = isShotMade, fill = isShotMade)) +
      geom_boxplot() + stat_summary(fun = mean, geom = "point", shape = 23, size = 2, fill = "black", position = position_dodge(width = 0.75)) +
      scale_fill_manual(values = c("tomato", "palegreen")) +
      labs(x = "Distance Shot", y = "Is Shot Made", fill = "Is Shot Made?") +
      ggtitle("Distribution of Distance Shot by Efficiency Rate") +
      facet_wrap(~yearSeason, ncol = 3)
  })
}
shinyApp(ui, server)

#The slidebar selects the desired year throughout the years 2015 to 2023. We can now see the distribution of distance shot and efficiency rate for each year. To understand the dashboard by year, recall that 1) The boxes represent the interquartile range (0.25 to 0.75 percent of the observations), filled in green for shots made and red for shots missed. 2) The vertical line inside the box represents the median (0.50 of the observations). The black diamond represents the mean. 3) The black points represent outliers, with more shots missed in long distances and a few shots converted in long distances.
