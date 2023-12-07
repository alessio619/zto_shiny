
# Page Explorer ================================================================================

page_explorer =  fluidPage(

  ## Header
  h2('Explorer'), hr(),

  ## Prices Select & Plot
  fluidRow(
    ## Fetch data
    column(3,
           wellPanel(style = 'height: 500px; background-color: rgba(108, 117, 125, 0.03);',
             br(),
             h5("Search companies", style = 'color: #75A5B7'),
               in_exp_select_ticker,
             br(),
             h5("Select date range", style = 'color: #75A5B7'),
               in_exp_dateRange,
             br(),
             h5("Time granularity", style = 'color: #75A5B7'),
               in_exp_dataType,
             br(),
               in_exp_button_fetchTickers,
             br(), br(),
               in_exp_button_download,
             br()
           ) ### wellpanel
          ), ### column
    ## Plot data
    column(9,
           card(style = 'height: 500px;',
             card_header(span('Ticker Prices', style = 'font-weight: bold')),
             card_body(
               highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '400px')
             )
           ) ### card
    )

        ), ### row

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