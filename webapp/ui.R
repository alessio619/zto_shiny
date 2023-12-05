
# App UI =====================================================

ui =  page_navbar(
  
  ## Setup ------------------------------------
    theme = bs_theme(bootswatch = "minty"),
    window_title = '021 Platform',
    title = "021",
    
  ## Pages ------------------------------------
  tabPanel(
    "Explorer",
    page_explorer
  ),
  
  tabPanel(
    "Other",
    page_analyzer
  )
  
  ## END 
  
)