#' Import Raven selections
#' 
#' \code{imp.raven} Imports Raven selection data from many files simultaneously. Files must be in .txt format.
#' @usage imp.raven(path = NULL, sound.file.col = NULL, all.data = FALSE, recursive = FALSE)  
#' @param path A character string indicating the path of the directory in which to look for the text files. 
#' If not provided (default) the function searches into the current working directory. Default is \code{NULL}).
#' @param sound.file.col A character string with the name of the column listing the sound files in 
#' the selection text files. Default is \code{NULL}).
#' @param all.data Logical. If \code{TRUE}) all columns in text files are returned. Default is \code{FALSE}). Note 
#' that all files should contain exactly the same columns in the same order. 
#' @param recursive Logical. If \code{TRUE}) the listing recurse into sub-directories.
#' @return A single data frame with the information from the selection files. If all.data argument is set to \code{FALSE}) the data 
#' frame contains the following columns: selec, start, end, and selec.file. If sound.file.col is provided the data frame
#' will also contain a sound.file column. In addition, all rows with duplicated data are removed. This is useful when 
#' both spectrogram and waveform views are included in the Raven selection files. If all.data is set to \code{TRUE}) then all 
#' columns in selection files are returned.
#' @export
#' @name imp.raven
#' @examples
#' \dontrun{
#' # First create empty folder
#' dir.create(file.path(getwd(),"temp"))
#' setwd(file.path(getwd(),"temp"))
#' 
#' data(selection.files)
#' 
#' write.table(selection.files[[1]],file = "100889-Garrulax monileger.selections.txt",
#' row.names = F, sep= "\t")
#' 
#' write.table(selection.files[[2]],file = "1023-Arremonops rufivirgatus.selections.txt",
#' row.names = F, sep= "\t")
#' 
#' #providing the name of the column with the sound file names
#' rav.dat<-imp.raven(sound.file.col = "End.File", all.data = FALSE)
#' 
#' View(rav.dat)
#' 
#' #getting all the data
#' rav.dat<-imp.raven(all.data = TRUE)
#' View(rav.dat)

#' # remove example directory
#' unlink(getwd(),recursive = TRUE)
#' }
#' @author Marcelo Araya-Salas (\url{http://marceloarayasalas.weebly.com/})

imp.raven<-function(path = NULL, sound.file.col = NULL, all.data = FALSE, recursive = FALSE) 
  { if(is.null(path)) path = getwd()
  sel.txt <- list.files(path = path, pattern = ".txt$", full.names = T, recursive = recursive)
  sel.txt2 <- list.files(path = path, pattern = ".txt$", full.names = F, recursive = recursive)
  if(length(sel.txt) == 0) stop("No selection files in path provided")
  
  b<-NULL
    for(i in 1:length(sel.txt))  
    {    a<-read.table(sel.txt[i], header = T, sep = "\t", fill = TRUE)
    if(!all.data) { if(!is.null(sound.file.col)) 
    {  if(length(grep(sound.file.col, colnames(a))) == 0) stop(paste(sound.file.col , "column not found")) 
    c <- data.frame(sound.files = a[, grep(sound.file.col, colnames(a))],
                                            selec = a[,grep("Selection",colnames(a))],
             start = a[,grep("Begin.Time",colnames(a))],
             end = a[, grep("End.Time",colnames(a))], selec.file = sel.txt2[i])} else
               c<-data.frame(selec.file = sel.txt2[i],selec = a[,grep("Selection",colnames(a))],
                             start = a[, grep("Begin.Time", colnames(a))],
                             end = a[, grep("End.Time", colnames(a))])} else c <- a 
  b<-rbind(b, c)
    }
  
return(b[!duplicated(b), ])
}
