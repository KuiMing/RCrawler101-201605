library(httr)
library(XML)
library(dplyr)
library(zoo)
library(xts)
url <- "http://www.twse.com.tw/en/trading/exchange/STOCK_DAY/STOCK_DAYMAIN.php"
res <- POST(url, body = 'myear=2016&mmon=7&STK_NO=1707&B1=+Query+')
url <-"http://www.twse.com.tw/en/trading/exchange/STOCK_DAY/genpage/Report201607/201607_F3_1_8_1707.php?STK_NO=1707&myear=2016&mmon=07"
res <- GET(url,
           add_headers(
             Referer= "http://www.twse.com.tw/en/trading/exchange/STOCK_DAY/STOCK_DAYMAIN.php"),
           encoding='utf8')
resStr <- content(res,as="raw",encoding = 'utf8')
writeBin(resStr, "myfile.txt")

tables <- readLines('myfile.txt',warn = FALSE) %>% 
  paste(collapse = "") %>% 
  htmlParse() %>% 
  readHTMLTable() %>% 
  .[[8]] 

tables <- tables[-1,c(1:2,4:7)]
tables[,2:6] <- sapply(2:6, function(i){
  as.numeric(unlist(gsub(',','',as.character(tables[,i]))))
})
tables <- mutate(tables,V1=gsub('/','-',V1)) %>% 
  `colnames<-`(c("date","Volume","Open","High","Low","Close"))

tables <- xts(tables[,2:6], as.Date(tables[,1])) %>% 
  as.zoo()
