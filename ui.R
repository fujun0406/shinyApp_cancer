shinyUI(
  fluidPage(
    titlePanel("Cancer Data in the United Kingdom"), 
    sidebarLayout(
      
      sidebarPanel = sidebarPanel(
        
        # show the year range?
        h4("Year:"),
        sliderInput("year", "Enter year:(2001-2017)", 
                    value = c(2001, 2017), 
                    min =2001, max = 2017, step = 1), 
        
        # show all the tumour sites or just specific places?
        h4("Tumour Sites:"), 
        selectInput(
          "tumoursites", "",
          c("Show all cancer types" = "all",
            "Select specific types" = "specific"),
          selected = "all"),
        
        # which tumour sites to show
        conditionalPanel(
          "input.tumoursites == 'specific'",
          uiOutput("cancerTypeUi")
        ), 
        # what variables to show
        h4("Variables:"),
        uiOutput("variablesUi"),
        
        # button to update the data
        shiny::hr(),
        actionButton("updatebut", "Update Data"),
        br(), br(),
        p("Data was obtained from ",
          a("the United Kingdom NHS",
            href = "https://www.cancerdata.nhs.uk/",
            target = "_blank")),
        a(img(src = "PublicHealthEngland.png", 
              height="30%", width="30%",
              alt = "Public Health England"),
          target = "_blank"),
        br(), br(),
        bookmarkButton(),
        
      ),
      mainPanel = mainPanel(
        wellPanel(
          tabsetPanel(
            id = "results", type = "tabs",
            tabPanel(
              title = "Show data", id = "table", 
              br(),
              downloadButton("downloadData", "Download Table"),
              br(), 
              radioButtons(inputId = "tableViewForm",
                           label = "",
                           choices = c("Wide" = "wide", 
                                       "Long" = "long"),
                           inline = TRUE),
              br(), br(),
              tableOutput("dataTable")
            ), 
            tabPanel(
              title = "Plot data", id = "plot", 
              br(),
              downloadButton("downloadPlot", "Save Figure"),
              br(), br(),
              plotOutput("dataPlot")
            )
          )
        )
      )
    )
  )
)