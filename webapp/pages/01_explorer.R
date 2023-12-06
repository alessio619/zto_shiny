
# Page Explorer ================================================================================

page_explorer =  fluidPage(

  ## Header
  h1('Explorer'),

  ## Prices Select & Plot
  fluidRow(
    ## Fetch data
    column(3,
           wellPanel(
             h5("Search companies"),
               in_exp_select_ticker,
               in_exp_button_fetchTickers
           ) ### wellpanel
          ), ### column
    ## Plot data
    column(9,
           card(
             card_body(
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