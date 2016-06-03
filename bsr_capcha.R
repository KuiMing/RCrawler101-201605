library(RSelenium)
library(stringr)
library(magrittr)
URL <- "http://bsr.twse.com.tw/bshtm/bsMenu.aspx"

driver <- remoteDriver(remoteServerAddr="localhost", port=4444, browserName="firefox")
driver$open()
for (i in 1:2000){
  driver$navigate(URL)
  psrc <- driver$getPageSource()
  img <- str_extract_all(psrc,'CaptchaImage.aspx[?]guid=[0-9a-z]+-[0-9a-z]+-[0-9a-z]+-[0-9a-z]+-[0-9a-z]+') %>% 
    paste0("http://bsr.twse.com.tw/bshtm/",.)
  paste0("/Users/benjamin/capcha/cap",i,".jpeg") %>% 
  download.file(img,destfile = .)
#   Sys.sleep(sample(10:60,1))
}
