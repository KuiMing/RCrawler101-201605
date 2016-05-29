#!/usr/bin/env Rscript
# By Kyle

library(RSelenium)
library(data.table)
library(magrittr)
URL <- "https://tw.stock.yahoo.com/q/bc?s=2325"

driver <- remoteDriver(remoteServerAddr="localhost", port=4444, browserName="chrome")
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
    as.data.table
res # notice that the x-y is SVG-specific: the origin is on the top-left
    


