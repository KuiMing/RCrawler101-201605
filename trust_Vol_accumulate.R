library(data.table)
library(magrittr)
library(httr)
library(rvest)
library(quantmod)
library(purrr)

# 搜尋證券交易所的投信買賣超彙總表

url = 'http://www.twse.com.tw/en/trading/fund/TWT44U/TWT44U.php'

stock="1215"
stock_data=paste0(stock,'.TW') %>% 
  getSymbols(auto.assign = FALSE)
stock_data=stock_data[Vo(stock_data)>0]
date=index(stock_data) %>% 
  as.Date() %>% 
  format("%Y/%m/%d")

trust_Vol_dif=sapply(1:length(date),function(x){
  res=POST(url,
           add_headers(
             `Content-Type`= "application/x-www-form-urlencoded"
           ),
           body = paste0('download=html&qdate=',date[x],'&sorting=by_issue'))
  tables=content(res,encoding = 'utf8') %>%
    html_table(fill = T) %>% 
    .[[1]] %>% 
    as.data.table()
  tables=setkey(tables,X2)[.(stock)] %>% 
    .[,c("X5"),with=F]
})


trust_Vol_dif=as.numeric(gsub(',','',trust_Vol_dif))
trust_Vol_dif[is.na(trust_Vol_dif)]=0

df=data.frame(date=date,
              Cl(stock_data),
              trust_accumu=accumulate(trust_Vol_dif,`+`))
names(df)[2]="Close"
Dashed <-  gvisLineChart(df, xvar="date", yvar=c("Close","trust_accumu"),
                         options=list(
                           height=600,
                           series="[{color:'green', targetAxisIndex: 0,
                           lineWidth: 2},
                           {color: 'blue',targetAxisIndex: 1,
                           lineWidth: 2, lineDashStyle: [4, 1]}]",
                           vAxes="[{title:'Close'}, {title:'投信買賣超累計'}]"
                         ))
plot(Dashed)

