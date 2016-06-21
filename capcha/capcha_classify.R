cap <- readJPEG('/Users/benjamin/capcha/cap9.jpeg') %>% 
  rowMeans(dims=2) %>% 
  melt() %>% 
  .[,3] %>% 
  SMA(10)
cap[is.na(cap)]=0
cap <- matrix(cap,nrow=60,ncol=200)
cap[cap<(mean(cap)+sd(cap)*0.5)]=0
cap[cap>(mean(cap)+sd(cap)*0.6)]=1
cap <- cap %>% 
  melt() %>% 
  .[,3] %>% 
  SMA(10)
cap[is.na(cap)]=0
cap <- matrix(cap,nrow=60,ncol=200)
cap[cap<0.4]=0
plot(0:1,0:1,type="n",ann=FALSE,axes=FALSE,asp=60/40)
rasterImage(cap,0,0,1,1)

path <- '/Users/benjamin/capcha/'
file <- dir(path)
all_cap <- lapply(1:length(file), function(x){
  cap <- paste0(path,file[x]) %>% readJPEG()
  cap <- rowMeans(cap,dims = 2) %>% 
    melt() %>% 
    .[,3] %>% 
    SMA(10)
  cap[is.na(cap)]=0
  cap <- matrix(cap,nrow=60,ncol=200)
  cap[cap<(mean(cap)+sd(cap)*0.5)]=0
  cap[cap>(mean(cap)+sd(cap)*0.6)]=1
  ind <- matrix(1:12000,nrow=5,ncol=2400,byrow = TRUE)
  cap_db <- cap %>% 
    melt() %>% 
    mutate(Var1=rep(1:(60*40),5))
  for (i in 1:5) {ind[i,]=cap_db$value[ind[i,]]}
  return(ind)
})

all_cap=do.call(rbind,all_cap)
tmp <- lapply(1:dim(all_cap)[1], function(x){
  cap <- all_cap[x,] %>% 
    SMA()
  cap[is.na(cap)]=0
  cap[cap<(mean(cap)+sd(cap)*0.5)]=0
  cap[cap>(mean(cap)+sd(cap)*0.6)]=1
  return(cap)
})
tmp <- do.call(rbind,tmp)
kmeans_c <- kmeans(all_cap,centers = 36)
for (i in 1:36){
  paste0("mkdir /Users/benjamin/capcha/cap_",i) %>% 
  system()
  setwd(paste0("/Users/benjamin/capcha/cap_",i))
  temp <- all_cap[kmeans_c$cluster==i,]
  for (j in 1:dim(temp)[1]){
    matrix(temp[j,], nrow = 60, ncol = 40) %>% 
      writeJPEG(target = paste0('cap',j,'.jpeg'))  
  }
}


recov <- matrix(temp[2,], nrow = 60, ncol = 40) %>% 
  rasterImage(0,0,1,1)
