library(httr)
library(rvest)
library(data.table)
url <- "http://www.twse.com.tw/en/trading/exchange/STOCK_DAY_AVG/STOCK_DAY_AVG.php"
res <- POST(url,
            add_headers(
              Connection= "keep-alive",
              `Content-Length`= 40,
              `Cache-Control`= "max-age=0",
              Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
              Origin= "http://www.twse.com.tw",
              `Upgrade-Insecure-Requests`= 1,
              `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
              `Content-Type`= "application/x-www-form-urlencoded",
              `Accept-Encoding`= "gzip, deflate",
              `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2"),
            body = 'myear=2015&mmon=5&STK_NO=3596&B1=+Query+')
url <-"http://www.twse.com.tw/en/trading/exchange/STOCK_DAY_AVG/genpage/Report201505/201505_F3_1_8_3596.php?STK_NO=3008&myear=2015&mmon=05"
res <- GET(url,
           add_headers(
             Host= 'www.twse.com.tw',
             Connection= 'keep-alive',
             Accept= 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
             `Upgrade-Insecure-Requests`= 1,
             `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
             Referer= "http://www.twse.com.tw/en/trading/exchange/STOCK_DAY_AVG/STOCK_DAY_AVG.php",
             `Accept-Encoding`= "gzip, deflate, sdch",
             `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2"),encoding='utf8')
resStr <- content(res,as="raw",encoding = 'utf8')
writeBin(resStr, "myfile.txt")

tables <- readLines('myfile.txt',warn = FALSE) %>% 
  paste(collapse = "") %>% 
  htmlParse() %>% 
  readHTMLTable() %>% 
  .[[8]]
tables <- tables[-c(1,dim(tables)[1]),] %>% 
  mutate(V2=as.numeric(unlist(gsub(',','',as.character(V2)))))
  
tables
