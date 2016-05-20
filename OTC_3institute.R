library(httr)
library(XML)
library(magrittr)

date="2016/05/19"
url <- paste0("http://www.tpex.org.tw/web/stock/3insti/DAILY_TradE/3itrade_hedge_print.php?l=en-us&se=EW&t=D&d=",
              date,"&s=0,asc,0")

tables <- GET(url) %>% 
  content('text') %>% 
  htmlParse() %>%
  readHTMLTable() %>%
  .[[1]]