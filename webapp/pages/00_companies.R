
# Page Backend ================================================================================

page_backend =  fluidPage(
   
   useWaiter(),
   reactable_extras_dependency(),
   tableOutput('texto2'),
   
   fluidRow( # big fluid row start
      
      column(width = 3,
             
       ## From DB --------------------------------------------------
             accordion(
                accordion_panel(
                   title = h2('Database', style = 'color: #4C6279'),
                   in_bck_select_list,
                   value = 'bck_01'
                ) ### accordion panel
             ), ### accordion
      
      ## Add --------------------------------------------------
      accordion(
         accordion_panel(
            title = h5('Add company manual', style = 'color: #4C6279'),
            'placeholder',
            actionButton("openModalBtn", "Add company"),
            value = 'bck_02'
         ) ### accordion panel
        ) ### accordion      
      ), ### column
      
      column(width = 9,
         reactableOutput(outputId = 'bck_table_trialdb')
      )
      
   )
)
             