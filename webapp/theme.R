
# Global Theme ================================================================================

zerotoonec_theme =
   bs_theme(
      bootswatch = "flatly",
      primary = '#75A5B7',
      secondary = '#6c757d',
      info = '#4C6279',
      danger = '#F29191',
      warning = '#f37736',
      success = '#6EBDAB',
      "font-size-base" = "0.825rem",
      'navbar-bg' = '#75A5B7',
      'navbar-ligh-margin' = '50px',
      'navbar-light-bg' = '#4C6279',
      'navbar-light-color' = '#f2f2f2',
      'navbar-light-active-color' = '#fff',
      'navbar-light-hover-color' = '#8DC2C9',
      'body-bg' = '#f9f9f9',
      'body-color' = '#6c757d',
      'heading-color' = '#6c757d',
      'accordion-icon-color' = '#4C6279',
      'accordion-icon-active-color' = '#dddddd'
   )



# Reactable Theme ================================================================================

zto_reactable_theme = reactableTheme(
   color = '#6c757d',
   backgroundColor = '#f9f9f9',
   borderColor = "#dfe2e5",
   stripedColor = "#f2f2f2",
   highlightColor = "#e6e6e6",
   headerStyle = list(fontSize = '16px', paddingTop = '10px', paddingBottom = '10px'),
   style = list(fontFamily = "Inter, -apple-system, Segoe UI, Helvetica, sans-serif"),
   searchInputStyle = list(width = "100%")
)



# Highcharter Theme ================================================================================

zto_hc_theme = hc_theme_merge(
   hc_theme_hcrt(),
      hc_theme(
   colors = c("#75A5B7", "#CDC1AB", "#4C6279", '#6EBDAB', '#6B7478', '#B88C76', '#7F8AB8', '#97B876', '#93CFE5', '#3E4C52'),
   chart = list(
      backgroundColor = "#f9f9f9"
   ),
   title = list(
      style = list(color = "#6c757d", fontSize = "14px", fontFamily = "Inter")
   ),
   subtitle = list(
      style = list(color = "#6c757d", fontSize = "11px", fontFamily = "Inter")
   ),
   xAxis = list(
      labels = list(style = list(color = "#6c757d", fontFamily = "Inter")),
      gridLineColor = "#e6e6e6",
      minorGridLineColor = '#f0f0f0'
   ),
   yAxis = list(
      title = list(style = list(color = "#6c757d", fontFamily = "Inter")),
      labels = list(style = list(color = "#6c757d", fontFamily = "Inter")),
      gridLineColor = "#e6e6e6",
      minorGridLineColor = '#f0f0f0'
   ),
   legend = list(
      layout = "horizontal",
      verticalAling = 'top',
      itemStyle = list(
         fontFamily = "Inter",
         color = "#6c757d"
      )
   )
      )
)
