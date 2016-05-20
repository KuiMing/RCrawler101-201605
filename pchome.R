
res <- GET("http://ecshweb.pchome.com.tw/search/v3.3/all/results?q=sony&page=1&sort=rnk/dc")
json <- content(res,'text',encoding = 'utf8')
pchome <- fromJSON(json)
