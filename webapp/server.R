
# Inputs ================================================================================

server_app = function(input, output, session) {
   
   ## Security login -------
   
   # res_auth <- secure_server(
      # check_credentials = check_credentials(credentials)
   # )
   
   ## 01_explorer --------------------------------------------------------
   
   ### A. Retrieve Data --------------------------------------------------------
   
   ### Select ticker list -------------------
   tickers_full_list = eventReactive(input$exp_select_list, {
      engm_equities_lista = NULL  # Initialize outside the conditions
      
      if (input$exp_select_list == 'list_base') {
         engm_equities_lista = setDT(read.csv2(file.path('data', 'engm_equities_list.csv')))
      }
      
      if (input$exp_select_list == 'list_db') {
         engm_equities_lista = data.table::data.table(dbReadTable(connn, "my_companies"))
         engm_equities_lista = engm_equities_lista[, .(name_company =  company_name, code_ticker = company_id)]
      }      
      
      if (input$exp_select_list == 'list_upload') {
         if (!is.null(input$exp_upload_tickerlist$datapath)) {
            engm_equities_lista = fread(input$exp_upload_tickerlist$datapath)
         } else {
            showNotification("Attention: No data uploaded", type = "error")
         }
      }
      
      return(engm_equities_lista)
   })
   
   
   ### Update selector from the accordion
   observe({
      req(tickers_full_list())
      x = tickers_full_list()$name_company
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_ticker',
                        label = NULL,
                        choices = unique(x))
   })
   
   ### Update selector from the table
   observe({
      
      req(tickers_full_list())
      
      ita_list = tickers_full_list()[name_company %in% input$exp_select_ticker]$code_ticker
      full_list = c(ita_list, strsplit(toupper(toupper(input$exp_insert_ticker)), ";")[[1]])
      
      if (is.null(full_list))
         full_list = character(0)
      updateSelectInput(session, 'exp_select_tickerTable',
                        label = NULL,
                        choices = unique(full_list)
      )
   })   
   
   
   
   ### Find Tickers from Names -----
   ticker_list = eventReactive(input$exp_button_fetchTickers | input$exp_button_fetchFinancials, {

      req(tickers_full_list())
      ita_list = tickers_full_list()[name_company %in% input$exp_select_ticker]$code_ticker
      full_list = c(ita_list, strsplit(toupper(input$exp_insert_ticker), ";")[[1]])
      return(full_list)

   })
   
   ### Update selector from the accordion
   observe({
      req(ticker_list())
      x = ticker_list()
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_AddCompany',
                        label = NULL,
                        choices = unique(x))
   })   
   
   
   
   ###  Historical Price ---------------------------------------------------------
   
   ### Fetch and Retrieve Tickers Data
   dt_fetchedTickers = eventReactive(input$exp_button_fetchTickers, {
      
      req(ticker_list())
      
      w$show()
      
      dt_sym_wk = fetch_tickers(TICKERS = ticker_list(),
                                INIT_DATE = input$exp_dateRange[1],
                                END_DATE = input$exp_dateRange[2])
      
      on.exit({
         w$hide()
      })
      
      return(dt_sym_wk)
      
   })
   

   observe({
      
      historical_data_list$available = unique(dt_fetchedTickers()$ticker)
      
   })
      
   ### Calculations from HP --------
   dt_tickersAgg = reactive({
      
      req(dt_fetchedTickers())
      
      dtw = copy(dt_fetchedTickers())
      
      xtw = calc_agg(DT = dtw)
      
      xts = xtw[input$exp_dataAgg][[1]]
      xts_names = xtw['list_names'][[1]][[1]]
      xts_names_na = xtw['list_names'][[1]][[2]]
      dtw = as.data.table(xts)
      
      ### roll mean
      if(input$exp_dataCalc == 'calc_price') {
         xtss = copy(xts)
         dts = as.data.table(xtss)
         dts[, (xts_names_na) := lapply(.SD, function(x) fifelse(x == 0, NA_integer_, 1)), .SDcols = xts_names_na]
         prefixes = unique(gsub("_NA$", "", names(dts)[-1]))
         for (prefix in prefixes) {
            dts[, (prefix) := get(prefix) * get(paste0(prefix, "_NA"))]
            dts[, (paste0(prefix, "_NA")) := NULL]
         }
         dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
         dts[, value := round(value, digits = 2)]
      }
      if(input$exp_dataCalc == 'calc_ret') {
         xtss = PerformanceAnalytics::Return.calculate(xts, method = 'log')
         dts = as.data.table(xtss)
         dts = cbind(dts[, .(index)], dts[, ..xts_names], dtw[, ..xts_names_na])
         dts[, (xts_names_na) := lapply(.SD, function(x) fifelse(x == 0, NA_integer_, 1)), .SDcols = xts_names_na]
         prefixes = unique(gsub("_NA$", "", names(dts)[-1]))
         for (prefix in prefixes) {
            dts[, (prefix) := get(prefix) * get(paste0(prefix, "_NA"))]
            dts[, (paste0(prefix, "_NA")) := NULL]
         }
         dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
         dts[, value := round(value, digits = 2)]
      }
      if(input$exp_dataCalc == 'calc_cum_ret') {
         xtw_ret = PerformanceAnalytics::Return.calculate(xts, method = 'log')
         xtw_ret = na.omit(xtw_ret)
         xtss = apply(xtw_ret, 2, cumsum)
         indexx = zoo::index(xtss)
         dts = as.data.table(xtss)
         dts[, (xts_names_na) := NULL]
         dts$index = indexx
         dts = melt(dts, id.vars = 'index', variable.name = 'ticker', value.name = 'value')
         dts[, value := round(value, digits = 2)]
      } 
      
      return(dts)
      
   })
   
   observe({
      x = dt_tickersAgg()$ticker
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_ticker_boxes',
                        label = NULL,
                        choices = unique(x),
                        selected = head(unique(x), 1)
      )
   })
   
   ### Value boxes HP --------
   output$calc_max_value = renderText({
      req(dt_tickersAgg())
      round(max(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })
   
   output$calc_min_value = renderText({
      req(dt_tickersAgg())
      round(min(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })
   
   output$calc_mean_value = renderText({
      req(dt_tickersAgg())
      round(mean(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, na.rm = TRUE), digits = 2)
   })   

   output$calc_current_value = renderText({
      req(dt_tickersAgg())
      round(tail(dt_tickersAgg()[ticker == input$exp_select_ticker_boxes]$value, 1), digits = 2)
   })   
   
   
   ### Plot HP -------------
   output$exp_plot_tickersSeries = renderHighchart({
     
      req(dt_tickersAgg())
     
      hchart(dt_tickersAgg(),
             "line",
             hcaes(x = index, y = value, group = ticker)) |> 
         hc_xAxis(title = '', lineWidth = 0) |> 
         hc_yAxis(title = '')  |> 
         hc_legend(align = "left", verticalAlign = "top", layout = "horizontal") |> 
         hc_tooltip(table = TRUE)
    
  })
   
   
   ### Calculations HP -------------
   dt_tickersTable = reactive({
      
      req(dt_fetchedTickers())
      
      dtw = copy(dt_fetchedTickers())
      xtw = calc_agg(DT = dtw)
      xtw = xtw[input$exp_dataAgg][[1]]
      
      ### Returns
      xtw_ret = PerformanceAnalytics::Return.calculate(xtw, method = 'log')
      xtw_ret[is.na(xtw_ret)] = 0
      xtw_ret_cum = apply(xtw_ret, 2, cumsum)
      indexx = zoo::index(xtw_ret)
      
      dts_p = as.data.table(xtw)
      dts_r = as.data.table(xtw_ret)
      dts_rc = as.data.table(xtw_ret_cum)
      dts_rc$index = indexx
      
      dts_p = melt(dts_p, id.vars = 'index', variable.name = 'ticker', value.name = 'price')
      dts_r = melt(dts_r, id.vars = 'index', variable.name = 'ticker', value.name = 'return')
      dts_rc = melt(dts_rc, id.vars = 'index', variable.name = 'ticker', value.name = 'return_cum')
      
      dts = Reduce(function(x, y) merge(x, y, by = c("index", 'ticker')), list(dts_p, dts_r, dts_rc))
      setDT(dts)   
      dts[, (c('price', 'return', 'return_cum')) := lapply(.SD, function(x) round(x, 2)), .SDcols = c('price', 'return', 'return_cum')]
      
      return(dts)
      
   })
   
   ### Table HP -------------
   output$exp_table_tickersSeries = renderReactable({
      
      req(dt_tickersTable())
      
      DTW = copy(dt_tickersTable())
      setnames(DTW, old = names(DTW), new = toupper(names(DTW)))
      
      reactable(DTW,
                highlight = TRUE,
                outlined = FALSE,
                compact = TRUE,
                wrap = FALSE,
                defaultPageSize = 12,
                columns = list(
                   TICKER = colDef(
                      filterable = TRUE))
      )
      
   })
   
   
   ### Download HP ---------
   output$exp_button_downloadPrice = downloadHandler(
      
      filename = function() {
         # Use the selected dataset as the suggested file name
         paste0('dataset-price-', input$exp_select_tickerTable, ".csv")
      },
      content = function(file) {
         # Write the dataset to the `file` that will be downloaded
         write.csv(dt_tickersTable(), file)
      }
   )   
   
   
   
   ### Fetch Financial Data ---------------------------------------------------------
   
   w = Waiter$new(
      html = spin_3(),
         # span("Retrieving financial data...", style = 'font-size: 1.5em; font-weight: bold; padding-left: 1.5vh;')
      color = transparent(.5)
   )   
   
   
   ### Fetch and Retrieve Tickers Data
   dt_fetchedFinancials = eventReactive(input$exp_button_fetchFinancials, {
      
      req(ticker_list())
      
      w$show()
      
      list_ticker = get_statements(ticker_list())
      
      on.exit({
         w$hide()
      })
      
      return(list_ticker)
      
   })
   
   observe({
      
      financial_data_list$available = unique(names(dt_fetchedFinancials()))
      
   })
   
   
   ### Update selector
   observe({
      
      req(dt_fetchedFinancials())
      
      x = names(dt_fetchedFinancials())      
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'exp_select_tickerTable',
                        label = NULL,
                        choices = unique(x),
                        selected = head(x, 1)
      )
   })   
   
   
   ### Table FD ---------
   dt_table_tickersFinancials = reactive({
      
      req(dt_fetchedFinancials())
      
      DT = copy(dt_fetchedFinancials())
      
      DTS = DT[[input$exp_select_tickerTable]]
      # DTS = DT[[1]]
      
      if(input$exp_finTime == 'table_yearly') {

         if(input$exp_finType == 'table_type_bs') {DTW = copy(DTS[['bs_y']])}
         if(input$exp_finType == 'table_type_in') {DTW = copy(DTS[['in_y']])}
         if(input$exp_finType == 'table_type_cs') {DTW = copy(DTS[['cs_y']])}

      } else if(input$exp_finTime == 'table_quarterly') {
         
         if(input$exp_finType == 'table_type_bs') {DTW = data.table(EMPTY = 'NO DATA')}
         if(input$exp_finType == 'table_type_in') {DTW = copy(DTS[['in_q']])}
         if(input$exp_finType == 'table_type_cs') {DTW = copy(DTS[['cs_q']])}

      }
      
      return(DTW)

   })
   
   
   ### Table Retrieved companies financial data
   output$exp_table_tickersFinancials = renderReactable({
      
      req(dt_table_tickersFinancials())
      
      DTW = copy(dt_table_tickersFinancials())
      # setnames(DTW, old = names(DTW), new = toupper(names(DTW)))
      
      reactable(DTW,
                highlight = TRUE,
                outlined = FALSE,
                compact = TRUE,
                wrap = FALSE,
                defaultPageSize = 12)
      
   })
   
   ### Download FD ---------
   output$exp_button_downloadFinancials= downloadHandler(
      
      filename = function() {
         # Use the selected dataset as the suggested file name
         paste0('dataset-financial-', input$exp_select_tickerTable, ".csv")
      },
      content = function(file) {
         # Write the dataset to the `file` that will be downloaded
         write.csv(dt_table_tickersFinancials(), file)
      }
   ) 
   
   
   ### B. Add company --------------------------------------------------------
   
   
   observeEvent(input$exp_add_company, {
      x = ticker_list()
      updateTextInput(session, 'exp_companySymbolInput', value = unique(input$exp_select_AddCompany))
   })   
   
   
   observeEvent(input$exp_add_company, {
      
      ## for later
      in_companies = dt_con_companies()[company_id %in% input$exp_select_AddCompany]$company_id
      
      if(identical(in_companies, character(0))) {
         
         showModal(
            modalDialog(
               id = "exp_addCompanyModal",
               title = "Add Company",
               exp_companySymbolInput,
               exp_companyNameInput,
               exp_industryInput,
               exp_marketInput,
               exp_headquartersInput,
               exp_foundedYearInput,
               exp_statusInput,
               in_exp_data2add,
               footer = tagList(
                  in_exp_add_company_modal,
                  modalButton("Dismiss")
               )
            )
         )
         
      } else if(input$exp_select_AddCompany %in% in_companies) {
         
         showModal(
            modalDialog(title = "Attention!", 'Duplication is not allowed. $TICKER already in DB.',
                        easyClose = TRUE)
         )
         
      } 
   })
   
   
   ### New company data ---------
   
   observeEvent(input$exp_addCompanyBtn, {
      # Retrieve values from inputs
      
      dt_database_mc = dt_con_companies()
      
      new_data_mc = data.table(
         company_id = input$exp_companySymbolInput,
         company_name = input$exp_companyNameInput,
         industry = input$exp_industryInput,
         market = input$exp_marketInput,
         headquarters = input$exp_headquartersInput,
         founded_year = input$exp_foundedYearInput,
         status = input$exp_statusInput,
         historical_data =  'No Data',
         historical_data_update =  NA_character_,
         financial_data =  'No Data',
         financial_data_update =  NA_character_,
         ratios_data =  'No Data',
         ratios_data_update =  NA_character_
      )
      
      w$show()
      
      # Insert a new row into the my_companies table
      dt_database_mc = rbind(dt_database_mc, new_data_mc)
      dt_database_mc = dt_database_mc[!is.na(dt_database_mc$company_id)]
      
      #### Export
      saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
      
      if(input$exp_data2add == 'exp_add_data_market') {
         
         dt_database_hp = dt_con_historicaldata()

         #### Prepare data
         new_records_hp = dt_fetchedTickers()[ticker == input$exp_select_AddCompany]
         new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = round(adjusted, 2), volume = round(volume, 2))]
         
         #### Add the data to the DB
         dt_database_hp = rbind(dt_database_hp, new_records_hp)
         dt_database_hp = dt_database_hp[!is.na(dt_database_hp$company_id)]
         
         #### Update date on my_companies
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data_update = as.character(Sys.Date())
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data = 'View Data'
         
         #### Export
         saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
         
         showNotification(paste('Historical data added to', input$exp_select_AddCompany), type = 'warning')

      } else if(input$exp_data2add == 'exp_add_data_financial') {
            
         dt_database_fd = dt_con_financialdata()

         #### Prepare data
         new_records_fd = record_statements(dt_fetchedFinancials(), input$exp_select_AddCompany)
         new_records_fd[, index := as.character(Sys.Date())]
         
         #### Add the data to the DB
         dt_database_fd = rbind(dt_database_fd, new_records_fd)
         dt_database_fd = dt_database_fd[!is.na(dt_database_fd$company_id)]
         
         #### Update date on my_companies
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data_update = as.character(Sys.Date())
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data = 'View Data'
         
         #### Export
         saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))


         showNotification(paste('Financial data added to', input$exp_select_AddCompany), type = 'warning')


      } else if(input$exp_data2add == 'exp_add_data_both') {

         dt_database_hp = dt_con_historicaldata()
         
         #### Prepare data
         new_records_hp = dt_fetchedTickers()[ticker == input$exp_select_AddCompany]
         new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = round(adjusted, 2), volume = round(volume, 2))]
         
         #### Add the data to the DB
         dt_database_hp = rbind(dt_database_hp, new_records_hp)
         dt_database_hp = dt_database_hp[!is.na(dt_database_hp$company_id)]
         
         #### Update date on my_companies
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data_update = as.character(Sys.Date())
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data = 'View Data'
         
         #### Export
         saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))

         dt_database_fd = dt_con_financialdata()
         
         #### Prepare data
         new_records_fd = record_statements(dt_fetchedFinancials(), input$exp_select_AddCompany)
         new_records_fd[, index := as.character(Sys.Date())]
         
         #### Add the data to the DB
         dt_database_fd = rbind(dt_database_fd, new_records_fd)
         dt_database_fd = dt_database_fd[!is.na(dt_database_fd$company_id)]
         
         #### Update date on my_companies
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data_update = as.character(Sys.Date())
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data = 'View Data'
         
         #### Export
         saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))


         showNotification(paste('Historical and Financial data added for', input$exp_select_AddCompany), type = 'warning')

      } else {
         print('None')
      }
      
      on.exit({
         w$hide()
      })
      
      removeModal()
      
   })
   
   
   ### Add Data to company (if avaialable) -----
   
   historical_data_list = reactiveValues(available = c(NA))
   financial_data_list = reactiveValues(available = c(NA))
   
   tickers_data_available = reactiveValues(tickers_hd = c(NA),
                                           tickers_fd = c(NA))
   
   observe({
      tickers_data_available$tickers_hd = historical_data_list$available
      tickers_data_available$tickers_fd = financial_data_list$available
   })
   
   observeEvent(input$exp_add_company, {
      
      req(ticker_list())
      x = ticker_list()
      x = x[input$exp_select_AddCompany == x]
      if (is.null(x))
         x = character(0)
      
      if(any(x %in% tickers_data_available$tickers_hd) && any(!x %in% tickers_data_available$tickers_fd)) {
         
         updateRadioButtons(session, 'exp_data2add',
                            choices = c('Market' = 'exp_add_data_market', 'None' = 'exp_add_data_none'),
                            selected = 'exp_add_data_market')
         
      } else if(any(!x %in% tickers_data_available$tickers_hd) && any(x %in% tickers_data_available$tickers_fd)) {
         
         updateRadioButtons(session, 'exp_data2add',
                            choices = c('Financial' = 'exp_add_data_financial', 'None' = 'exp_add_data_none'),
                            selected = 'exp_add_data_financial')
         
      } else if(any(x %in% tickers_data_available$tickers_hd) && any(x %in% tickers_data_available$tickers_fd)) {
         
         updateRadioButtons(session, 'exp_data2add',
                            choices = c('Both' = 'exp_add_data_both', 'Market' = 'exp_add_data_market', 'Financial' = 'exp_add_data_financial', 'None' = 'exp_add_data_none'),
                            selected = 'exp_add_data_both')
         
      } else {
         
         updateRadioButtons(session, 'exp_data2add',
                            choices = c('None' = 'exp_add_data_none'),
                            selected = 'exp_add_data_none')
         
      }
      
      
   })
   
   
   ### Update Data --------------
   
   observeEvent(input$exp_updateCompanyBtn, {
      
      showModal(
         modalDialog(title = "Update Data",
                     paste0('Are you sure you want to update data for ', input$exp_select_AddCompany, ' ?'),
                     footer = tagList(
                        in_bck_update_company_modal,
                        modalButton("Dismiss")
                     ))
      )
   })
      
   
   observeEvent(input$bck_update_company_modal, {
      
      req(ticker_list())
      x = ticker_list()
      if (is.null(x))
         x = character(0)
      
      dt_database_mc = dt_con_companies()
      
      if(any(x %in% tickers_data_available$tickers_hd) && any(!x %in% tickers_data_available$tickers_fd)) {
      
      w$show()
      
      tryCatch({ 
         
         dt_database_hp = dt_con_historicaldata()
         dt_database_hp = dt_database_hp[!company_id %in% input$exp_select_AddCompany]
         
         
         #### Prepare data
         new_records_hp = dt_fetchedTickers()[ticker == input$exp_select_AddCompany]
         new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = round(adjusted, 2), volume = round(volume, 2))]
         
         #### Add the data to the DB
         dt_database_hp = rbind(dt_database_hp, new_records_hp)
         dt_database_hp = dt_database_hp[!is.na(dt_database_hp$company_id)]
         
         #### Update date on my_companies
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data_update = as.character(Sys.Date())
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data = 'View Data'
         
         #### Export
         saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
         
      }, error = function(e) {
         print('error')
      })
      
      on.exit({
         w$hide()
         showNotification(paste('Historical data updated for', input$exp_select_AddCompany), type = 'warning')
      })
      
      } else if(any(!x %in% tickers_data_available$tickers_hd) && any(x %in% tickers_data_available$tickers_fd)) {
      
         w$show()
         
      tryCatch({

         dt_database_fd = dt_con_financialdata()
         dt_database_fd = dt_database_fd[!company_id %in% input$exp_select_AddCompany]
         
         #### Prepare data
         new_records_fd = record_statements(dt_fetchedFinancials(), input$exp_select_AddCompany)
         new_records_fd[, index := as.character(Sys.Date())]
         
         #### Add the data to the DB
         dt_database_fd = rbind(dt_database_fd, new_records_fd)
         dt_database_fd = dt_database_fd[!is.na(dt_database_fd$company_id)]
         
         #### Update date on my_companies
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data_update = as.character(Sys.Date())
         dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data = 'View Data'
         
         #### Export
         saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
         
      }, error = function(e) {
         showNotification('Data already updated.', type = 'warning')         
      })
         
         showNotification(paste('Financial data updated to', input$exp_select_AddCompany), type = 'warning')
         
         on.exit({
            w$hide()
         })
         
      } else if(any(x %in% tickers_data_available$tickers_hd) && any(x %in% tickers_data_available$tickers_fd)) {
         
         w$show()
         
         tryCatch({
            
            dt_database_hp = dt_con_historicaldata()
            
            dt_database_hp = dt_database_hp[!company_id %in% input$exp_select_AddCompany]
            
            #### Prepare data
            new_records_hp = dt_fetchedTickers()[ticker == input$exp_select_AddCompany]
            new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = round(adjusted, 2), volume = round(volume, 2))]
            
            #### Add the data to the DB
            dt_database_hp = rbind(dt_database_hp, new_records_hp)
            dt_database_hp = dt_database_hp[!is.na(dt_database_hp$company_id)]
            
            #### Update date on my_companies
            dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data_update = as.character(Sys.Date())
            dt_database_mc[company_id %in% input$exp_select_AddCompany]$historical_data = 'View Data'
            
            #### Export
            saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
            saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
         
         }, error = function(e) {
            print('error')
         })
         
         tryCatch({
            
            dt_database_fd = dt_con_financialdata()
            dt_database_fd = dt_database_fd[!company_id %in% input$exp_select_AddCompany]
            
            #### Prepare data
            new_records_fd = record_statements(dt_fetchedFinancials(), input$exp_select_AddCompany)
            new_records_fd[, index := as.character(Sys.Date())]
            
            #### Add the data to the DB
            dt_database_fd = rbind(dt_database_fd, new_records_fd)
            dt_database_fd = dt_database_fd[!is.na(dt_database_fd$company_id)]
            
            #### Update date on my_companies
            dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data_update = as.character(Sys.Date())
            dt_database_mc[company_id %in% input$exp_select_AddCompany]$financial_data = 'View Data'
            
            #### Export
            saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
            saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
            
         }, error = function(e) {
            print('error')
         })
         
         showNotification(paste('Historical and Financial data updated for', input$exp_select_AddCompany), type = 'warning')
         
         on.exit({
            w$hide()
         })
         
      } else {
         
         showModal(
            modalDialog(
               title = "Update",
               "No data to update.",
               easyClose = TRUE
            ))
         
      }
      
      removeModal()
      
   })
   
   
   
   
   # 02_analyze --------------------------------------------------------
   
   
   # 00_backend --------------------------------------------------------
   
   ### Load DB
   dt_con_companies = eventReactive(c(input$bck_refresh_backend, input$exp_button_fetchTickers, input$exp_button_fetchFinancials), {
      
      dt_database_mc = readRDS(file = file.path('data', 'zto_database_my_companies.rds'))
      return(dt_database_mc)
      
   })
   
   dt_con_historicaldata = eventReactive(c(input$bck_refresh_backend, input$exp_button_fetchTickers, input$exp_button_fetchFinancials), {
      
      dt_database_hp = readRDS(file = file.path('data', 'zto_database_historical_price.rds'))
      return(dt_database_hp)
      
   })   
   
   dt_con_financialdata = eventReactive(c(input$bck_refresh_backend, input$exp_button_fetchTickers, input$exp_button_fetchFinancials), {
      
      dt_database_fd = readRDS(file = file.path('data', 'zto_database_financial_data.rds'))
      return(dt_database_fd)
      
   })      
   
   
   observeEvent(input$bck_refresh_backend, {
      
      showNotification("Data from DB refreshed.", type = 'warning')
      
   })
   
   
   
   ### Update selector
   observeEvent(c(input$bck_refresh_backend, input$exp_button_fetchTickers, input$exp_button_fetchFinancials), {
      
      x = dt_con_companies()$company_id
      if (is.null(x))
         x = character(0)
      updateSelectInput(session, 'bck_select_list',
                        choices = unique(x)
      )
   })
   
   
   ### New Company records --------------------------------------------------------
   observeEvent(input$bck_add_company, {
      
      showModal(
         modalDialog(
            id = "bck_addCompanyModal",
            title = "Add Company",
            bck_companySymbolInput,
            bck_companyNameInput,
            bck_industryInput,
            bck_marketInput,
            bck_headquartersInput,
            bck_foundedYearInput,
            bck_statusInput,
            
            footer = tagList(
               in_bck_add_company_modal,
               modalButton("Dismiss")
            )
         )
      )
   })

      
   observeEvent(input$bck_addCompanyBtn, {
      
      dt_database_mc = dt_con_companies()
      
      new_data_mc = data.table(
         company_id = input$bck_companySymbolInput,
         company_name = input$bck_companyNameInput,
         industry = input$bck_industryInput,
         market = input$bck_marketInput,
         headquarters = input$bck_headquartersInput,
         founded_year = input$bck_foundedYearInput,
         status = input$bck_statusInput,
         historical_data =  'No Data',
         historical_data_update =  NA_character_,
         financial_data =  'No Data',
         financial_data_update =  NA_character_,
         ratios_data =  'No Data',
         ratios_data_update =  NA_character_
      )
      
      # Insert a new row into the my_companies table
      dt_database_mc = rbind(dt_database_mc, new_data_mc)
      dt_database_mc = dt_database_mc[!is.na(dt_database_mc$company_id)]
      
      #### Export
      saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
      
      removeModal()
      
   })
   
   
   
   ### Delete company --------------------------------------------------------
   
   observeEvent(input$bck_delete_company, {
      
      showModal(
         modalDialog(
            title = 'Delete Permanently?',
            'All the information regarding this company will be deleted permanently.',
            footer = tagList(
               actionButton("bck_delete", label = "Delete", icon = shiny::icon("xmark"), class = 'btn-danger'), 
               modalButton("Dismiss")
            )
         ))
      })
      
      observeEvent(input$bck_delete, {
         
         dt_database_mc = copy(dt_con_companies())
         dt_database_hp = copy(dt_con_historicaldata())
         dt_database_fd = copy(dt_con_financialdata())
      
         #### Remove records
         dt_database_mc = dt_database_mc[!company_id %in% input$bck_select_list]
         dt_database_hp = dt_database_hp[!company_id %in% input$bck_select_list]
         dt_database_fd = dt_database_fd[!company_id %in% input$bck_select_list]

         #### Export
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
         saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))
         saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))
         
         removeModal()
   })
   
   
      ### Edit Company --------------------------------------------------------
      
      observeEvent(input$bck_edit_company, {
         showModal(
            modalDialog(
               id = "bck_edit_company_2",
               title = "Edit Company",
               bck_edit_companySymbolInput,
               bck_edit_companyNameInput,
               bck_edit_industryInput,
               bck_edit_marketInput,
               bck_edit_headquartersInput,
               bck_edit_foundedYearInput,
               bck_edit_statusInput,
               
               footer = tagList(
                  in_bck_edit_company_modal,
                  modalButton("Dismiss")
               )
            )
         )
      })
      
      ### Update selector
      dt_con_companies_edit = reactive({

         DTW = copy(dt_con_companies())
         DTS = DTW[company_id == input$bck_select_list]
         
         return(DTS)
         
      })
      
      observeEvent(input$bck_edit_company, {
         
         DT = dt_con_companies_edit()
         updateTextInput(session, 'edit_companySymbolInput', value = unique(DT$company_id))
         updateTextInput(session, 'edit_companyNameInput', value = unique(DT$company_name))
         updateSelectInput(session, 'edit_industryInput', choices = unique(DT$industry))
         updateSelectInput(session, 'edit_marketInput', choices = unique(DT$market))
         updateTextInput(session, 'edit_headquartersInput', value = unique(DT$headquarters))
         updateNumericInput(session, 'edit_foundedYearInput', value = unique(DT$founded_year))
         updateSelectInput(session, 'edit_statusInput', choices = unique(DT$status))
         
      })
      
      observeEvent(input$edit_bck_addCompanyBtn, {
         
         dt_database_mc = dt_con_companies()
         
         dt_database_mc[company_id == input$bck_select_list]$company_id = input$edit_companySymbolInput
         dt_database_mc[company_id == input$bck_select_list]$company_name = input$edit_companyNameInput
         dt_database_mc[company_id == input$bck_select_list]$industry = input$edit_industryInput
         dt_database_mc[company_id == input$bck_select_list]$market = input$edit_marketInput
         dt_database_mc[company_id == input$bck_select_list]$headquarters = input$edit_headquartersInput
         dt_database_mc[company_id == input$bck_select_list]$founded_year = input$edit_foundedYearInput
         dt_database_mc[company_id == input$bck_select_list]$status = input$edit_statusInput
         
         #### Export
         saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))
         
         removeModal()
      })   
   
    
   output$bck_table_db = renderReactable({
      
      dtw = dt_con_companies()
      
      reactable(
         dtw,
         highlight = TRUE,
         filterable = TRUE,
         outlined = FALSE,
         compact = TRUE,
         wrap = FALSE,
         defaultPageSize = 20,
         columns = list(
            company_id = colDef(name = "ID"),
            company_name = colDef(name = "Name"),
            industry = colDef(name = "Industry"),
            market = colDef(name = "Market"),
            headquarters = colDef(name = "HQ"),
            founded_year = colDef(name = "Founded"),
            status = colDef(name = "Status"),
            historical_data = colDef(name = "Historical", cell = button_extra("bck_button_table_hc", class = "btn btn-primary")),
            historical_data_update = colDef(name = "Last update"),
            financial_data = colDef(name = "Financial", cell = button_extra("bck_button_table_fd", class = "btn btn-primary")),
            financial_data_update = colDef(name = "Last update"),
            ratios_data = colDef(name = "Ratios", cell = button_extra("bck_button_table_rt", class = "btn btn-primary")),
            ratios_data_update = colDef(name = "Last update")
         )
      )
   })
   
   
   dt_con_id_hc = reactive({
      
      company_id = dt_con_companies()[input$bck_button_table_hc$row, ]$company_id
      company_id
      
   })
   
   dt_con_id_fd = reactive({
      
      company_id = dt_con_companies()[input$bck_button_table_fd$row, ]$company_id
      company_id
      
   })
   

   dt_con_historicaldata_table = reactive({
      dt_con_historicaldata()[company_id %in% dt_con_id_hc()]
   })

   dt_con_financialdata_table = reactive({
      dt_con_financialdata()[company_id == dt_con_id_fd()]
   })

   ### Download Company Historical Data
   output$bck_button_downloadPrice = downloadHandler(

      filename = function() {
         # Use the selected dataset as the suggested file name
         paste0('dataset-price-', dt_con_id_hc(), ".csv")
      },
      content = function(file) {
         # Write the dataset to the `file` that will be downloaded
         write.csv(dt_con_historicaldata_table(), file)
      }
   )

   output$bck_button_downloadFinancial = downloadHandler(

      filename = function() {
         # Use the selected dataset as the suggested file name
         paste0('dataset-financials-', dt_con_id_fd(), ".csv")
      },
      content = function(file) {
         # Write the dataset to the `file` that will be downloaded
         write.csv(dt_con_financialdata_table(), file)
      }
   )

   observeEvent(input$bck_button_table_hc, {
      showModal(modalDialog(
         title = "Selected row data",

         if(!is.null(dt_con_historicaldata_table())) {
            reactable(dt_con_historicaldata_table(),
                      highlight = TRUE,
                      filterable = TRUE,
                      outlined = FALSE,
                      compact = TRUE,
                      wrap = FALSE,
                      defaultPageSize = 20)
            },

         size = 'l',
         easyClose = TRUE,
         footer = tagList(
            if(!is.null(dt_con_historicaldata_table())) {in_bck_button_downloadPrice},
            modalButton("Dismiss")
         )

      ))
   })

   observeEvent(input$bck_button_table_fd, {
      showModal(modalDialog(
         title = "Selected row data",

         if(!is.null(dt_con_financialdata_table())) {
            reactable(dt_con_financialdata_table(),
                      highlight = TRUE,
                      filterable = TRUE,
                      outlined = FALSE,
                      compact = TRUE,
                      wrap = FALSE,
                      defaultPageSize = 20)
            },

         size = 'l',
         easyClose = TRUE,
         footer = tagList(
            if(!is.null(dt_con_financialdata_table())) {in_bck_button_downloadFinancial},
            modalButton("Dismiss")
         )

      ))
   })
   
   
   ## Backup ----------------------------------
   
   output$bck_button_backup = downloadHandler(
      
      filename = function() {
         "backup_db.zip"
      },
      
      content = function(file) {
         # Create temporary files
         temp_files <- sapply(1:3, function(x) tempfile(fileext = ".csv"))
         
         # Write data frames to temporary files
         fwrite(dt_con_companies(), temp_files[1])
         fwrite(dt_con_historicaldata(), temp_files[2])
         fwrite(dt_con_financialdata(), temp_files[3])
         
         names(temp_files) <- c("my_companies.csv", "historical_price.csv", "financial_data.csv")
         
         # Zip the files
         zip(file, files = temp_files, extras = "-j")
         
      }
   )
   

   ## END --------------
   
   
   # output$texto3 = renderTable({
   #    dt_con_historicaldata_table()
   # })
   

   # output$texto = renderPrint({
   # 
   #    req(ticker_list())
   #    x = ticker_list()
   #    x = x[input$exp_select_AddCompany == x]
   #    if (is.null(x))
   #       x = character(0)
   # 
   # 
   #    x %in% tickers_data_available$tickers_hd && !x %in% tickers_data_available$tickers_fd
   # 
   # })
  
}
