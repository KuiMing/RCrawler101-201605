library(httr)
library(XML)
library(rvest)
future_insti <- function(year,month,date){
  url="https://www.taifex.com.tw/chinese/3/7_12_3.asp"
  form <- paste0("goday=&DATA_DATE_Y=",year,"&DATA_DATE_M=",month,"&DATA_DATE_D=",date,"&syear=",year,"&smonth=",month,"&sday=",date,"&datestart=",year,"%2F",month,"%2F",date,"&COMMODITY_ID=")
  res<-POST(url,
            add_headers(
              Host= "www.taifex.com.tw",
              Connection= "keep-alive",
              `Content-Length`= 121,
              `Cache-Control`= "max-age=0",
              Origin= "https://www.taifex.com.tw",
              `Upgrade-Insecure-Requests`= 1,
              `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
              `Content-Type`= "application/x-www-form-urlencoded",
              Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
              Referer= "https://www.taifex.com.tw/chinese/3/7_12_3.asp",
              `Accept-Encoding`= "gzip, deflate, br",
              `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
              Cookie= "ASPSESSIONIDCCBBRQTB=LGICHOBBOEOKGGJONJCOIAIF; AX-cookie-POOL_PORTAL=AGACBAKM; AX-cookie-POOL_PORTAL_web3=ADACBAKM"
            ),
            body = form)
  resStr=content(res,'text')
  html <- htmlParse(resStr)
  tbl <- readHTMLTable(html,stringsAsFactors = F)
  tbl <- tbl[[4]]
  for (x in 4:dim(tbl)[1]){
    ind <- which(!is.na(tbl[x,]))
    shiftn=dim(tbl)[2]-length(ind)
    tbl[x,(shiftn+1):dim(tbl)[2]]=tbl[x,ind]
  }
  
  
  x=sapply(tbl$V2[seq(4,37,3)], function(x){
    rep(x,3)})
  x=melt(x) %>% .[,3]
  x=as.character(x)
  tbl$V2[4:39]=x
  
  tbl=tbl[,-1]
  colnames(tbl) <- c('商品名稱','身份別',
                     '多方交易口數',
                     '多方交易金額',
                     '空方交易口數',
                     '空方交易金額',
                     '多空交易口數',
                     '多空交易金額',
                     '多方未平口數',
                     '多方未平金額',
                     '空方未平口數',
                     '空方未平金額',
                     '多空未平口數',
                     '多空未平金額')
  tbl <- tbl[-(1:3),]
  for (i in 3:dim(tbl)[2]){
    tbl[,i] <- gsub(',','',tbl[,i]) %>% 
      as.numeric()
  }
  tbl$商品名稱[37]="期貨合計"
  tbl$身份別[37]="法人"
  return(tbl)
}

# resStr=read_html(res)
# tbl <- html_nodes(resStr,"table") %>% 
#   html_table(fill = TRUE) %>% 
#   .[[4]]