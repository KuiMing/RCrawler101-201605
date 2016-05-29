#!/usr/bin/env Rscript

library(RSelenium)
library(data.table)
library(magrittr)
library(stringr)
options(digits = 16)
URL <- "https://tw.stock.yahoo.com/q/bc?s=3008"

driver <- remoteDriver(remoteServerAddr="localhost", port=4444, browserName="firefox")
driver$open()

# method 1: use findElement to force html render and parse the rendered source
driver$navigate(URL)
highchart <- driver$findElement(using="class name", "highcharts-series-group")
series0 <- highchart$findElement(using="class name", "highcharts-series-0")
psrc <- driver$getPageSource()
# then parse the source whatever you want...

# method 2: using js <= this is the recommended way
driver$navigate(URL)
d <- driver$executeScript("return document.getElementsByClassName('highcharts-tracker')[1].getAttribute('d')")
res <- strsplit(d[[1]], ' ') %>% 
  unlist %>% 
  split(., ceiling(seq_along(.)/3)) %>%
  do.call(rbind, .) %>%
  .[-c(1,2,273),3] %>% 
  as.numeric()

# notice that the x-y is SVG-specific: the origin is on the top-left

test <- data.frame(x=c(max(res),min(res)),
                   y=c(2670,2715),
                   stringsAsFactors = FALSE)


res1 <- str_extract_all(psrc,'y="15">[0-9]+[.]*[0-9]*') %>% 
  .[[1]] %>% 
  gsub('y="15">','',.) %>% 
  as.numeric()

tick_value <- data.frame(x=c(min(res),max(res)),
                         y=res1[10:11],
                         stringsAsFactors = FALSE) %>%
  lm(y~x,.) %>% 
  predict(data.frame(x=res)) %>% 
  round()



