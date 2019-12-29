
#title: "Task 3: Shiny App"
#SubmittedBy: "Pooja Holkar - 11920022
#              Ashlesha Ingale - 11920078
#              Anish Goyal - 11920071
#              Ajay Nathani - 11920092
#              Aditya Bukkapatnan - 11920029
#              "


shinyServer(function(input,output){
  
  dataset <- reactive({
    if (is.null(input$file)) {return(NULL)}
    else {
      Document = readLines(input$file$datapath)
      Doc.id=seq(1:length(Document))
      calib=data.frame(Doc.id,Document)
      return(calib)}
  })
  
  keywords <-reactive({
    word <- trimws(unlist(strsplit(input$keywords,",")))
    word<-tibble(word) 
    return(word)
  })
  
  output$allSentences <- renderTable({
    if (is.null(input$file)) {return(NULL)}
    allSentences <- dataset() %>% 
      unnest_tokens(sentence,Document,token="sentences")
    allSentences
      
  })
  
  output$filteredSentences <- renderTable({
    if (is.null(input$file)) {return(NULL)}
    
    word <-keywords() 
    
    SentIds <- dataset() %>% 
      unnest_tokens(sentence,Document,token="sentences") %>%
      mutate(sentID=row_number())%>%
      unnest_tokens(word,sentence)%>%
      inner_join(word) %>%
      group_by(sentID) #%>%
  
    
    sentence <- dataset() %>% 
      unnest_tokens(sentence,Document,token="sentences") %>%
      mutate(sentID=row_number())%>%
      filter(sentID %in% SentIds$sentID)%>%
      select(c("Doc.id","sentence"))
      
  })
  
  output$Count <- renderTable({
    if (is.null(input$file)) {return(NULL)}
    
    word <-keywords()
    wordcount <- dataset() %>%
      unnest_tokens(sentence,Document,token="sentences")%>%
      unnest_tokens(word,sentence)%>%
      inner_join(word)%>%
      count(word,sort=TRUE)
  })
  
  
  output$barchart <- renderPlot({
    if (is.null(input$file)) {return(NULL)}
    
    word <-keywords()
    
    wordcount <- dataset() %>%
      unnest_tokens(sentence,Document,token="sentences")%>%
      unnest_tokens(word,sentence)%>%
      inner_join(word)%>%
      count(word,sort=TRUE)%>%
      ggplot(aes(x=reorder(word, -n),y=n)) +
      geom_bar(stat = "identity",   fill = "steelblue") +
      xlab("Keywords") +ylab("Frequency")
    
    plot(wordcount)
  })
  
  
  
  output$wordcloud <- renderPlot({
    if (is.null(input$file)) {return(NULL)}
    
    word <-keywords()
    minFreq <- input$freq
    maxWords <- input$max
    
    wordcount <- dataset() %>%
      unnest_tokens(sentence,Document,token="sentences")%>%
      unnest_tokens(word,sentence)%>%
      inner_join(word)%>%
      count(word,sort=TRUE)%>%
      with(wordcloud(word, freq=n,min.freq=1, max.Words = 300,scale = c(4,.5),colors = brewer.pal(8, "Dark2")))
    
      
  })
  
  
})