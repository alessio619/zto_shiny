
# Page Price & Trading ================================================================================

page_price =  fluidPage(

  ## Header
   
   # fluidRow(
   #    textOutput('texto')
   # ),
   
  fluidRow( 
     column(width = 3,
         card(style = 'max-height: 22vh; min-height: 22vh;',
            h2('Price & Trading'),
            in_exp_select_list,
            in_exp_upload_ticker_list
         ) ### card
     ), ### column
     column(width = 9,
         card(style = 'max-height: 22vh; min-height: 22vh;',
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
           wellPanel(style = 'min-height: 56vh; background-color: rgba(108, 117, 125, 0.03);',
             h5("Search companies", style = 'color: #75A5B7'),
               in_exp_select_ticker,
             in_exp_insert_ticker,             
               in_exp_dateRange,
             br(),
               in_exp_button_fetchTickers,
             br(), br(),
             in_exp_dataAgg,
             in_exp_dataCalc,       
             br(),
               in_exp_button_download,
             br(),
           ) ### wellpanel
          ), ### column
    ## Plot data
    column(9,
           card(style = 'min-height: 56vh;',
             card_header(span('Ticker Prices', style = 'font-weight: bold')),
             card_body(
               highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '40vh')
             )
           ) ### card
    )

        ), ### row
  
  br(),

  ## Prices Table
  fluidRow(
    column(width = 12,
     card(style = 'height: 52vh;',
          card_header(span('Summary Table', style = 'color: ; font-weight: bold;')),
          card_body(
            ## Table
            reactableOutput(outputId = 'exp_table_tickersSeries')
          ) ### card body
     ) ### card
    ) ### column
  ) ### row

  ## END

  )