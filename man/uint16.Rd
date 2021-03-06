% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/uint16.R
\name{uint16}
\alias{uint16}
\alias{as_uint16}
\alias{as_uint16.default}
\alias{as_uint16.pkd_uint16}
\alias{as_uint16.integer}
\alias{as_uint16.numeric}
\alias{new_pkd_uint16}
\title{Unsigned 16-bit integer vector}
\usage{
uint16(x = raw(), endian = pkd_system_endian())

as_uint16(x, ...)

\method{as_uint16}{default}(x, ...)

\method{as_uint16}{pkd_uint16}(x, ...)

\method{as_uint16}{integer}(x, ...)

\method{as_uint16}{numeric}(x, ...)

new_pkd_uint16(x)
}
\arguments{
\item{x}{A \code{\link[=raw]{raw()}} vector of bytes with every two elements representing an
individual unsigned integer value.}

\item{endian}{0 for the most significant byte first (big endian),
1 for the least significant byte first (little endian).}

\item{...}{Unused}
}
\value{
A pkd_vctr of class pkd_uint16
}
\description{
Unsigned 16-bit integer vector
}
