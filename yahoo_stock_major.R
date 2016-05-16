library(httr)
library(XML)
library(dplyr)
url="https://tw.stock.yahoo.com/d/s/major_1301.html"
res=GET(url)
resStr=content(res,'text')
html_page=htmlParse(resStr,encoding = 'utf8')
table=readHTMLTable(html_page)
filter_condition = (sapply(table,NCOL)==8)&(sapply(table,NROW) <= 15)
data_table = table[filter_condition][[1]]

colnames(data_table)[c(1,5)]="Broker"
colnames(data_table)[c(4,8)]="Difference"
data_table=rbind(data_table[,1:4],data_table[,5:8]) 
colnames(data_table)[2:3]=c("Buy","Sell")
data_table=mutate(data_table,Buy=as.numeric(as.character(Buy)),
                  Sell=as.numeric(as.character(Sell)),
                  Difference=as.numeric(as.character(Difference)))
