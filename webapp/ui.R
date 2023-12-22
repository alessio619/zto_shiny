

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
      '.nav.navbar-nav {margin: 1.5%; height: 3vh; padding-bottom: 2.5%; padding-left: 2.5%; font-size: 1.125vw;}'
   )),
   
   tags$style(HTML(
      '.navbar-brand {padding: 25%; font-weight: bold; font-size: 1.5vw;}'
   )),
   
   
   ## Pages ------------------------------------

   tabPanel(
      "Price",
      page_price
   ),
   
   tabPanel(
      "Financials",
      page_financials
   )
   
   ## END 
   
)