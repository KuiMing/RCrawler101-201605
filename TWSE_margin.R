TWSE_margin <- function(year=2016, mons="09", day="26"){
  year=(year-1911) %>% as.character()
  url <- "http://www.twse.com.tw/ch/trading/exchange/MI_MARGN/MI_MARGN.php"
  res <- POST(url,
              add_headers(
                Host= "www.twse.com.tw",
                Connection= "keep-alive",
                `Content-Length`= 43,
                `Cache-Control`= "max-age=0",
                Origin= "http://www.twse.com.tw",
                `Upgrade-Insecure-Requests`= 1,
                `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",
                `Content-Type`= "application/x-www-form-urlencoded",
                Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                Referer= "http://www.twse.com.tw/ch/trading/exchange/MI_MARGN/MI_MARGN.php",
                `Accept-Encoding`= "gzip, deflate",
                `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
                Cookie= "_ga=GA1.3.1044226996.1457253325; __utma=193825960.1044226996.1457253325.1474960397.1474962732.83; __utmc=193825960; __utmz=193825960.1474789123.75.39.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)"
              ),
              body=paste0("download=&qdate=",year,"%2F",mons,
                          "%2F",day,"&selectType=24"))
  
  
  tables=httr::content(res) %>%
    rvest::html_table(fill = T) %>% 
    .[[1]] %>% 
    .[-(1:3),]
  
  colnames(tables) <- c("code", "name", "MNew",	"MRedemption",	"MOutstanding",	"MYesterdayRemain",	"MTodayRemain",	"MTodayLimit",
                        "SRedemption",	"SNew",	"SOutstanding",	"SYesterdayRemain",	"STodayRemain",	"STodayLimit","difference","note")
  tables[,3:15] <- lapply(3:15, function(x){
    gsub(',','',tables[,x]) %>% as.numeric()
  }) %>% do.call(cbind,.)
  return(tables)
}



