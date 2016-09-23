library(rvest)
library(dplyr)
res <- read_html('http://isin.twse.com.tw/isin/C_public.jsp?strMode=2',encoding = 'big5')
node <- html_nodes(res,xpath = "//table[@class='h4']")
x <- html_table(node,fill=T) %>%
  .[[1]] %>%
  .[,c(1,2,5)] %>%
  mutate(X2=as.numeric(substr(X1,1,1))) %>%
  mutate(X2=is.na(X2)) %>%
  filter(X2 == FALSE)
y=strsplit(x$X1,'\\s+') %>% do.call(rbind,.)
x <- x %>%
  mutate(X1=y[,1],X2=y[,2])

res <- read_html('http://isin.twse.com.tw/isin/C_public.jsp?strMode=4',encoding = 'big5')
node <- html_nodes(res,xpath = "//table[@class='h4']")
z <- html_table(node,fill=T) %>%
  .[[1]] %>%
  .[,c(1,2,5)] %>%
  mutate(X2=as.numeric(substr(X1,1,1))) %>%
  mutate(X2=is.na(X2)) %>%
  filter(X2 == FALSE)
y=strsplit(z$X1,'\\s+') %>% do.call(rbind,.)
z <- z %>%
  mutate(X1=y[,1],X2=y[,2])

x=rbind(x,z)

save(x,file = "all_code.RData")



