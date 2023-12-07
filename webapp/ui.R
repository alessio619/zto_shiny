

### UI WRAPPER ###     





# : ============================================================================================================================




ui_app =
   
   # HEADER ================================================================================


navbarPage(
   
   ## Setup ------------------------------------
   
   title = "Zero2One - ADMP",
   
   theme = zerotoonec_theme,
   
   tags$style(HTML(
      '.nav.navbar-nav {margin: 20px; height: 45px;}'
   )),
   
   tags$style(HTML(
      '.nav.navbar-nav-item {padding: 20px;}'
   )),   
   
   tags$style(HTML(
      '.navbar-brand {padding: 25px;}'
   )),
   
   
   ## Pages ------------------------------------

   tabPanel(
      "Explorer",
      page_explorer
   ),
   
   tabPanel(
      "Other",
      page_companies
   )
   
   ## END 
   
)