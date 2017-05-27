#!/usr/bin/env Rscript
# system('export LANG=zh_TW.UTF-8')
library(data.table)
library(readxl)
library(quantmod)
library(xlsx)
library(dplyr)
som <- function(x) {
  as.Date(format(x, "%Y-%m-1"))
}

fund=function(fund_source,date=format(Sys.time(),"%Y/%m/%d")){
  if (fund_source %in% 'foreign'){
    url = 'http://www.twse.com.tw/en/fund/TWT38U?response=html&date='
  }
  if (fund_source %in% 'trust'){
    url = 'http://www.twse.com.tw/en/fund/TWT44U?response=html&date='
  }
  if (fund_source %in% 'dealer'){
    url = 'http://www.twse.com.tw/en/fund/TWT43U?response=html&date='
  }
#   res=httr::POST(url,
#                  httr::add_headers(
#                    `Content-Type`= "application/x-www-form-urlencoded"
#                  ),
#                  body = paste0('download=html&qdate=',date,'&sorting=by_issue'))
  url=paste0(url,date)
  res=httr::GET(url)
  tables=httr::content(res,encoding = 'utf8') %>%
    rvest::html_table(fill = T,header=F)
  tables=tables[[1]] %>%
    data.table::as.data.table()
  if (fund_source %in% 'dealer'){
    tables=tables[-(1:3),c("X1","X10"),with=F]
  }else {
    tables=tables[-(1:2),c("X2","X5"),with=F]
  }
  colnames(tables)=c('code','difference')
  tables$difference=as.numeric(gsub(',','',tables$difference))
  return(tables)
}
homework=read_excel('半導體Ben.xlsx',sheet=1,col_types = rep("text",13))
colnames(homework)[1]='code'

count=0
Date=Sys.Date()
today=format(Date,"%Y%m%d")
while (count<3){
  tables=c('foreign','trust','dealer') %>%
    lapply(function(x,date=format(Date,'%Y/%m/%d')){
    x=fund(x,date)
    x=setkey(x,code)[.(homework$code)]
    x=x[is.na(difference)==T,difference:=0]
  })

  if (abs(sum(tables[[1]]$difference))>0){
    if (is.na(homework[1,3])){
      for (i in seq(3,7,2)){
        homework[,i:(i+1)]=tables[[i %/% 2]][,difference]
      }
    }else {
      for (i in seq(4,8,2)){
        homework[,i]=homework[,i]+tables[[(i-1) %/% 2]][,difference]
      }
    }

    count=count+1
  }
  Date=Date-1
}
Sys.sleep(60)
source("Github/RCrawler101-201605/TWSE_csv.R")

ym=c(som(som(som(Sys.Date())-1)-1),
     som(som(Sys.Date())-1),
     som(Sys.Date()))
year <- sapply(ym, function(x){
  format(x,"%Y")
})
mons <- sapply(ym, function(x){
  format(x,"%m")
})

temp=lapply(homework$code, function(x){
  print(x)
  # y=getSymbols(paste0(x,'.TW'),auto.assign = F)
  y <- rbind(TWSE_csv(x,year[1],mons[1]),
             TWSE_csv(x,year[2],mons[2]),
             TWSE_csv(x,year[3],mons[3]))
  k=as.numeric(tail(Cl(y),1)-tail(SMA(Cl(y),20),1))>0
  rsi50=as.numeric(tail(RSI(Cl(y),10),1)) %>% round()
  V=diff(as.numeric(tail(Vo(y),2)))
  z=data.frame(k,rsi50, V>0)
  return(z)
})


ye <- format(Sys.Date(), "%Y") %>%
  as.numeric()

day <- format(Sys.Date(),"%d")
source('Github/RCrawler101-201605/TWSE_margin.R')
margin <- TWSE_margin(ye,mons[3],day) %>%
  filter(code %in% homework$code)
homework <- filter(homework,code %in% margin$code)


homework[,9:11]=do.call(rbind,temp)
homework[,3:8]=floor(homework[,3:8]/1000)
homework[,12]=margin$MNew-margin$MRedemption
homework[,13]=margin$SNew-margin$SRedemption
# for (x in 3:11){
#   homework[which(homework[,x]==TRUE),x] <- "有"
#   homework[which(homework[,x]==FALSE),x] <- ""
# }
names(homework)[1] <- "代號"
homework <- homework[,c(1:3,5,7,12,13,11,9,10)]
# write.xlsx(homework, file=paste0('半導體_',today,'.xls'))
write.table(homework, file=paste0('半導體_',today,'.xls'), sep = '\t',
            fileEncoding = 'big5',row.names = F)
system(paste('open',paste0('半導體_',today,'.xls')))
# res=html_session(url,body=paste0('download=html&qdate=',date,'&sorting=by_issue'))
# html_table(res,fill=T)
