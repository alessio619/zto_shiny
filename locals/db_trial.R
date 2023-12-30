
# DB Management ================================================================================


# Load the RSQLite package
library(RSQLite)
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
  findata_y_bs INTERGER,
  findata_y_is INTERGER,
  findata_y_cs INTERGER,
  findata_q_is INTERGER,
  findata_q_cs INTERGER,  
  ratios_data INTERGER  
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


## Create the "income_statement" table --------------------------------------
create_isy_query = "CREATE TABLE income_statement_y (
  company_id TEXT,
  date DATE,
  revenue REAL,
  expenses REAL,
  net_income REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

create_isq_query = "CREATE TABLE income_statement_q (
  company_id TEXT,
  date DATE,
  revenue REAL,
  expenses REAL,
  net_income REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_isy_query)

dbExecute(connn, create_isq_query)


## Create the "cashflow_statement" table --------------------------------------
create_csy_query = "CREATE TABLE cashflow_statement_y (
  company_id TEXT,
  date DATE,
  operating_cashflow REAL,
  investing_cashflow REAL,
  financing_cashflow REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

create_csq_query = "CREATE TABLE cashflow_statement_q (
  company_id TEXT,
  date DATE,
  operating_cashflow REAL,
  investing_cashflow REAL,
  financing_cashflow REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_csy_query)

dbExecute(connn, create_csq_query)


## Create the "balance_sheet" table --------------------------------------
create_bsy_query =  "CREATE TABLE balance_sheet_y (
  company_id TEXT,
  date DATE,
  assets REAL,
  liabilities REAL,
  equity REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)"

dbExecute(connn, create_bsy_query)


## Create FINANCIAL DATA Table --------------------------------------
create_financialdata_query = "
  CREATE TABLE combined_table AS
  SELECT 
    COALESCE(bs.company_id, isy.company_id, cfy.company_id, isq.company_id, cfq.company_id) AS company_id,
    COALESCE(bs.date, isy.date, cfy.date, isq.date, cfq.date) AS date,
    bs.balance_value AS bs_balance_value,
    isy.income_value AS isy_income_value,
    cfy.cashflow_value AS cfy_cashflow_value,
    isq.income_value AS isq_income_value,
    cfq.cashflow_value AS cfq_cashflow_value
  FROM 
    balance_sheet_y bs
  FULL OUTER JOIN 
    income_statement_y isy ON bs.company_id = isy.company_id AND bs.date = isy.date
  FULL OUTER JOIN 
    cashflow_statement_y cfy ON bs.company_id = cfy.company_id AND bs.date = cfy.date
  FULL OUTER JOIN 
    income_statement_q isq ON bs.company_id = isq.company_id AND bs.date = isq.date
  FULL OUTER JOIN 
    cashflow_statement_q cfq ON bs.company_id = cfq.company_id AND bs.date = cfq.date
"

# Execute the query to create the new table
dbExecute(connn, create_financialdata_query)


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
   industry = c("Technology", "Finance", NA),
   market = c('EURONEXT.G.MI', 'EURONEXT.G.MI', NA),
   headquarters = c("Milano", "Roma", NA),
   founded_year = c(2000, 1995, NA),
   status = c("Active", 'Pending', 'Follow'),
   historical_data = c(0,0,0),
   findata_y_bs = c(0,0,0),
   findata_y_is = c(0,0,0),
   findata_y_cs = c(0,0,0),
   findata_q_is = c(0,0,0),
   findata_q_cs = c(0,0,0)
   )


dbWriteTable(connn, "my_companies", sample_data, append = TRUE)


## B. Delete table's record --------------------------------------------------------------------------

# company_id = '1'
# 
# delete_queries = paste0("DELETE FROM my_companies WHERE (company_id = '", company_id, "');")
# dbExecute(connn, delete_queries)

# dbExecute(connn, update_newcompany_query,



## C. Add historical data --------------------------------------------------------------------------

dt_fetchedTickers = fetch_tickers(TICKERS = 'MELI',
                          INIT_DATE = '2021-01-01',
                          END_DATE = Sys.Date())

exp_select_AddCompany = 'MELI'

new_records = dt_fetchedTickers[ticker %in% exp_select_AddCompany]
new_records = new_records[, .(company_id = ticker, date = as.character(index), closing_price = adjusted, volume = volume)]

dbExecute(connn, insert_newhistoricaldata_query,
          list(new_records$company_id, new_records$date, new_records$closing_price, new_records$volume))



## C. Check if datas available --------------------------------------------------------------------------

dbExecute(connn, update_availabledata_query)


## D. Read tables --------------------------------------------------------------------------

dtw = data.table::data.table(dbReadTable(con, "my_companies"))
dt_hp = data.table::data.table(dbReadTable(con, "historical_price"))

print(dtw)


# 4. Close the database connection --------------------------------------------------------------------------
dbDisconnect(connn)




