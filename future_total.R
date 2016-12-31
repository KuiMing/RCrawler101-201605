library(httr)
library(XML)

url='https://www.taifex.com.tw/chinese/3/7_8.asp'

form='pFlag=&yytemp=2016&mmtemp=12&ddtemp=23&chooseitemtemp=TX+++++&goday=&choose_yy=2016&choose_mm=12&choose_dd=23&datestart=2016%2F12%2F23&choose_item=ALL'
res<-POST(url,
          add_headers(
            Host= "www.taifex.com.tw",
            Connection= "keep-alive",
            `Content-Length`= 150,
            `Cache-Control`= "max-age=0",
            Origin= "https://www.taifex.com.tw",
            `Upgrade-Insecure-Requests`= 1,
            `User-Agent`= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36",
            `Content-Type`= "application/x-www-form-urlencoded",
            Accept= "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
            Referer= "https://www.taifex.com.tw/chinese/3/7_8.asp",
            `Accept-Encoding`= "gzip, deflate, br",
            `Accept-Language`= "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
            Cookie= "ASPSESSIONIDCCBBRQTB=LGICHOBBOEOKGGJONJCOIAIF; AX-cookie-POOL_PORTAL=AGACBAKM; AX-cookie-POOL_PORTAL_web3=ADACBAKM; ASPSESSIONIDCADDTTRA=DHEHFKOBLCKGOOHKHEHEODPC"
          ),
          body = form)

resStr=content(res,'text')
html <- htmlParse(resStr)
tbl <- readHTMLTable(html,stringsAsFactors = F)
