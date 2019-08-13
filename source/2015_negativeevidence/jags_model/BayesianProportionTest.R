
BayesianPropTest <- function( counts, sizes , prior=c(1,1) ){
  
  n <- sum(sizes)
  k <- sum(counts)
  
  x <- seq(0,1,.01)
  px <- dbeta(x,prior[1],prior[2])
  
  nullLikelihood <- 0
  al1 <- 0 
  al2 <- 0
  for( i in seq_along(x) ) {
    p1<- dbinom(counts[1],sizes[1],x[i])
    p2 <- dbinom(counts[2],sizes[2],x[i])
    nullLikelihood <- nullLikelihood + px[i]*p1*p2
    al1 <- al1 + px[i]*p1
    al2 <- al2 + px[i]*p2 
  }
  alternativeLikelihood <- al1 * al2
  
  BF <- nullLikelihood / alternativeLikelihood 
  return( BF )
  
}