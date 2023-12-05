

### UI WRAPPER ###     





# : ============================================================================================================================




ui_app <- 
   
   # HEADER ================================================================================


navbarPage(
   
   ## Setup ------------------------------------
   
   title = "Macroeconomic Tracker",
   
   header = tagList(
      
      use_googlefont("Exo 2"),
      use_theme(zerotoonec_theme)),
  
    
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