# Load the RSQLite package
library(RSQLite)
library(DBI)


# Create a connection to the SQLite database -----------------
con = dbConnect(SQLite(), dbname = "data/zto_database.db")

# Create the tables -------------------------------------

# Create the "my_companies" table
dbExecute(con, "CREATE TABLE my_companies (
  id INTEGER PRIMARY KEY,
  company_id TEXT,
  company_name TEXT,
  industry TEXT,
  market TEXT,
  headquarters TEXT,
  founded_year INTEGER,
  status TEXT CHECK(status IN ('Active', 'Inactive', 'Pending', 'Follow'))
)")

dbExecute(con, "CREATE INDEX idx_company_id ON my_companies(company_id)")


# Create the "historical_price" table
dbExecute(con, "CREATE TABLE historical_price (
  company_id TEXT,
  date DATE,
  closing_price REAL,
  volume INTEGER,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")

# Create the "income_statement" table
dbExecute(con, "CREATE TABLE income_statement (
  company_id TEXT,
  date DATE,
  revenue REAL,
  expenses REAL,
  net_income REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")

# Create the "cashflow_statement" table
dbExecute(con, "CREATE TABLE cashflow_statement (
  company_id TEXT,
  date DATE,
  operating_cashflow REAL,
  investing_cashflow REAL,
  financing_cashflow REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")

# Create the "balance_sheet" table
dbExecute(con, "CREATE TABLE balance_sheet (
  company_id TEXT,
  date DATE,
  assets REAL,
  liabilities REAL,
  equity REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")

# Create the "financial_ratios" table
dbExecute(con, "CREATE TABLE financial_ratios (
  company_id TEXT,
  date DATE,
  ratio_1 REAL,
  ratio_2 REAL,
  PRIMARY KEY (company_id, date),
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")

# Create the "my_positions" table
dbExecute(con, "CREATE TABLE my_positions (
  position_id INTEGER PRIMARY KEY,
  company_id TEXT,
  date DATE,
  purchase_date DATE,
  purchase_price REAL,
  sell_date DATE,
  sell_price REAL,  
  shares INTEGER,
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")

# Risk metrics
dbExecute(con, "CREATE TABLE portfolio_metrics (
  position_id INTEGER PRIMARY KEY,
  company_id TEXT,
  date DATE,
  purchase_date DATE,
  purchase_price REAL,
  sell_date DATE,
  sell_price REAL,  
  shares INTEGER,
  FOREIGN KEY (company_id) REFERENCES my_companies(company_id)
)")


# Write into the tables -------------------------
sample_data = data.frame(
   id = c(1,2,3),
   company_id = c('ITR.MI', 'BBB.MI', 'CCC.MI'),
   company_name = c("INTRED", "Company B", 'Azienda C'),
   industry = c("Technology", "Finance", NA),
   market = c('EURONEXT.G.MI', 'EURONEXT.G.MI', NA),
   headquarters = c("Milano", "Roma", NA),
   founded_year = c(2000, 1995, NA),
   status = c("Active", "Inactive", 'Pending')
)


dbWriteTable(con, "my_companies", sample_data, append = TRUE)


# Delete table's record ------------------

company_id = '1'

delete_queries = paste0("DELETE FROM my_companies WHERE (company_id = '", company_id, "');")
dbExecute(con, delete_queries)

# dbExecute(connn, "UPDATE my_companies SET company_name = ?, industry = ?, market = ?, headquarters = ?, founded_year = ?, status = ? WHERE company_id = ?",


# Read tables -------------------------

dtw = data.table::data.table(dbReadTable(con, "my_companies"))
dt_hp = data.table::data.table(dbReadTable(con, "historical_price"))

print(dtw)


# Close the database connection --------------------
dbDisconnect(con)
