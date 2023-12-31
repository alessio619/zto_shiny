
# DB Management ================================================================================


# Load the RSQLite package
library(RSQLite)
library(data.table)
library(DBI)
source(file.path('webapp', 'queries.R'))
source(file.path('webapp', 'financial.R'))


# 1. Create a connection to the SQLite database --------------------------------------------------------------------------
connn = dbConnect(SQLite(), dbname = "data/zto_database.db")

exp_select_AddCompany = 'AGA.MI'



# 2. CRUD  --------------------------------------------------------------------------

## A. Write into the tables --------------------------------------

# sample_data = data.frame(
#    id = c(1,2,3),
#    company_id = c('ITR.MI', 'BBB.MI', 'MELI'),
#    company_name = c("INTRED", "Company B", 'Mercado Libre'),
#    industry = c("Technology", "Finance", NA_character_),
#    market = c('EURONEXT.G.MI', 'EURONEXT.G.MI', NA_character_),
#    headquarters = c("Milano", "Roma", NA_character_),
#    founded_year = c(2000, 1995, NA_integer_),
#    status = c("Active", 'Pending', 'Follow'),
#    historical_data = c(0,0,0),
#    historical_data_update = c(NA_character_, NA_character_, NA_character_),
#    financial_data = c(0,0,0),
#    financial_data_update = c(NA_character_, NA_character_, NA_character_),
#    ratios_data = c(0,0,0),
#    ratios_data_update = c(NA_character_, NA_character_, NA_character_)
# )
# 
# 
# dbWriteTable(connn, "my_companies", sample_data, append = TRUE)


## B. Delete table's record --------------------------------------------------------------------------

delete_mycompanies = paste0("DELETE FROM my_companies WHERE (company_id = '", exp_select_AddCompany, "');")
delete_historicaldata = paste0("DELETE FROM historical_price WHERE (company_id = '", exp_select_AddCompany, "');")
delete_financialdata = paste0("DELETE FROM financial_statements WHERE (company_id = '", exp_select_AddCompany, "');")

dbExecute(connn, delete_financialdata)


## C. Add Historical data --------------------------------------------------------------------------

dt_fetchedTickers = fetch_tickers(TICKERS = exp_select_AddCompany,
                                  INIT_DATE = '2021-01-01',
                                  END_DATE = Sys.Date())



new_records = dt_fetchedTickers[ticker %in% exp_select_AddCompany]
new_records = new_records[, .(company_id = ticker, date = as.character(index), closing_price = adjusted, volume = volume)]

dbExecute(connn, insert_newhistoricaldata_query,
          list(new_records$company_id, new_records$date, new_records$closing_price, new_records$volume))


dbExecute(connn, update_historical_data_date_query,
          list(as.character(Sys.Date()), exp_select_AddCompany))


## D. Add Financial data --------------------------------------------------------------------------

list_ticker = get_statements(exp_select_AddCompany)

dtw = record_statements(list_ticker, exp_select_AddCompany)
dtw[, id := .I]
dtw[, date := as.character(Sys.Date())]

dbExecute(connn, insert_newfinancialdata_query,
          list(dtw$id, dtw$company_id, dtw$date, dtw$stmt, dtw$type, dtw$voice, dtw$time, dtw$value))

dbExecute(connn, update_financial_data_date_query,
          list(as.character(Sys.Date()), exp_select_AddCompany))




## E. Check if datas available --------------------------------------------------------------------------

dbExecute(connn, update_availabledata_query)


## D. Read tables --------------------------------------------------------------------------

dtw = data.table::data.table(dbReadTable(connn, "my_companies"))
dt_hp = data.table::data.table(dbReadTable(connn, "historical_price"))
dt_fd = data.table::data.table(dbReadTable(connn, "financial_statements"))

print(dtw)


# 3. Close the database connection --------------------------------------------------------------------------
dbDisconnect(connn)


