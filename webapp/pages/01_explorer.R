
# Page Price & Trading ================================================================================

page_explore =  fluidPage(
   
   useWaiter(),
   useAttendant(),
   attendantBar("progress-bar"),
   
   fluidRow(textOutput('texto')),
   
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
               title = h5("Search companies", style = 'font-weight: bold; color: #4C6279'),
               in_exp_select_ticker,
               in_exp_insert_ticker,             
               in_exp_dateRange,
               value = 'sth2') ### accordion panel
         ), ### accordion
         br(),
         card(style = 'border-color: rgb(221, 221, 221);',
            in_exp_button_fetchTickers,
            in_exp_button_fetchFinancials
         ) ### card
     ),         
     
     
     ## Value boxes --------------------------------------------------
     
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
                       ),
                       value_box(
                          title = "Minimum",
                          value = textOutput("calc_min_value"),
                          showcase = bs_icon("dash-circle", size = '0.5em'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#F29191"),
                          showcase_layout = "top right",
                          class = "border"
                       ),
                       value_box(
                          title = "Mean",
                          value = textOutput("calc_mean_value"),
                          showcase = bs_icon("calculator", size = '0.5em'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#75A5B7"),
                          showcase_layout = "top right",
                          class = "border"
                       ),
                       value_box(
                          title = "Median",
                          value = textOutput("calc_median_value"),
                          showcase = bs_icon("calculator", size = '0.5em'),
                          showcase_layout = "top right",
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#4C6279"),
                          class = "border"
                       )
                    )
                 )
              ) ### card body
         ), ### card ### card
         
         
         ## Plots --------------------------------------------------
         
         navset_card_pill(height = '56vh',
                         title = (span('Plots', style = 'color: #4C6279; font-weight: bold;')),
            nav_panel(
              title = "Price",
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
         #    layout_sidebar(
         #       bg = '#f9f9f9',
         #       border = FALSE, 
         #       height = '56vh',
         #       sidebar = sidebar(title = "Financial controls",
         #                         position = "right", open = 'closed',
         #                         in_exp_finTime,
         #                         in_exp_finType), ### sidebar
         #      
         # ) ### layout sidebar
         'placeholder'
      ) ### navpillcard
      
      ), ### card
      
      
      ## Tables -----------------------------------------
      
      navset_card_pill(
            height = '53vh',
            title = (span('Tables', style = 'color: #4C6279; font-weight: bold;')),
            
         nav_panel(
            title = "Price",
            layout_sidebar(
               bg = '#f9f9f9',
               border = FALSE, 
               height = '56vh',
               sidebar = sidebar(title = "Price controls",
                                 position = "right", open = 'closed',
                                 in_exp_button_downloadPrice),
               reactableOutput(outputId = 'exp_table_tickersSeries')
              )
            ),
         nav_panel(
            title = "Financials",
            layout_sidebar(
               bg = '#f9f9f9',
               border = FALSE, 
               height = '56vh',
               sidebar = sidebar(title = "Financial controls",
                                 position = "right", open = 'closed',
                                 in_exp_select_tickerTable,
                                 in_exp_finTime,
                                 in_exp_finType,
                                 in_exp_button_downloadFinancials), ### sidebar
               reactableOutput(outputId = 'exp_table_tickersFinancials')
              ) ### layout sidebar
            ) ### nav panel         
          ) ### card body
         
     ) ### column     
    
    ) ### BIG FLUIDROW END

  ## END

  
  )

