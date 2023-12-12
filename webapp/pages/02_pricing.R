
# Page Explorer ================================================================================

page_explorer =  fluidPage(

  ## Header
   
  fluidRow( 
     column(width = 12,
         card(
            h2('Explorer'),
            span('Web browse from Yahoo! Finance the latest data for the Euronext Growth Milano listed companies.')
         ) ### card
     ) ### column
  ), ### row

  ## Prices Select & Plot
  fluidRow(
    ## Fetch data
    column(3,
           wellPanel(style = 'height: 550px; background-color: rgba(108, 117, 125, 0.03);',
             br(),
             h5("Search companies", style = 'color: #75A5B7'),
               in_exp_select_ticker,
             br(),
             h5("Select date range", style = 'color: #75A5B7'),
               in_exp_dateRange,
             br(),
               in_exp_button_fetchTickers,
             br(), br(),
             h5("Data aggregation", style = 'color: #75A5B7'),
             in_exp_dataAgg,
             br(), 
               in_exp_button_download,
             br(),
           ) ### wellpanel
          ), ### column
    ## Plot data
    column(9,
           card(style = 'height: 550px;',
             card_header(span('Ticker Prices', style = 'font-weight: bold')),
             card_body(
               highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '400px')
             )
           ) ### card
    )

        ), ### row
  
  br(),

  ## Prices Table
  fluidRow(
    column(width = 12,
     card(style = 'height: 500px;',
          card_header(span('Retrieved companies information', style = 'font-weight: bold')),
          card_body(
    ## Table
    reactableOutput(outputId = 'exp_table_tickersSeries')
          ) ### card body
     ) ### card
    ) ### column
  ) ### row

  ## END

  )