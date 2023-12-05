

page_explorer =  fluidPage(
  
  ## Header
  h1('Explorer'),
  
  ## Prices Select & Plot
  fluidRow(
    ## Fetch data
    column(3,
             h5("Search companies"),
               selectInput(
                 inputId = 'selectize1',
                 label = NULL,
                 choices = euronext_data$company_name,
                 multiple = TRUE
               )
          ), ### column
    ## Plot data
    column(9,
           card(
             card_body(
               textOutput('text1'),
               highchartOutput(outputId = 'plot1', width = '100%', height = '500px')
             )
           ) ### card
    )    
    
        ), ### row
  
  ## Prices Table
  fluidRow(
    ## Table
    reactableOutput(outputId = 'table1')
  ) ### row
  
  ## END
  
  )