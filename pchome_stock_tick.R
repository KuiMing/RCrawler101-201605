library(httr)
library(XML)
library(magrittr)
res <- GET('http://pchome.megatime.com.tw/stock/sto0/ock3/sid1215.html',
           add_headers(Referer= "http://pchome.megatime.com.tw/stock/sto0/ock2/sid1215.html"))

resStr <- content(res,'text') %>% 
  htmlParse() %>% 
  readHTMLTable() %>% 
  .[[3]]

