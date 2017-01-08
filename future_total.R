library(httr)
library(XML)
future_total <- function(year,month,date){
  url='https://www.taifex.com.tw/chinese/3/7_8.asp'
  
  form=paste0('pFlag=&yytemp=',year,'&mmtemp=',
              month,'&ddtemp=',date,
              '&chooseitemtemp=TX+++++&goday=&choose_yy=',
              year,'&choose_mm=',month,'&choose_dd=',
              date,'&datestart=',year,'%2F',month,'%2F',
              date,'&choose_item=ALL')
  res<-POST(url,
            add_headers(
              Host= "www.taifex.com.tw",
              Connection= "keep-alive",
              `Content-Length`= 150,
              `Cache-Control`= "max-age=0",
              Origin= "https://www.taifex.com.tw",
              `Upgrade-Insecure-Requests`= 1,
              `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
              `Content-Type`= "application/x-www-form-urlencoded",
              Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
              Referer= "https://www.taifex.com.tw/chinese/3/7_8.asp",
              `Accept-Encoding`= "gzip, deflate, br",
              `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
              Cookie= "ASPSESSIONIDCCBBRQTB=LGICHOBBOEOKGGJONJCOIAIF; AX-cookie-POOL_PORTAL=AGACBAKM; AX-cookie-POOL_PORTAL_web3=ADACBAKM; ASPSESSIONIDCADDTTRA=DHEHFKOBLCKGOOHKHEHEODPC"
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
  
  tbl$V1[seq(7,439,2)]=tbl$V1[seq(6,438,2)]
  tbl$V1[4:5]=tbl$V1[3]
  
  colnames(tbl) <- c("契約名稱","到期月份",
                     "買方五大部位數",
                     "買方五大百分比",
                     "買方十大部位數",
                     "買方十大百分比",
                     "賣方五大部位數",
                     "賣方五大百分比",
                     "賣方十大部位數",
                     "賣方十大百分比",
                     "未沖銷部位數")
  tbl <- tbl[-(1:2),]
  tbl$未沖銷部位數 <- gsub(',','',tbl$未沖銷部位數) %>% 
    as.numeric()
  return(tbl)
}
