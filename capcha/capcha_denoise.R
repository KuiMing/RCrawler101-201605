library(mmand)
library(raster)
library(imager)
library(magrittr)
library(reshape2)
library(jpeg)
capcha_denoise <- function(file){
  im <- load.image(file)
  imp <- erode(im,k) %>% # erosion
    gaussianSmooth(1)    # blur 
  
  tmp <- deriche(imp,2,order=2,axis="y")+
    deriche(imp,2,order=2,axis="x") %>%  # edge filter
    dilate(k)                            # dilation
  tmp <-array(tmp,dim=c(200,60,1,3))
  tmp1 <- matrix(0,nrow=200,ncol=60)
  for (i in 1:3){
    tmp1 <- tmp1+tmp[1:200,1:60,,i]
  }
  
  tmp1 <- t(tmp1)
  writeJPEG(tmp1,'tmp.jpeg')
  tmp <- raster('tmp.jpeg')
  
  # find word
  SP <- rasterToPolygons(clump(tmp>30),dissolve = T) 
  plot(SP)
  
  
  len <- sapply(1:length(SP@plotOrder), function(x){
    length(SP@polygons[[x]]@Polygons)
  })
  all_area <- sapply(1:length(SP@plotOrder), function(x){
    y <- sapply(1:len[x], function(i){
      coord <- SP@polygons[[x]]@Polygons[[i]]@coords
      w <- max(coord[,1])-min(coord[,1])
      h <- max(coord[,2])-min(coord[,2])
      right <- max(coord[,1])
      left <- min(coord[,1])
      c(x,i,w,h,right,left)
    })
  })
  
  if(is.list(all_area)){
    all_area <- do.call(cbind,all_area)
  }
  ind <- which(all_area[3,]>=15 & all_area[4,]>=15 & all_area[3,]<60)
  target <- all_area[,ind] 
  ind <- which(abs(target[3,]-target[4,])<20)
  target <- target[,ind]
  ind <- which(duplicated(target[1,])) 
  ind <- which(abs(target[5,ind]-target[5,ind-1])<20) %>% 
    ind[.]
  if (length(ind)>0){
    target <- target[,-ind]
  }
  
  all_cap <- matrix(0,nrow=5,ncol=2400)
  cap <- readJPEG('tmp.jpeg')
  cap[cap>mean(cap)+sd(cap)]=1
  for (i in 1:dim(target)[2]){
    x <- target[1,i]
    y <- target[2,i]
    coord <- SP@polygons[[x]]@Polygons[[y]]@coords
    right <- min(coord[,1])
    if (right<1){right=1}
    left <- right+39
    if (left>200){left=200}
    w <- melt(cap[,right:left])
    all_cap[i,1:((left-right+1)*60)] <- w[,3]
    plot(0:1,0:1,type="n",ann=FALSE,axes=FALSE,asp=60/40)
    rasterImage(cap[,right:left],0,0,1,1)
    # plot(coord,type='l',xlim=c(min(coord[,1]),min(coord[,1])+40))
    Sys.sleep(1)
  }
  return(all_cap)
}

# well separated
all_cap <- capcha_denoise('cap146.jpeg')
# NG
all_cap <- capcha_denoise('cap1361.jpeg')

