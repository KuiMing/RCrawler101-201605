
alphabet <- c(LETTERS,0:9)
model <- lapply(alphabet, function(i){
  jpeg('alphabet.jpeg')
  par(bg='black')
  plot(0,0,pch=i,cex=5,ann=F,axes=F,col='white')
  dev.off()
  cap <- readJPEG('alphabet.jpeg') %>% 
    rowMeans(dim=2)
  x <- which(cap==1,arr.ind = T)
  xlimit <- sort(x[,1]) %>% .[c(1,length(x[,1]))] %>% 
    `+`(.,c(-1,1))
  ylimit <- sort(x[,2]) %>% .[c(1,length(x[,2]))] %>% 
    `+`(.,c(-1,1))
  cap <- cap[xlimit[1]:xlimit[2],ylimit[1]:ylimit[2]]
  cap <- resize(cap,50,50) %>% 
    melt() %>% 
    .[,3]
})
model <- do.call(rbind,model)
# par(bg='white')
# plot(0:1,0:1,asp=1)
# matrix(model[33,],nrow = 50,ncol = 50) %>% 
#   rasterImage(0,0,1,1)
# No I, 1, 0, O, M, W, S, 5
remove_alpha <- c("1","I","O","0","5","S","M","W")
ind <- sapply(remove_alpha, function(x){which(alphabet==x)})

model <- model[-ind,]
alphabet <- alphabet[-ind]
svm_model <- svm(model,factor(alphabet))

test <- capcha_denoise('cap71.jpeg')                 
predict(svm_model,test)
