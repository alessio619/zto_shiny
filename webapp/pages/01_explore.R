
# Page Price & Trading ================================================================================

page_explore =  fluidPage(
   
fluidRow( # big fluid row start
   
     column(width = 3,
            
         ## First accordion --------------------------------------------------
            accordion(
               accordion_panel(
                  title = h2('Explore', style = 'color: #4C6279'),
                  in_exp_select_list,
                  in_exp_upload_ticker_list,
                  value = 'sth1'
               ) ### accordion panel
         ), ### accordion
         
         br(),
         
         ## Second accordion --------------------------------------------------
         accordion(
            accordion_panel(
               title = h5("Search companies", style = 'font-weight: bold; color: #75A5B7'),
               in_exp_select_ticker,
               in_exp_insert_ticker,             
               in_exp_dateRange,
               value = 'sth2') ### accordion panel
         ), ### accordion
         br(),
         card(style = 'border-color: rgb(221, 221, 221);',
            in_exp_button_fetchTickers,
            in_exp_button_selectTickers,
            in_exp_button_download
         ) ### card
     ),         
         
     column(width = 9,
         card(style = 'height: 27vh; border-color: rgb(221, 221, 221);',
              card_header(in_exp_select_ticker_boxes),
              card_body(
                 ## Table
                 layout_column_wrap(
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
         ), ### card ### card
         
         navset_card_pill(height = '56vh',
                         title = (span('Ticker Prices', style = 'font-weight: bold')),
                         # style = 'border-color: rgb(221, 221, 221);',
            nav_panel(
              title = "Price",
         # card(style = 'min-height: 56vh; border-color: rgb(221, 221, 221);',
              layout_sidebar(
                 bg = '#f9f9f9',
                 border = FALSE, 
                 height = '56vh',
                 sidebar = sidebar(title = "Price controls",
                                   position = "right", open = 'closed',
                                   in_exp_dataAgg,
                                   in_exp_dataCalc), ### sidebar
                 highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '40vh')
              ), ### layout sidebar,
         ), ### navpillcard  
         
         nav_panel(
            title = "Financials",         
            layout_sidebar(
               bg = '#f9f9f9',
               border = FALSE, 
               height = '56vh',
               sidebar = sidebar(title = "Financial controls",
                                 position = "right", open = 'closed',
                                 'placeholder1',
                                 'placeholder2'), ### sidebar
              'placeholder'
            # highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '40vh')
         ) ### layout sidebar
         
      ) ### navpillcard
      
      ) ### card
         
     ) ### column     
    
    ), ### BIG FLUIDROW END

  br(),

  ## Prices Table
  fluidRow(
    column(width = 12,
     card(style = 'height: 52vh; border-color: rgb(221, 221, 221);',
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

