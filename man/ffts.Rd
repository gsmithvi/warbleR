% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ffts.R
\name{ffts}
\alias{ffts}
\title{Extract the fundamental frequency values as a time series}
\usage{
ffts(X, wl = 512, flim = c(0, 22), length.out = 20, wn = "hanning", pal =
  reverse.gray.colors.2, ovlp = 70, inner.mar = c(5, 4, 4, 2), outer.mar = 
  c(0, 0, 0, 0), picsize = 1, res = 100, cexlab = 1, title = TRUE, propwidth = FALSE, 
  xl = 1, gr = FALSE, sc = FALSE, bp = c(0, 22), cex = 1, 
  threshold = 15, col = "dodgerblue", pch = 16,  mar = 0.05, 
  lpos = "topright", it = "jpeg", img = TRUE, parallel = 1, path = NULL)
}
\arguments{
\item{X}{Data frame with results containing columns for sound file name (sound.files), 
selection number (selec), and start and end time of signal (start and end).
The ouptut of \code{\link{manualoc}} or \code{\link{autodetec}} can be used as the input data frame.}

\item{wl}{A numeric vector of length 1 specifying the window length of the spectrogram, default 
is 512.}

\item{flim}{A numeric vector of length 2 for the frequency limit of 
the spectrogram (in kHz), as in \code{\link[seewave]{spectro}}. Default is c(0, 22).}

\item{length.out}{A character vector of length 1 giving the number of measurements of fundamental 
frequency desired (the length of the time series).}

\item{wn}{Character vector of length 1 specifying window name. Default is 
"hanning". See function \code{\link[seewave]{ftwindow}} for more options.}

\item{pal}{A color palette function to be used to assign colors in the 
plot, as in \code{\link[seewave]{spectro}}. Default is reverse.gray.colors.2.}

\item{ovlp}{Numeric vector of length 1 specifying \% of overlap between two 
consecutive windows, as in \code{\link[seewave]{spectro}}. Default is 70.}

\item{inner.mar}{Numeric vector with 4 elements, default is c(5,4,4,2). 
Specifies number of lines in inner plot margins where axis labels fall, 
with form c(bottom, left, top, right). See \code{\link[graphics]{par}}.}

\item{outer.mar}{Numeric vector with 4 elements, default is c(0,0,0,0). 
Specifies number of lines in outer plot margins beyond axis labels, with 
form c(bottom, left, top, right). See \code{\link[graphics]{par}}.}

\item{picsize}{Numeric argument of length 1. Controls relative size of 
spectrogram. Default is 1.}

\item{res}{Numeric argument of length 1. Controls image resolution.
Default is 100 (faster) although 300 - 400 is recommended for publication/ 
presentation quality.}

\item{cexlab}{Numeric vector of length 1 specifying the relative size of axis 
labels. See \code{\link[seewave]{spectro}}.}

\item{title}{Logical argument to add a title to individual spectrograms. 
Default is \code{TRUE}.}

\item{propwidth}{Logical argument to scale the width of spectrogram 
proportionally to duration of the selected call. Default is \code{FALSE}.}

\item{xl}{Numeric vector of length 1. A constant by which to scale 
spectrogram width. Default is 1.}

\item{gr}{Logical argument to add grid to spectrogram. Default is \code{FALSE}.}

\item{sc}{Logical argument to add amplitude scale to spectrogram, default is 
\code{FALSE}.}

\item{bp}{A numeric vector of length 2 for the lower and upper limits of a 
frequency bandpass filter (in kHz). Default is c(0, 22).}

\item{cex}{Numeric vector of length 1, specifies relative size of points 
plotted for frequency measurements and legend font/points, respectively. 
See \code{\link[seewave]{spectro}}.}

\item{threshold}{amplitude threshold (\%) for fundamental frequency detection. Default is 15.}

\item{col}{Vector of length 1 specifying colors of points plotted to mark 
fundamental frequency measurements. Default is "dodgerblue".}

\item{pch}{Numeric vector of length 1 specifying plotting characters for 
the frequency measurements. Default is 16.}

\item{mar}{Numeric vector of length 1. Specifies the margins adjacent to the selections
to set spectrogram limits. Default is 0.05.}

\item{lpos}{Character vector of length 1 or numeric vector of length 2, 
specifiying position of legend. If the former, any keyword accepted by 
xy.coords can be used (see below). If the latter, the first value will be the x 
coordinate and the second value the y coordinate for the legend's position.
Default is "topright".}

\item{it}{A character vector of length 1 giving the image type to be used. Currently only
"tiff" and "jpeg" are admitted. Default is "jpeg".}

\item{img}{Logical argument. If \code{FALSE}, image files are not produced. Default is \code{TRUE}.}

\item{parallel}{Numeric. Controls whether parallel computing is applied.
It specifies the number of cores to be used. Default is 1 (i.e. no parallel computing).
Not available in Windows OS.}

\item{path}{Character string containing the directory path where the sound files are located. 
If \code{NULL} (default) then the current working directory is used.}
}
\value{
A data frame with the fundamental frequency values measured across the signals. If img is 
\code{FALSE} it also produces image files with the spectrograms of the signals listed in the 
input data frame showing the location of the fundamental frequencies.
}
\description{
\code{ffts} extracts the fundamental frequency values as a time series
of signals selected by \code{\link{manualoc}} or \code{\link{autodetec}}.
}
\details{
This function extracts the fundamental frequency values as a time series. 
The function uses the \code{\link[stats]{approx}} function to interpolate values between fundamental frequency 
measures.
}
\examples{
\dontrun{
# set the temp directory
setwd(tempdir())

#load data
data(list = c("Phae.long1", "Phae.long2","manualoc.df"))
writeWave(Phae.long2, "Phae.long2.wav") #save sound files 
writeWave(Phae.long1, "Phae.long1.wav")

# run function 
ffts(manualoc.df, length.out = 30, flim = c(1, 12), bp = c(0, 9), wl = 300)

}
}
\author{
Marcelo Araya-Salas (\email{araya-salas@cornell.edu})
}
\seealso{
\code{\link{specreator}} for creating spectrograms from selections,
 \code{\link{snrspecs}} for creating spectrograms to 
  optimize noise margins used in \code{\link{sig2noise}}

Other spectrogram.creators: \code{\link{dfDTW}},
  \code{\link{dfts}}, \code{\link{ffDTW}},
  \code{\link{snrspecs}}, \code{\link{specreator}},
  \code{\link{trackfreqs}}
}

