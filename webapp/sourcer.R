

# : ========================================================================================================================================================



## Sourcer ----------------------------------------------------------------

base_path = 'webapp'


# Set up ===============================================================

source(file.path(base_path, 'setup.R'))
source(file.path(base_path, 'theme.R'))
source(file.path(base_path, "financial.R"))


# UI ===============================================================
source(file.path(base_path, 'pages', "inputs.R"))
source(file.path(base_path, 'pages', '01_pricing.R'))
source(file.path(base_path, 'pages', '02_financials.R'))
source(file.path(base_path, 'pages', '03_companies.R'))
source(file.path(base_path, 'ui.R'))


# Source SERVER ===============================================================
source(file.path(base_path, 'server.R'))



