load('/home/pi/future.RData')
date=Sys.Date()
source('/home/pi/Github/RCrawler101-201605/future_institutional.R')
source('/home/pi/Github/RCrawler101-201605/future_total.R')
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
y=rbind(y,data)

library(plotly)
library(htmlwidgets)
p=ggplot(y,aes(x=date))+
  geom_line(aes(y=外空),color='red')+
  geom_line(aes(y=散空),color='blue')+
  geom_line(aes(y=`總未`))
pp=ggplotly(p)
saveWidget(pp, file='/home/pi/Github/investment/future_short.html', selfcontained=F)

p=ggplot(y,aes(x=date))+
  geom_line(aes(y=外多),color='red')+
  geom_line(aes(y=散多),color='blue')+
  geom_line(aes(y=`總未`))
pp=ggplotly(p)
saveWidget(pp, file='/home/pi/Github/investment/future_long.html', selfcontained=F)


library(gmailr)
msg = mime() %>%
  from("kmchen0901@gmail.com") %>%
  to("benjamin0901@gmail.com") %>%
  subject('future') %>%
  html_body('https://kuiming.github.io/investment/future_long.html')
send_message(msg)
