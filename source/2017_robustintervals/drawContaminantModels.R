x <- seq(-5,5,.01)
x2 <- seq(-20,20,.01)
target <- dnorm(x,mean=0,sd=1)

layout(matrix(1:2,1,2))

w<-.3
contaminant <- dnorm(x2,mean=0,sd=5)
plot(x,target*(1-w),type="l",lwd=1,xlim=c(-10,10),bty="n",
     xlab="",ylab="",main="(a) Unbiased Contaminants",
     font.main=1,axes=FALSE)
polygon(x2,contaminant*w,lwd=2,col = "grey")
polygon(x,target*(1-w),density = 10)


w<-.3
contaminant <- dnorm(x2,mean=5,sd=2)
plot(x,target*(1-w),type="l",lwd=1,xlim=c(-10,10),bty="n",
     xlab="",ylab="",main="(b) Biased Contaminants",
     font.main=1,axes=FALSE)
polygon(x2,contaminant*w,lwd=2,col = "grey")
polygon(x,target*(1-w),density = 10)


w<-.3


# contaminant <- dnorm(x2,mean=5,sd=2)*.5 +
#   dnorm(x2,mean=0,sd=5)*.2 + dnorm(x2,mean=-3,sd=1)*.25 +
#   dnorm(x2,mean=-8,sd=.25)*.05
# plot(x,target*(1-w),type="l",lwd=1,xlim=c(-10,10),bty="n",
#      xlab="",ylab="",main="(c) Unbiased Clumpy",
#      font.main=1,axes=FALSE)
# polygon(x2,contaminant*w,lwd=2,col = "grey")
# polygon(x,target*(1-w),density = 10)


layout(1)