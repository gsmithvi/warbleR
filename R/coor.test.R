#' Randomization test for singing coordination 
#' 
#' \code{coor.test} Monte Carlo randomization test to assess the statistical significance of singing coordination
#' @usage coor.test(X, iterations = 1000, less.than.chance = TRUE, parallel = 1)
#' @param  X Data frame containing columns for singing event (sing.event), 
#' individual (indiv), and start and end time of signal (start and end).
#' @param iterations number of iterations for shuffling and calculation of the expected number of overlaps. Default is 1000.
#' @param less.than.chance Logical. If \code{TRUE} the test evaluates whether overlaps occur less often than expected by chance.
#' If \code{FALSE} the opposite pattern is evaluted (whether overlaps occur more often than expected by chance). 
#' Default is  \code{TRUE}.
#' @param parallel Numeric. Controls whether parallel computing is applied.
#'  It specifies the number of cores to be used. Default is 1 (i.e. no parallel computing).
#' @return A data frame with the observed number of overlaps (obs.overlaps), mean number of overlaps expected by chance,
#' and p value.  
#' @export
#' @name coor.test
#' @details This function calculates the probability of finding and equal or lower number 
#' (or higher if les.than.chance is \code{TRUE}) of song overlaps in a coordinated singing event. 
#' The function shuffles the sequences of signals and silence-between-signals for both individuals to produce 
#' a null distribution of expected number of overlaps by chance. The observed number of overlaps is compared to this
#' expected values. The p-values are calculated as the proportion of random expected values that were lower (or higher) 
#' than the observed value. The function runs one test for each singing event in the input data frame. The function 
#' is equivalent to the "KeepGaps" methods described in Masco et al. 2015.
#' @references Masco, C., Allesina, S., Mennill, D. J., and Pruett-Jones, S. (2015). The Song Overlap Null model Generator (SONG): a new tool for distinguishing between random and non-random song overlap. Bioacoustics. 1-12. 
#' @examples
#' \dontrun{
#' #load  simulated singing data (see data documentation)
#' data(coor.sing)
#' 
#' # testing if coordination happens less than expected by chance
#' coor.test(coor.sing, iterations = 1000, less.than.chance = TRUE)
#' 
#' # testing if coordination happens more than expected by chance
#' coor.test(coor.sing, iterations = 1000, less.than.chance = FALSE)
#' }
#' @author Marcelo Araya-Salas (\email{araya-salas@@cornell.edu})
#last modification on jul-5-2016 (MAS)

