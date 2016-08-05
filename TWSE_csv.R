library(httr)
library(XML)
library(dplyr)
TWSE_csv <- function(stock="1215",year_in,month_in){
  url <- "http://www.twse.com.tw/en/trading/exchange/STOCK_DAY/STOCK_DAY.php"
  year <- as.numeric(year_in)
  month <- as.numeric(month_in)
  query_str <- paste0('myear=', year, '&mmon=', month,
                      '&STK_NO=', stock, '&login_btn=+Query+')
  res <- POST(url,
              add_headers(
                Connection= "keep-alive",
                `Content-Length`= 47,
                `Cache-Control`= "max-age=0",
                Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                Origin= "http://www.twse.com.tw",
                `Upgrade-Insecure-Requests`= 1,
                `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
                `Content-Type`= "application/x-www-form-urlencoded",
                `Accept-Encoding`= "gzip, deflate",
                `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2"),
              body = query_str)
  x=year_in
  i=month_in
  
  url <- paste0("http://www.twse.com.tw/en/trading/exchange/STOCK_DAY/STOCK_DAY_print.php?genpage=genpage/Report", 
                x, i, "/", x, i, "_F3_1_8_", stock, ".php&type=csv")
  # download.file(url,destfile = "tmp.csv")
  tables <- read.csv(url,header = F)
  tables <- tables[-1:-2,c(1:2,4:7)]
  tables[,2:6] <- sapply(2:6, function(i){
    as.numeric(unlist(gsub(',','',as.character(tables[,i]))))
  })
  tables <- mutate(tables,V1=gsub('/','-',V1)) %>% 
    `colnames<-`(c("date","Volume","Open","High","Low","Close"))
  
  tables <- xts(tables[,2:6], as.Date(tables[,1])) %>% 
    as.zoo()
  return(tables)
}