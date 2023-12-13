
# Page Explorer ================================================================================

page_explorer =  fluidPage(

  ## Header
   
   fluidRow(
      textOutput('texto')
   ),
   
   
  fluidRow( 
     column(width = 3,
         card(style = 'max-height: 200px; min-height: 200px;',
            h2('Explorer'),
            span('Pricing data and metrics for Euronext Growth Milano'),
            in_exp_upload_ticker_list
         ) ### card
     ), ### column
     column(width = 9,
         card(style = 'max-height: 200px; min-height: 200px;',
              card_header(in_exp_select_ticker_boxes),
              card_body(
                 ## Table
                 layout_column_wrap(
                    # width = "250px",
                    !!!list(
                       value_box(
                          title = "Maximum",
                          value = textOutput("calc_max_value"),
                          showcase = bs_icon("graph-up", size = '0.5em'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#6EBDAB"),
                          showcase_layout = "top right",
                          class = "border"
                          # p("The 1st detail")
                       ),
                       value_box(
                          title = "Minimum",
                          value = textOutput("calc_min_value"),
                          showcase = bs_icon("dash-circle", size = '0.5em'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#F29191"),
                          showcase_layout = "top right",
                          class = "border"
                          # p("The 2nd detail"),
                       ),
                       value_box(
                          title = "Mean",
                          value = textOutput("calc_mean_value"),
                          showcase = bs_icon("calculator", size = '0.5em'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#75A5B7"),
                          showcase_layout = "top right",
                          class = "border"
                          # p("The 4th detail"),
                       ),
                       value_box(
                          title = "Median",
                          value = textOutput("calc_median_value"),
                          showcase = bs_icon("calculator", size = '0.5em'),
                          showcase_layout = "top right",
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#4C6279"),
                          class = "border"
                          # p("The 4th detail"),
                       )
                    )
                 )
                 # reactableOutput(outputId = 'exp_table_tickersSeries')
              ) ### card body
         ) ### card ### card
     ), ### column     
  ), ### row
  
  ## Prices Select & Plot
  fluidRow(
    ## Fetch data
    column(3,
           wellPanel(style = 'height: 565px; background-color: rgba(108, 117, 125, 0.03);',
             h5("Search companies", style = 'color: #75A5B7'),
               in_exp_select_ticker,
             h5("Type symbols", style = 'color: #75A5B7'),
             in_exp_insert_ticker,             
             h5("Select date range", style = 'color: #75A5B7'),
               in_exp_dateRange,
             br(),
               in_exp_button_fetchTickers,
             br(), br(),
             h5("Data aggregation", style = 'color: #75A5B7'),
             in_exp_dataAgg,
             h5("Calculation", style = 'color: #75A5B7'),
             in_exp_dataCalc,       
             br(),
               in_exp_button_download,
             br(),
           ) ### wellpanel
          ), ### column
    ## Plot data
    column(9,
           card(style = 'height: 565px;',
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
     card(style = 'max-height: 200px;',
          card_header(in_exp_select_ticker_boxes),
          card_body(
            ## Table
            reactableOutput(outputId = 'exp_table_tickersSeries')
          ) ### card body
     ) ### card
    ) ### column
  ) ### row

  ## END

  )