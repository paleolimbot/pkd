% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lgl8.R
\name{lgl8}
\alias{lgl8}
\alias{as_lgl8}
\alias{as_lgl8.default}
\alias{as_lgl8.pkd_lgl8}
\alias{as_lgl8.logical}
\alias{new_pkd_lgl8}
\title{Byte logical vector}
\usage{
lgl8(x = raw())

as_lgl8(x, ...)

\method{as_lgl8}{default}(x, ...)

\method{as_lgl8}{pkd_lgl8}(x, ...)

\method{as_lgl8}{logical}(x, ...)

new_pkd_lgl8(x)
}
\arguments{
\item{x}{A \code{\link[=raw]{raw()}} vector of bytes with each element representing an
individual logical value. Values of \code{0x00} are considered \code{FALSE};
all other values are considered \code{TRUE}.}

\item{...}{Unused}
}
\value{
A pkd_vctr of class pkd_lgl8
}
\description{
Byte logical vector
}
