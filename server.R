source("helper.R")

cancer_longer <- getData()

shinyServer(function(input, output, session){
  # =========== BUILDING Input ===========
  output$cancerTypeUi <- renderUI({
    selectizeInput("tumourtype", "",
                   unique(cancer_longer$TumourSite),
                   selected = NULL, multiple = TRUE,
                   options = list(placeholder = "Select tumour types"))
  })
  output$variablesUi <- renderUI({
    selectizeInput("variables", "",
                   unique(cancer_longer$State),
                   selected = unique(cancer_longer$State), 
                   multiple = TRUE,
                   options = list(placeholder = "Select variables"))
  })
  
  # =========== FILTER DATA ===========
  update_data <- reactive({
    input$updatebut
    
    data <- cancer_longer
    
    isolate({
      
      # filter year
      data <- data %>%  
        filter(Year >= input$year[1] & Year <= input$year[2])
      
      # filter tumoursites
      if (input$tumoursites == "specific" & !is.null(input$tumourtype)) {
        data <- data %>% filter(TumourSite %in% input$tumourtype)
      }
      
      # filter variables
      if (!is.null(input$variables)) {
        data <- data %>% filter(State %in% input$variables)
      }
      
    })
    data
  })
  
  # Change the table depends on format which is long or wide
  table_data <- reactive({
    data <- update_data()
    data <- data %>% 
      mutate(Values = formatC(Values, format = "fg", digits = 2))		
    
    # Change the data to wide format if the user wants it
    if (input$tableViewForm == "wide") {
      data <- data %>% 
        spread(State, Values)
    }
    data
  })
  
  # =========== SHOW THE TABLE =========== 
  output$dataTable <- renderTable(
    {
      table_data()
    },
    include.rownames = FALSE
  )
  
  # =========== DOWNLOAD THE TABLE ===========
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("cancerData-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(table_data(), file)
    }
  )
  
  # =========== SHOW THE PLOT =========== 
  buildPlot <- reactive({
    
    plot <- ggplot(update_data()) +
      aes(x = Year, y = Values,
          color = TumourSite) + 
      facet_wrap(vars(State), scales = "free_y", ncol = 3) +
      geom_point() +
      scale_x_continuous(breaks = scales::pretty_breaks()) +
      geom_line(show.legend = FALSE) + 
      theme(axis.text.x = element_text(angle = 90, 
                                       hjust = 1, 
                                       vjust = 0.5), 
            strip.text.x = element_text(size = 12)) + 
      theme(legend.position = "bottom") +
      guides(color = guide_legend(title = "",
                                  nrow = 6)) +
      xlab("Year") + ylab("") +
      theme(panel.grid.minor = element_blank(),
            panel.grid.major.x = element_blank())
    plot
    
  })
  
  output$dataPlot <-
    renderPlot(
      {
        buildPlot()
      },
      height = 600,
      width = "auto",
      units = "px", 
      res = 100
    )
  
  # =========== DOWNLOAD THE PLOT ===========
  output$downloadPlot <- downloadHandler(
    filename = function() {
      "cancerDataPlot.pdf"
    },
    
    content = function(file) {
      pdf(file,
          width = 12,
          height = 12)
      print(buildPlot())
      dev.off()
    }
  )
})