% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/int8.R
\name{int8}
\alias{int8}
\alias{as_int8}
\alias{as_int8.default}
\alias{as_int8.pkd_int8}
\alias{as_int8.integer}
\alias{as_int8.numeric}
\alias{new_pkd_int8}
\title{Signed 8-bit integer vector}
\usage{
int8(x = raw())

as_int8(x, ...)

\method{as_int8}{default}(x, ...)

\method{as_int8}{pkd_int8}(x, ...)

\method{as_int8}{integer}(x, ...)

\method{as_int8}{numeric}(x, ...)

new_pkd_int8(x)
}
\arguments{
\item{x}{A \code{\link[=raw]{raw()}} vector of bytes with each element representing an
individual integer value.}

\item{...}{Unused}
}
\value{
A pkd_vctr of class pkd_int8
}
\description{
Signed 8-bit integer vector
}
