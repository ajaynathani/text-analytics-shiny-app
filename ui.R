
#title: "Task 3: Shiny App"
#SubmittedBy: "Pooja Holkar - 11920022
#              Ashlesha Ingale - 11920078
#              Anish Goyal - 11920071
#              Ajay Nathani - 11920092
#              Aditya Bukkapatnan - 11920029
#              "



library(shiny)
library(ggplot2)
library(magrittr)
library(tidytext)
library(tidyverse)
library(wordcloud)
fluidPage(
    
  titlePanel("Keyword filtering"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file",
                "Upload text file",
                accept=c("text/csv",
                         "text/comma-separaed-values/plain",
                         ".txt")
      ),
      textInput(
        "keywords",
        "Enter keywords (comma separated)",
        placeholder = "word1,word2,word2"
      ),
      submitButton(text="Apply Changes",icon('refresh'))
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("The app input is the corpus file and the keyword list.",align="justify"),
                           p("Please refer to the link below for sample csv file."),
                           a(href="https://raw.githubusercontent.com/ajaynathani/sample-datasets/master/ice-cream%20data.txt"
                             ,"Sample data input file"),   
                           br(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Browse...")),
                             'and upload the text file.'),
                          p('Also input the keywords as comma separated')),
                  tabPanel("All Sentences", 
                           p('This will show all sentences from file in separate rows.'),
                           tableOutput('allSentences')),
                  tabPanel("Filtered Sentences", 
                           tableOutput('filteredSentences')),
                  tabPanel("Count", 
                           tableOutput('Count')),
                  
                  tabPanel("Bar-Chart",
                           plotOutput('barchart')),
                  
                  tabPanel("Wordcloud",
                           plotOutput('wordcloud'))
                  
      ) # end of tabsetPanel
    )
  )
)