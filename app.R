library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(DBI)
library(odbc)
library(DT)
library(shinyWidgets)
library(shinycssloaders)

# Blue palette
blue_palette <- c("#1E90FF", "#4169E1", "#00B7EB", "#6495ED")

# Custom CSS for black theme
custom_css <- "
.skin-black .main-header .logo { background-color: #000000; color: #FFFFFF; }
.skin-black .main-header .navbar { background-color: #000000; }
.skin-black .main-sidebar { background-color: #1C2526; }
.skin-black .main-sidebar .sidebar-menu > li.active > a { background-color: #4169E1; }
.skin-black .content-wrapper { background-color: #000000; color: #FFFFFF; }
.skin-black .box { background-color: #1C2526; color: #FFFFFF; border-top-color: #4169E1; }
.skin-black .box-header { background-color: #4169E1; color: #FFFFFF; }
.plotly .cartesianlayer .gridlayer .gridline { stroke: #FFFFFF; stroke-dasharray: 2,2; }
.plotly .gtitle, .plotly .xtitle, .plotly .ytitle, .plotly .annotation-text { fill: #FFFFFF; }
.plotly .ticktext { fill: #FFFFFF; }
"

# SQL Server connection
con <- tryCatch({
  DBI::dbConnect(odbc::odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 Server = "5CD147L68L",
                 Database = "FlightDeckDB",
                 Trusted_Connection = "Yes"
  )
}, error = function(e) {
  stop("Database connection failed: ", e$message)
})

# UI
ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Founder's Flight Deck"),
  dashboardSidebar(
    sidebarMenu(
      dateRangeInput("date_range", "Select Date Range", start = Sys.Date() - 365, end = Sys.Date()),
      menuItem("Defense", tabName = "defense", icon = icon("shield-alt")),
      menuItem("Fintech", tabName = "fintech", icon = icon("university")),
      menuItem("Nonprofit", tabName = "nonprofit", icon = icon("globe")),
      downloadButton("download_data", "Download Defense Data")
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML(custom_css))),
    tabItems(
      tabItem(tabName = "defense",
              fluidRow(
                box(title = "Anomaly Flag Rate", status = "primary", solidHeader = TRUE, width = 8,
                    withSpinner(plotlyOutput("defense_plot"))),
                box(title = "Summary", status = "primary", solidHeader = TRUE, width = 4,
                    tableOutput("defense_summary")),
                box(title = "Data Table", status = "primary", solidHeader = TRUE, width = 12,
                    DTOutput("defense_table"))
              )),
      tabItem(tabName = "fintech",
              fluidRow(
                box(title = "Approval & Fairness", status = "success", solidHeader = TRUE, width = 8,
                    withSpinner(plotlyOutput("fintech_plot"))),
                box(title = "Summary", status = "success", solidHeader = TRUE, width = 4,
                    tableOutput("fintech_summary")),
                box(title = "Data Table", status = "success", solidHeader = TRUE, width = 12,
                    DTOutput("fintech_table"))
              )),
      tabItem(tabName = "nonprofit",
              fluidRow(
                box(title = "Transparency & Engagement", status = "info", solidHeader = TRUE, width = 8,
                    withSpinner(plotlyOutput("nonprofit_plot"))),
                box(title = "Summary", status = "info", solidHeader = TRUE, width = 4,
                    tableOutput("nonprofit_summary")),
                box(title = "Data Table", status = "info", solidHeader = TRUE, width = 12,
                    DTOutput("nonprofit_table"))
              ))
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Load Defense data
  get_defense_data <- reactive({
    df <- dbGetQuery(con, "SELECT * FROM PipelineData WHERE Sector = 'Defense'")
    df$Date <- as.Date(df$Date)
    df %>% filter(Date >= input$date_range[1], Date <= input$date_range[2])
  })
  
  # Load Fintech data
  get_fintech_data <- reactive({
    df <- dbGetQuery(con, "SELECT * FROM FintechData")
    df$Date <- as.Date(df$Date)
    df %>% filter(Date >= input$date_range[1], Date <= input$date_range[2])
  })
  
  # Load Nonprofit data
  get_nonprofit_data <- reactive({
    df <- dbGetQuery(con, "SELECT * FROM NonprofitData")
    df$Date <- as.Date(df$Date)
    df %>% filter(Date >= input$date_range[1], Date <= input$date_range[2])
  })
  
  # Summary function
  get_summary <- function(df, metric) {
    if (!(metric %in% colnames(df))) return(data.frame())
    df %>% summarise(
      Mean = round(mean(.data[[metric]], na.rm = TRUE), 2),
      Median = round(median(.data[[metric]], na.rm = TRUE), 2),
      Min = round(min(.data[[metric]], na.rm = TRUE), 2),
      Max = round(max(.data[[metric]], na.rm = TRUE), 2)
    )
  }
  
  # Defense Tab
  output$defense_plot <- renderPlotly({
    df <- get_defense_data()
    p <- ggplot(df, aes(x = Date, y = FlagRate)) +
      geom_line(color = blue_palette[1]) +
      labs(title = "Defense: Flag Rate Over Time", x = "Date", y = "FlagRate") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "#000000"),
        panel.background = element_rect(fill = "#000000"),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white")
      )
    ggplotly(p)
  })
  output$defense_summary <- renderTable({
    get_summary(get_defense_data(), "FlagRate")
  })
  output$defense_table <- renderDT({
    df <- get_defense_data()
    datatable(df, options = list(pageLength = 5), class = "display") %>%
      formatStyle(columns = names(df), color = 'white', backgroundColor = '#1C2526')
  })
  
  # Fintech Tab
  output$fintech_plot <- renderPlotly({
    df <- get_fintech_data()
    p <- ggplot(df, aes(x = Date)) +
      geom_line(aes(y = ApprovalRate, color = "Approval Rate"), size = 1) +
      geom_line(aes(y = FairnessScore, color = "Fairness Score"), size = 1) +
      scale_color_manual(values = c("Approval Rate" = blue_palette[2], "Fairness Score" = blue_palette[3])) +
      labs(title = "Fintech: Approval & Fairness", y = "", color = "Metric") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "#000000"),
        panel.background = element_rect(fill = "#000000"),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white"),
        legend.text = element_text(color = "white"),
        legend.title = element_text(color = "white")
      )
    ggplotly(p)
  })
  output$fintech_summary <- renderTable({
    get_summary(get_fintech_data(), "FairnessScore")
  })
  output$fintech_table <- renderDT({
    df <- get_fintech_data()
    datatable(df, options = list(pageLength = 5), class = "display") %>%
      formatStyle(columns = names(df), color = 'white', backgroundColor = '#1C2526')
  })
  
  # Nonprofit Tab
  output$nonprofit_plot <- renderPlotly({
    df <- get_nonprofit_data()
    p <- ggplot(df, aes(x = Date)) +
      geom_line(aes(y = TransparencyIndex, color = "Transparency"), size = 1) +
      geom_line(aes(y = EngagementScore, color = "Engagement"), size = 1) +
      scale_color_manual(values = c("Transparency" = blue_palette[4], "Engagement" = blue_palette[1])) +
      labs(title = "Nonprofit: Transparency & Engagement", y = "", color = "Metric") +
      theme_minimal() +
      theme(
        plot.background = element_rect(fill = "#000000"),
        panel.background = element_rect(fill = "#000000"),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white"),
        legend.text = element_text(color = "white"),
        legend.title = element_text(color = "white")
      )
    ggplotly(p)
  })
  output$nonprofit_summary <- renderTable({
    get_summary(get_nonprofit_data(), "TransparencyIndex")
  })
  output$nonprofit_table <- renderDT({
    df <- get_nonprofit_data()
    datatable(df, options = list(pageLength = 5), class = "display") %>%
      formatStyle(columns = names(df), color = 'white', backgroundColor = '#1C2526')
  })
  
  # Defense CSV Download
  output$download_data <- downloadHandler(
    filename = function() {
      paste("defense_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(get_defense_data(), file, row.names = FALSE)
    }
  )
}

# Launch
shinyApp(ui = ui, server = server)
