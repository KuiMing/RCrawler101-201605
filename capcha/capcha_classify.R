# cap <- readJPEG('/Users/benjamin/capcha/cap9.jpeg') %>% 
#   rowMeans(dims=2) %>% 
#   melt() %>% 
#   .[,3]
# cap[is.na(cap)]=0
# cap <- matrix(cap,nrow=60,ncol=200)
# plot(0:1,0:1,type="n",ann=FALSE,axes=FALSE,asp=60/40)
# rasterImage(cap,0,0,1,1)

path <- '/Users/benjamin/capcha/'
file <- dir(path) %>% grep('.*.jpeg',.,value=T)
all_cap <- lapply(1:length(file), function(x){
  print(file[x])
  cap <- paste0(path,file[x]) %>% capcha_denoise()
  return(cap)
})
system(paste0("say {{'",geterrmessage(),"'}}"))
all_cap=do.call(rbind,all_cap)
# No I, 1, 0, O, M, W, S, 5
kmeans_c <- kmeans(all_cap,centers = 36-8)
for (i in 1:28){
  paste0("mkdir /Users/benjamin/capcha/cap_",i) %>% 
  system()
  setwd(paste0("/Users/benjamin/capcha/cap_",i))
  temp <- all_cap[kmeans_c$cluster==i,]
  for (j in 1:dim(temp)[1]){
    matrix(temp[j,], nrow = 60, ncol = 40) %>% 
      writeJPEG(target = paste0('cap',j,'.jpeg'))  
  }
}


recov <- matrix(test[5,], nrow = 50, ncol = 50) %>% 
  rasterImage(0,0,1,1)
