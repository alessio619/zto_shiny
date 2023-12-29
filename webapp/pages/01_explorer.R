
# Page Explorer ================================================================================

page_explorer =  fluidPage(
   
   useWaiter(),
   
   fluidRow(tableOutput('texto')),
   
fluidRow( # big fluid row start
   
     column(width = 3,
            
         ## First accordion --------------------------------------------------
         accordion(
            accordion_panel(
               title = h2("Explore", style = 'font-weight: bold; color: #4C6279'),
               in_exp_select_ticker,
               in_exp_insert_ticker,             
               in_exp_dateRange,
               value = 'sth2') ### accordion panel
         ), ### accordion      
         
         br(),
         
         ## Second accordion --------------------------------------------------
         accordion(
            accordion_panel(
               title = h5("Retrieve", style = 'font-weight: bold; color: #4C6279'),
               in_exp_button_fetchTickers,
               br(), br(),
               in_exp_button_fetchFinancials,
               value = 'sth3'
            )),
         
         br(),
         
         ## Third accordion --------------------------------------------------
         accordion(
            accordion_panel(
               title = h5("Record", style = 'font-weight: bold; color: #4C6279'),
               in_exp_select_AddCompany,
               in_exp_add_company,
               br(),br(),
               in_exp_upd_company_modal,
               value = 'sth4'
            )
         ), ### accordion           

         br(),
         
         ## Fourth accordion --------------------------------------------------
         accordion(
            accordion_panel(
               title = h5('List of companies', style = 'color: #4C6279'),
               in_exp_select_list,
               in_exp_upload_ticker_list,
               value = 'sth1'
            ) ### accordion panel
         ), ### accordion
     ),         
     
     
     ## Value boxes --------------------------------------------------
     
     column(width = 9,
         card(style = 'height: 20vh; border-color: rgb(221, 221, 221);',
              card_header(in_exp_select_ticker_boxes),
              card_body(
                 ## Table
                 layout_column_wrap(
                    !!!list(
                       value_box(
                          title = "Current",
                          value = textOutput("calc_current_value"),
                          showcase = span(bs_icon("calculator", size = '1em'), style = 'padding-top: 5vh'),
                          showcase_layout = "top right",
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#4C6279"),
                          class = "border"
                       ),                       
                       value_box(
                          title = "Maximum",
                          value = textOutput("calc_max_value"),
                          showcase = span(bs_icon("graph-up", size = '1em'), style = 'padding-top: 5vh'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#6EBDAB"),
                          showcase_layout = "top right",
                          class = "border"
                       ),
                       value_box(
                          title = "Minimum",
                          value = textOutput("calc_min_value"),
                          showcase = span(bs_icon("dash-circle", size = '1em'), style = 'padding-top: 5vh'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#F29191"),
                          showcase_layout = "top right",
                          class = "border"
                       ),
                       value_box(
                          title = "Mean",
                          value = textOutput("calc_mean_value"),
                          showcase = span(bs_icon("calculator", size = '1em'), style = 'padding-top: 5vh'),
                          theme = value_box_theme(bg = "#f9f9f9", fg = "#75A5B7"),
                          showcase_layout = "top right",
                          class = "border"
                       )
                    )
                 )
              ) ### card body
         ), ### card ### card
         
         
         ## Plots --------------------------------------------------
         
         navset_card_pill(height = '56vh',
                         title = (span('Market data', style = 'color: #4C6279; font-weight: bold;')),
            nav_panel(
              title = "Historical Price",
              layout_sidebar(
                 bg = '#f9f9f9',
                 border = FALSE, 
                 height = '56vh',
                 sidebar = sidebar(title = "Price controls",
                                   position = "right", open = 'closed',
                                   in_exp_dataAgg,
                                   in_exp_dataCalc,
                                   in_exp_button_downloadPrice), ### sidebar
                 highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '40vh')
              ), ### layout sidebar,
         ), ### navpillcard  
         
         nav_panel(
            title = "Table",         
            reactableOutput(outputId = 'exp_table_tickersSeries')
      ) ### navpillcard
      
      ), ### card
      
      
      ## Tables -----------------------------------------
      
      navset_card_pill(
            height = '53vh',
            title = (span('Financials', style = 'color: #4C6279; font-weight: bold;')),
            
         nav_panel(
            title = "Statements",
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
            ),
         nav_panel(
            title = "Metrics",
            'placeholder'
            # layout_sidebar(
            #    bg = '#f9f9f9',
            #    border = FALSE, 
            #    height = '56vh',
            #    sidebar = sidebar(title = "Financial controls",
            #                      position = "right", open = 'closed',
            #                      in_exp_select_tickerTable,
            #                      in_exp_finTime,
            #                      in_exp_finType,
            #                      in_exp_button_downloadFinancials), ### sidebar
            #    reactableOutput(outputId = 'exp_table_tickersFinancials')
            #   ) ### layout sidebar
            ) ### nav panel         
          ) ### card body
         
     ) ### column     
    
    ) ### BIG FLUIDROW END

  ## END

  
  )

