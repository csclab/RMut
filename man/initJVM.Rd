% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{initJVM}
\alias{initJVM}
\title{Initialize the Java Virtual Machine.}
\usage{
initJVM(maxHeapSize)
}
\arguments{
\item{maxHeapSize}{The maximum Java heap size. Default is "1G" (means 1 gigabytes).}
}
\value{
TRUE denotes successful initialization, and FALSE indicates failure.
}
\description{
\code{initJVM} initializes the Java Virtual Machine (JVM).
This function must be called before any RMut functions can be used.
}
\details{
This function initializes the JVM with a parameter of the maximum Java heap size \code{maxHeapSize}.
The parameter is a string composed of a number and followed by a letter K, or M, or G
(K indicates kilobytes, M indicates megabytes, G indicates gigabytes).
}
\examples{
initJVM("1G")

}
\seealso{
\code{\link{setOpencl}}, \code{\link{showOpencl}}
}
