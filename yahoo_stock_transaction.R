library(httr)
library(rvest)
library(magrittr)
url <- 'https://tw.stock.yahoo.com/q/ts?s=3008&t=50'

transaction <- GET(url) %>% 
  content("text",encoding="big5") %>% 
  read_html() %>% 
  html_table(fill=TRUE) %>% 
  .[[8]] %>% 
  .[-1,] %>% 
  `colnames<-`(c("time","buy","sell","deal",
                 "change",'volume')) %>% 
  mutate(deal=as.numeric(deal),
         volume=as.numeric(volume))
