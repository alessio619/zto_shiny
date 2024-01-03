
# DB Management ================================================================================


# Load the RSQLite package
library(data.table)
source(file.path('webapp', 'financial.R'))


# 1. Create database --------------------------------------------------------------------------

exp_select_AddCompany = c('MELI')


### My companies
dt_database_mc = data.table(
   company_id = NA_character_,
   company_name = NA_character_,
   industry =  NA_character_,
   market =  NA_character_,
   headquarters =  NA_character_,
   founded_year =  NA_integer_,
   status =  NA_character_,
   historical_data =  NA_integer_,
   historical_data_update =  NA_integer_,
   financial_data =  NA_integer_,
   financial_data_update =  NA_integer_,
   ratios_data =  NA_integer_,
   ratios_data_update =  NA_integer_
)

setkey(dt_database_mc, 'company_id')
saveRDS(dt_database_mc, file = file.path('data', 'zto_database_my_companies.rds'))


### Historical price
dt_database_hp = data.table(
   company_id = NA_character_,
   index = NA_character_,
   closing =  NA_complex_,
   volume =  NA_complex_
)

setkeyv(dt_database_hp, cols = c('company_id', 'index'))
saveRDS(dt_database_hp, file = file.path('data', 'zto_database_historical_price.rds'))


### Financial data
dt_database_fd = data.table(
   company_id = NA_character_,
   index = NA,
   stmt  = NA_character_,
   type  = NA_character_,
   voice  = NA_character_,
   time  = NA_character_,
   value  = NA_character_
)

setkeyv(dt_database_fd, cols = c('company_id', 'index', 'voice', 'time'))
saveRDS(dt_database_fd, file = file.path('data', 'zto_database_financial_data.rds'))





# 2. CRUD  --------------------------------------------------------------------------

## A. Write into the tables --------------------------------------

### New company -------
new_data_mc = data.table(
   company_id = exp_select_AddCompany,
   company_name = 'Mercado Libre',
   industry =  'TECHNOLOGICAL',
   market =  'NYSE',
   headquarters =  'Argentina',
   founded_year =  1999,
   status =  'Follow',
   historical_data =  0,
   historical_data_update =  NA_integer_,
   financial_data =  0,
   financial_data_update =  NA_integer_,
   ratios_data =  0,
   ratios_data_update =  NA_integer_
)


dt_updated_mc = rbind(dt_database_mc, new_data_mc)
dt_updated_mc = dt_updated_mc[!is.na(dt_updated_mc$company_id)]

saveRDS(dt_updated_mc, file = file.path('data', 'zto_database_my_companies.rds'))


### New historical data -------

dt_fetchedTickers = fetch_tickers(TICKERS = exp_select_AddCompany,
                                  INIT_DATE = '2021-01-01',
                                  END_DATE = Sys.Date())



new_records_hp = dt_fetchedTickers[ticker %in% exp_select_AddCompany]
new_records_hp = new_records_hp[, .(company_id = ticker, index = as.character(index), closing = adjusted, volume = volume)]

dt_updated_hp = rbind(dt_database_hp, new_records_hp)
dt_updated_hp = dt_updated_hp[!is.na(dt_updated_hp$company_id)]

saveRDS(dt_updated_hp, file = file.path('data', 'zto_database_historical_price.rds'))



### New Financial data -------

list_ticker = get_statements(exp_select_AddCompany)
list_ticker[[exp_select_AddCompany]]


new_records_fd = record_statements(list_ticker, exp_select_AddCompany)
new_records_fd[, index := as.character(Sys.Date())]

dt_updated_fd = rbind(dt_database_fd, new_records_fd)
dt_updated_fd = dt_updated_fd[!is.na(dt_updated_fd$company_id)]

saveRDS(dt_updated_fd, file = file.path('data', 'zto_database_financial_data.rds'))




## B. Delete table's record --------------------------------------------------------------------------

delete_mycompanies = paste0("DELETE FROM my_companies WHERE (company_id = '", exp_select_AddCompany, "');")
delete_historicaldata = paste0("DELETE FROM historical_price WHERE (company_id = '", exp_select_AddCompany, "');")
delete_financialdata = paste0("DELETE FROM financial_statements WHERE (company_id = '", exp_select_AddCompany, "');")

dbExecute(connn, delete_historicaldata)


### Add Historical data --------------------------------------------------------------------------

dt_fetchedTickers = fetch_tickers(TICKERS = exp_select_AddCompany,
                                  INIT_DATE = '2021-01-01',
                                  END_DATE = Sys.Date())



new_records = dt_fetchedTickers[ticker %in% exp_select_AddCompany]
new_records$index <- format(as.Date(new_records$index, format="%Y-%m-%d"), "%Y-%m-%d")

new_records = new_records[, .(company_id = ticker, date = index, closing_price = adjusted, volume = volume)]


### Insert new ----
# dbExecute(connn, insert_newhistoricaldata_query,
#           list(new_records$company_id, new_records$date, new_records$closing_price, new_records$volume))

dbWriteTable(connn, "historical_price", new_records, append = TRUE, row.names = FALSE)


dbExecute(connn, update_historical_data_date_query,
          list(as.character(Sys.Date()), exp_select_AddCompany))


### Insert Updates -----
old_records = dt_hp[company_id == exp_select_AddCompany]
max_date = max(old_records$date)
new_records = new_records[date > max_date]

dbExecute(connn, insert_newhistoricaldata_query,
          list(new_records$company_id, new_records$date, new_records$closing_price, new_records$volume))


dbExecute(connn, update_historical_data_date_query,
          list(as.character(Sys.Date()), exp_select_AddCompany))


## D. Add Financial data --------------------------------------------------------------------------

list_ticker = get_statements(exp_select_AddCompany)
list_ticker[[exp_select_AddCompany[[1]]]]


dtw = record_statements(list_ticker, exp_select_AddCompany[[1]])
dtw[, date := as.character(Sys.Date())]

tryCatch({
   # Your database operation that may result in a unique constraint violation
   dbExecute(connn, insert_newfinancialdata_query,
             list(dtw$id, dtw$company_id, dtw$date, dtw$stmt, dtw$type, dtw$voice, dtw$time, dtw$value))
   
}, error = function(e) {
   # Check if the error is related to a unique constraint violation
   if (grepl("UNIQUE constraint failed", e$message)) {
      print("Data already present.")
   } else {
      # Handle other types of errors
      stop(e)
   }
})



dbExecute(connn, update_financial_data_date_query,
          list(as.character(Sys.Date()), exp_select_AddCompany[[2]]))




## E. Check if datas available --------------------------------------------------------------------------

dbExecute(connn, update_availabledata_query)


## D. Read tables --------------------------------------------------------------------------

dtw = data.table::data.table(dbReadTable(connn, "my_companies"))
dt_hp = data.table::data.table(dbReadTable(connn, "historical_price"))
dt_fd = data.table::data.table(dbReadTable(connn, "financial_statements"))

print(dtw)


# 3. Close the database connection --------------------------------------------------------------------------
dbDisconnect(connn)


