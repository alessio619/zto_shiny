

### UI WRAPPER ###     


options(reactable.theme = zto_reactable_theme)
options(highcharter.theme = zto_hc_theme)


# : ============================================================================================================================




ui_app =
   
   # HEADER ================================================================================


navbarPage(
   
   ## Setup ------------------------------------
   
   title = "zero2one - ADMP",
   
   theme = zerotoonec_theme,
   
   tags$style(HTML(
      '.nav.navbar-nav {margin: 20px; height: 45px; padding-right: 15px; font-size: 15px;}'
   )),
   
   tags$style(HTML(
      '.navbar-brand {padding: 25px; font-weight: bold; font-size: 24px;}'
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