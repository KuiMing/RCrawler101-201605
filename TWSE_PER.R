TWSE_PER <- function(year=105, month="09", day="22"){
  url <- "http://www.twse.com.tw/ch/trading/exchange/BWIBBU/BWIBBU_d.php"
  form <- paste0("input_date=",year,"%2F",month,"%2F",day,
                 "&select2=ALL&order=STKNO&login_btn=%ACd%B8%DF")
  res=httr::POST(url,
                 httr::add_headers(
                   Host= "www.twse.com.tw",
                   Connection= "keep-alive",
                   `Content-Length`= "69",
                   `Cache-Control`= "max-age=0",
                   Origin= "http://www.twse.com.tw",
                   `Upgrade-Insecure-Requests`= "1",
                   `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",
                   Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                   Referer= "http://www.twse.com.tw/ch/trading/exchange/BWIBBU/BWIBBU_d.php",
                   `Accept-Encoding`= "gzip, deflate",
                   `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
                   Cookie= "_ga=GA1.3.1044226996.1457253325; __utma=193825960.1044226996.1457253325.1474789123.1474800454.76; __utmc=193825960; __utmz=193825960.1474789123.75.39.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)",
                   `Content-Type`= "application/x-www-form-urlencoded"
                 ),
                 body = form)
  
  tables=httr::content(res,encoding = 'big5') %>%
    rvest::html_table(fill = T) %>% 
    .[[8]] %>% 
    .[-1,]
  colnames(tables) <- c('code','name','PER','DY','PBR')
  return(tables)
}
