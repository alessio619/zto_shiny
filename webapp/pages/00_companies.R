
# Page Backend ================================================================================

page_backend =  fluidPage(
   
   useWaiter(),
   reactable_extras_dependency(),
   tableOutput('texto2'),

   tableOutput('texto3'),
   
   fluidRow( # big fluid row start
      
      column(width = 3,
             
       ## From DB --------------------------------------------------
             accordion(
                accordion_panel(
                   title = h2('Database', style = 'color: #4C6279'),
                   'In this section...',
                   in_bck_refresh_backend,
                   value = 'bck_01'
                ) ### accordion panel
             ), ### accordion
       
       br(),
      
      ## Add --------------------------------------------------
      accordion(
         accordion_panel(
            title = h5('Edit companies', style = 'color: #4C6279'),
            in_bck_add_company,
            br(), br(),
            in_bck_select_list,
            in_bck_edit_company,
            br(), br(),
            in_bck_delete_company,
            value = 'bck_02'
         ) ### accordion panel
        ) ### accordion      
      ), ### column
      
      column(width = 9,
         reactableOutput(outputId = 'bck_table_trialdb')
      )
      
   )
)
             