coor.test <- function(X = NULL, iterations = 1000, less.than.chance = TRUE, parallel = 1)
{
  if(!is.data.frame(X))  stop("X is not a data frame")
  
  #stop if some events have less than 10 observations
  if(any(table(X$sing.event) < 10)) warning("At least one singing event with less than 10 vocalizations")
  
  #stop if some events do not have 2 individuals 
      qw <- as.data.frame((tapply(X$sing.event, list(X$sing.event, X$indiv), length)))

qw[qw > 0] <- 1

if(any(apply(qw, 1, sum) != 2)) stop("Some singing events don't have 2 interating individuals ('indiv' colum)")

  #if iterations is not vector or length==1 stop
  if(any(!is.vector(iterations),!is.numeric(iterations))) stop("'interations' must be a numeric vector of length 1") else{
    if(!length(iterations) == 1) stop("'interations' must be a numeric vector of length 1")}
  
  #if there are NAs in start or end stop
  if(any(is.na(c(X$end, X$start)))) stop("NAs found in start and/or end")  
  
  interations <- round(iterations)
  
  #interations should be positive
  if(iterations < 1) stop("'iterations' must be a positive integer")
  
  #if parallel is not numeric
  if(!is.numeric(parallel)) stop("'parallel' must be a numeric vector of length 1") 
  if(any(!(parallel %% 1 == 0),parallel < 1)) stop("'parallel' should be a positive integer")
  
    #create function to randomized singing events
      coortestFUN <- function(X, h){
  sub<-X[X$sing.event==h,]
  
  #remove solo singing
  sub<-sub[order(sub$start),]
  
  fst <- max(c(which(sub$start==min(sub$start[sub$indiv==unique(sub$indiv)[1]])),
               which(sub$start==min(sub$start[sub$indiv==unique(sub$indiv)[2]])))) - 1
  
  lst <- min(c(which(sub$start==max(sub$start[sub$indiv==unique(sub$indiv)[1]])),
               which(sub$start==max(sub$start[sub$indiv==unique(sub$indiv)[2]])))) + 1
  
  sub <- sub[fst:lst, ]
  
  sub1<-sub[sub$indiv==unique(sub$indiv)[1], ]
  sub2<-sub[sub$indiv==unique(sub$indiv)[2], ]
  
  
  #determine which ones overlap (observed)
  ovlp<-sapply(2:nrow(sub),function(i) {
    if(sub$start[i]>sub$start[i-1] & sub$start[i]<sub$end[i-1])  
      "ovlp" else "No ovlp"})
  
  
  #null model
  #duration of signals
  dur1<-sub1$end-sub1$start
  dur2<-sub2$end-sub2$start
  
  #duration of gaps
  gap1<-sapply(1:(nrow(sub1)-1),function(x) {sub1$start[x+1]-sub1$end[x]})
  gap2<-sapply(1:(nrow(sub2)-1),function(x) {sub2$start[x+1]-sub2$end[x]})
  
  rov<-sapply(1:iterations,function(x){
    gap1<-gap1[sample(1:length(gap1),length(gap1))]
    gap2<-gap2[sample(1:length(gap2),length(gap2))]
    dur1<-dur1[sample(1:length(dur1),length(dur1))]
    dur2<-dur2[sample(1:length(dur2),length(dur2))]
    
    nbt1<-NULL
    for(i in 1:(length(dur1)-1))
    {nbt1[i]<-dur1[i]+gap1[i]
    if(i!=1) nbt1[i]<-nbt1[i]+nbt1[i-1]}  
    nbt1<-c(0,nbt1)
    nbt1<-nbt1+min(sub1$start)
    net1<-nbt1+dur1
    
    nbt2<-NULL
    for(i in 1:(length(dur2)-1))
    {nbt2[i]<-dur2[i]+gap2[i]
    if(i!=1) nbt2[i]<-nbt2[i]+nbt2[i-1]}  
    nbt2<-c(0,nbt2)
    nbt2<-nbt2+min(sub2$start)
    net2<-nbt2+dur2
    
    ndf<-data.frame(chan=c(rep(1,length(nbt1)),rep(2,length(nbt2))),nbt=c(nbt1,nbt2),net=c(net1,net2))
    ndf<-ndf[order(ndf$nbt),]
    rownames(ndf)<-1:nrow(ndf)
    
    rovlp<-sapply(2:nrow(ndf),function(i) {
      if(ndf$nbt[i]>ndf$nbt[i-1] & ndf$nbt[i]<ndf$net[i-1])  
        "ovlp" else "No ovlp"})
    return(length(rovlp[rovlp=="ovlp"]))
  })
  
  #resutls
  obs.overlaps <- length(ovlp[ovlp=="ovlp"])
  mean.random.ovlps <- mean(rov)
  if(less.than.chance) p <- length(rov[rov <= obs.overlaps])/iterations else p <- length(rov[rov >= obs.overlaps])/iterations
  l <- data.frame(h, obs.overlaps, mean.random.ovlps, p)
  
  return(l)}
      # )

    if(parallel > 1) {if(Sys.info()[1] == "Windows") {
      
      cl <- parallel::makeCluster(parallel)
      
      doParallel::registerDoParallel(cl)
      
      cote <- parallel::parLapply(cl, unique(X$sing.event), function(h)
      {
        coortestFUN(X, h)
      })
      
      parallel::stopCluster(cl)
      
    } else {    # Run parallel in other operating systems
      
      cote <- parallel::mclapply(unique(X$sing.event), function(h) {
        coortestFUN(X, h)
        })
      
      }
    } else {cote <- pbapply::pblapply(unique(X$sing.event), function(h) 
    { 
      coortestFUN(X, h)
    })
    
    }
    
  df <- do.call(rbind, cote)
    
colnames(df) <- c("sing.event", "obs.ovlps", "mean.random.ovlps", "p.value")

return(df)
}
