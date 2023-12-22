
# Page Price & Trading ================================================================================

page_financials =  'placeholder'
#    
#    fluidPage(
#    
#    ## Header
#    
#    # fluidRow(
#    #    textOutput('texto')
#    # ),
#    
#    ## Prices Select & Plot
#    fluidRow(
#       ## Fetch data
#       column(3,
#              wellPanel(style = 'min-height: 565px; background-color: rgba(108, 117, 125, 0.03);',
#                        h5("Search companies", style = 'color: #75A5B7'),
#                        in_fin_select_ticker,
#                        in_fin_insert_ticker,             
#                        br(),
#                        in_fin_button_fetchTickers,
#                        br(), br(),
#                        in_fin_button_download,
#                        br(),
#              ) ### wellpanel
#       ), ### column
#       ## Plot data
#       column(9,
#              card(style = 'min-height: 565px;',
#                   card_header(span('Ticker Financials', style = 'font-weight: bold')),
#                   card_body(
#                      'placeholder'
#                      # highchartOutput(outputId = 'exp_plot_tickersSeries', width = '100%', height = '400px')
#                   )
#              ) ### card
#       ) ### column
#    ), ### row
#       
#    ## Financials Table
#    fluidRow(
#       column(width = 12,
#              card(style = 'height: 525px;',
#                   card_header(span('Summary Table', style = 'color: ; font-weight: bold;')),
#                   card_body(
#                      ## Table
#                      reactableOutput(outputId = 'exp_table_tickersSeries')
#                   ) ### card body
#              ) ### card
#       ) ### column
#    ) ### row
#    
#    ## END
#    
# )   