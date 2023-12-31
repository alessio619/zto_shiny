
# DB Management ================================================================================


# Load the RSQLite package
library(RSQLite)
library(data.table)
library(DBI)
source(file.path('webapp', 'queries.R'))
source(file.path('webapp', 'financial.R'))


# 1. Create a connection to the SQLite database --------------------------------------------------------------------------
connn = dbConnect(SQLite(), dbname = "data/zto_database.db")


# 2. Create the tables --------------------------------------------------------------------------

## Create the "my_companies" table  --------------------------------------------------------------------------
create_mycompanies_query = "CREATE TABLE my_companies (
  id INTEGER PRIMARY KEY,
  company_id TEXT,
  company_name TEXT,
  industry TEXT,
  market TEXT,
  headquarters TEXT,
  founded_year INTEGER,
  status TEXT CHECK(status IN ('Active', 'Inactive', 'Pending', 'Follow')),
  historical_data INTERGER,
  historical_data_update DATE,
  financial_data INTERGER,
  financial_data_update DATE,
  ratios_data INTERGER,
  ratios_data_update DATE
)"

dbExecute(connn, create_mycompanies_query)

dbExecute(connn, "CREATE INDEX idx_company_id ON my_companies(company_id)")


## Create the "historical_price" table --------------------------------------
create_historicalprice_query = "CREATE TABLE historical_price (
  company_id TEXT,
  date DATE,
  closing_price REAL,
  volume INTEGER,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_historicalprice_query)


## Create the "financial_statements" table --------------------------------------
create_fs_query = "CREATE TABLE financial_statements (
  company_id TEXT,
  date DATE,
  stmt TEXT,
  type TEXT,
  voice TEXT,
  time TEXT,
  value REAL,
  PRIMARY KEY (company_id, date, time, voice),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"


dbExecute(connn, create_fs_query)



## Create the "financial_ratios" table --------------------------------------
create_financialratios_query = "CREATE TABLE financial_ratios (
  company_id TEXT,
  date DATE,
  ratio_1 REAL,
  ratio_2 REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_financialratios_query)


## Create the "my_positions" table --------------------------------------
create_mypositions_query = "CREATE TABLE my_positions (
  position_id INTEGER PRIMARY KEY,
  company_id TEXT,
  date DATE,
  purchase_date DATE,
  purchase_price REAL,
  sell_date DATE,
  sell_price REAL,  
  shares INTEGER,
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_mypositions_query)


## Risk metrics --------------------------------------
create_riskmetrics_query = "CREATE TABLE portfolio_metrics (
  position_id INTEGER PRIMARY KEY,
  company_id TEXT,
  date DATE,
  purchase_date DATE,
  purchase_price REAL,
  sell_date DATE,
  sell_price REAL,  
  shares INTEGER,
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_riskmetrics_query)




# 3. CRUD  --------------------------------------------------------------------------

## A. Write into the tables --------------------------------------

sample_data = data.frame(
   id = c(1,2,3),
   company_id = c('ITR.MI', 'BBB.MI', 'MELI'),
   company_name = c("INTRED", "Company B", 'Mercado Libre'),
   industry = c("Technology", "Finance", NA_character_),
   market = c('EURONEXT.G.MI', 'EURONEXT.G.MI', NA_character_),
   headquarters = c("Milano", "Roma", NA_character_),
   founded_year = c(2000, 1995, NA_integer_),
   status = c("Active", 'Pending', 'Follow'),
   historical_data = c(0,0,0),
   historical_data_update = c(NA_character_, NA_character_, NA_character_),
   financial_data = c(0,0,0),
   financial_data_update = c(NA_character_, NA_character_, NA_character_),
   ratios_data = c(0,0,0),
   ratios_data_update = c(NA_character_, NA_character_, NA_character_)
      )


dbWriteTable(connn, "my_companies", sample_data, append = TRUE)


## B. Delete table's record --------------------------------------------------------------------------

# company_id = '1'
# 
# delete_queries = paste0("DELETE FROM my_companies WHERE (company_id = '", company_id, "');")
# dbExecute(connn, delete_queries)

# dbExecute(connn, update_newcompany_query,



## C. Add Historical data --------------------------------------------------------------------------

exp_select_AddCompany = 'MELI'

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

# DT = copy(list_ticker)
# 
# DTS = DT[['MELI']]
# # DTS = DT[[1]]
# 
# DTW_bsy = copy(DTS[['bs_y']])
# DTW_iny = copy(DTS[['in_y']])
# DTW_csy = copy(DTS[['cs_y']])
# DTW_inq = copy(DTS[['in_q']])
# DTW_csq = copy(DTS[['cs_q']])
# 
# dtw_bsy = melt(DTW_bsy[, type := 'annual'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
# dtw_iny = melt(DTW_iny[, type := 'annual'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
# dtw_csy = melt(DTW_csy[, type := 'annual'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
# dtw_inq = melt(DTW_inq[, type := 'quarter'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
# dtw_csq = melt(DTW_csq[, type := 'quarter'], id.vars = c('id', 'stmt', 'type', 'voice'), variable.name = 'time', value.name = 'value')
# 
# dtw = rbindlist(list(dtw_bsy, dtw_iny, dtw_csy, dtw_inq, dtw_csq))
# 
# setnames(dtw, 'id', 'company_id')


dbExecute(connn, insert_newfinancialdata_query,
          list(dtw$company_id, rep(as.character(Sys.Date()), nrow(dtw)), dtw$stmt, dtw$type, dtw$voice, dtw$time, dtw$value))


dbExecute(connn, update_financial_data_date_query,
          list(as.character(Sys.Date()), exp_select_AddCompany))


## E. Check if datas available --------------------------------------------------------------------------

dbExecute(connn, update_availabledata_query)


## D. Read tables --------------------------------------------------------------------------

dtw = data.table::data.table(dbReadTable(connn, "my_companies"))
dt_hp = data.table::data.table(dbReadTable(connn, "historical_price"))
dt_fd = data.table::data.table(dbReadTable(connn, "financial_statements"))

print(dtw)


# 4. Close the database connection --------------------------------------------------------------------------
dbDisconnect(connn)

