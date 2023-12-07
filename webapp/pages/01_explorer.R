
# Page Explorer ================================================================================

page_explorer =  fluidPage(

  ## Header
  h2('Explorer'), hr(),

  ## Prices Select & Plot
  fluidRow(
    ## Fetch data
    column(3,
           wellPanel(
             br(),
             h6("Search companies", style = 'color: #4C6279'),
               in_exp_select_ticker,
             br(),
             h6("Select date range", style = 'color: #4C6279'),
               in_exp_dateRange,
             br(),
             h6("Time granularity", style = 'color: #4C6279'),
               in_exp_dataType,
             br(),
               in_exp_button_fetchTickers,
             br(),
           ) ### wellpanel
          ), ### column
    ## Plot data
    column(9,
           card(
             card_body(
                # textOutput('texto'),
               highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '500px')
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