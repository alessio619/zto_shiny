

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
   
  
   ## Pages ------------------------------------

   tabPanel(
      "Explore",
      page_explorer
   ),
   
   tabPanel(
      "Analyze",
      page_analyze
   ),
   
   tabPanel(
      "Portfolio",
      page_portfolio
   ),
   
   tabPanel(
      'Backend',
      page_backend
   ),
   
   ## END 
   
   tags$style(HTML(
      '.nav.navbar-nav {margin: 1.5%; height: 2.5vh; justify-content: center; font-size: 0.9vw; padding-bottom: 3.5vh;}'
   )),
   
   tags$style(HTML(
      '.navbar-brand {padding: 25%; font-weight: bold; font-size: 1.5vw;}'
   )),
   
   tags$style(HTML(
      '.bslib-card {border-color: rgb(221, 221, 221);}'
   )),   
   
   tags$style(HTML(
      '.bslib-card .bslib-navs-card-title {border-bottom-color: rgb(221, 221, 221);}'
   )),   
   
   tags$style(HTML(
      '.card-header {border-bottom-color: rgb(221, 221, 221);}'
   )),   
   
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   ############   ############   ############   ############   ############   ############   ############
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      '.bslib-sidebar-layout .sidebar-title {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      '.nav-underline .nav-link, .nav-underline .nav-tabs>li>a, .nav-underline .nav-pills>li>a, .nav-underline {padding-left: 2.5vh; padding-right: 2.5vh}'
   )), 
   
   tags$style(HTML(
      '.accordion-body {padding: 3.5vh}'
   )), 
   
   tags$style(HTML(
      '.shiny-input-container select, .btn {padding: 0.75vh;}'
   )), 
   
   # tags$style(HTML(
   #    '.bslib-value-box .value-box-title {font-family: Inter important!;}'
   # )),
   
   ############   ############   ############   ############   ############   ############   ############
   tags$style(HTML(
      '.form-check, .shiny-input-container .checkbox, .shiny-input-container .radio {color: #4C6279;}'
   )), 
   
   tags$style(HTML(
      ' .bslib-sidebar-layout.sidebar-right>.collapse-toggle>.collapse-icon {color: #4C6279;}'
   ))
   
)