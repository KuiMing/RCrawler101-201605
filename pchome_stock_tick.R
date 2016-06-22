library(httr)
library(XML)
library(magrittr)
pchome_stock_tick <- function(code='1215'){
  url <- paste0('http://pchome.megatime.com.tw/stock/sto0/ock3/sid',
                code,'.html')
  ref <- paste0('http://pchome.megatime.com.tw/stock/sto0/ock2/sid',
                code,'.html')
  res <- GET(url,
             add_headers(Referer= ref))
  
  resStr <- content(res,'text') %>% 
    htmlParse() %>% 
    readHTMLTable(stringsAsFactors=F) %>% 
    .[[3]]
}


