
# Packages ============================================
library(shiny)
library(bslib)
library(data.table)
library(quantmod)
library(reactable)
library(reactable.extras)
library(highcharter)

## Sourcing files
base_path = 'webapp'
source(file.path(base_path, 'setup.R'))
source(file.path(base_path, 'pages', '01_explorer.R'))
source(file.path(base_path, 'pages', '02_analyzer.R'))
source(file.path(base_path, 'ui.R'))
source(file.path(base_path, 'server.R'))



# App ============================================

ui_app = ui
server_app = server



# Run ============================================
shinyApp(ui_app, server_app)



