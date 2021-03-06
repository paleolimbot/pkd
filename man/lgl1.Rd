% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lgl1.R
\name{lgl1}
\alias{lgl1}
\alias{as_lgl1}
\alias{as_lgl1.default}
\alias{as_lgl1.pkd_lgl1}
\alias{as_lgl1.logical}
\alias{new_pkd_lgl1}
\title{Bit-packed logical}
\usage{
lgl1(x = raw(), extra_bits = 0L)

as_lgl1(x, ...)

\method{as_lgl1}{default}(x, ...)

\method{as_lgl1}{pkd_lgl1}(x, ...)

\method{as_lgl1}{logical}(x, ...)

new_pkd_lgl1(x)
}
\arguments{
\item{x}{A \code{\link[=raw]{raw()}} vector of bytes with each bit representing an
individual logical value.}

\item{extra_bits}{The number of bits from the last byte that
should be considered part of the vector.}

\item{...}{Unused}
}
\value{
A pkd_vctr of class pkd_lgl1
}
\description{
Bit-packed logical
}
\examples{
lgl1(0xff)
lgl1(0x80)
lgl1(c(0x01, 0xff), extra_bits = 1)

}
