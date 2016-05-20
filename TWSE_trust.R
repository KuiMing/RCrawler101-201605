library(data.table)
library(magrittr)
library(httr)
library(rvest)
library(quantmod)


# 搜尋證券交易所的投信買賣超彙總表

url = 'http://www.twse.com.tw/en/trading/fund/TWT44U/TWT44U.php'

date="2016/05/19"


res=POST(url,
         add_headers(
           `Content-Type`= "application/x-www-form-urlencoded"
         ),
         body = paste0('download=html&qdate=',date,'&sorting=by_issue'))
tables=content(res,encoding = 'utf8') %>%
  html_table(fill = T)
tables=tables[[1]] %>% 
  as.data.table() %>% 
  .[-(1:2),c("X2","X5"),with=F]

colnames(tables)=c('code','difference')
tables$difference=as.numeric(gsub(',','',tables$difference))
