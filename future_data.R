library(WriteXLS)

source('Github/RCrawler101-201605/future_institutional.R')
source('Github/RCrawler101-201605/future_total.R.R')

source("Github/RCrawler101-201605/for_trading_date.R")
som <- function(x) {
  as.Date(format(x, "%Y-%m-1"))
}

date=som(Sys.Date())
y=c()
for (i in 1:60){
  year=format(date,"%Y")
  month=format(date,"%m")
  x=TWSE_csv('1101',year,month)
  y=append(y,as.Date(index(x)))
  date=som(date-1)
}

result <- lapply(1:length(y), function(x){
  date=y[x]
  print(date)
  year=format(date, "%Y")
  month=format(date,"%m")
  day=format(date,"%d")
  insti=future_insti(year,month,day)
  total=future_total(year,month,day)
  data=data.frame(matrix(c(insti$多方未平口數[1:3],
                           sum(insti$多方未平口數[1:3]),
                           total$未沖銷部位數[3]-sum(insti$多方未平口數[1:3]),
                           insti$空方未平口數[1:3],
                           sum(insti$空方未平口數[1:3]),
                           total$未沖銷部位數[3]-sum(insti$空方未平口數[1:3]),
                           total$未沖銷部位數[3]),nrow = 1),
                  stringsAsFactors = F)
  colnames(data) <- c('自多','投多','外多','法多','散多',
                      '自空','投空','外空','法空','散空',
                      '總未')
  data$date=date
  return(data)
})
result <- do.call(rbind,result)
WriteXLS(result, 'result.xls')

library(gmailr)
msg = mime() %>%
  from("kmchen0901@gmail.com") %>%
  to("benjamin0901@gmail.com") %>%
  subject('semiconductor') %>%
  html_body(today) %>%
  attach_file('result.xls')
send_message(msg)
