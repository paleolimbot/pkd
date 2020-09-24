
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pkd

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/paleolimbot/pkd/workflows/R-CMD-check/badge.svg)](https://github.com/paleolimbot/pkd/actions)
[![Codecov test
coverage](https://codecov.io/gh/paleolimbot/pkd/branch/master/graph/badge.svg)](https://codecov.io/gh/paleolimbot/pkd?branch=master)
<!-- badges: end -->

The goal of pkd is to provide cross-platform integer and floating-point
vector types commonly used to read and write files.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("paleolimbot/pkd")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(pkd)

# logical
lgl1(0xff)
#> <pkd_lgl1[8]>
#> [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
lgl8(0x01)
#> <pkd_lgl8[1]>
#> [1] TRUE

# integer
int8(0xff)
#> <pkd_int8[1]>
#> [1] -1
uint8(0xff)
#> <pkd_uint8[1]>
#> [1] 255
int16(c(0xff, 0xff))
#> <pkd_int16[1]>
#> [1] -1
uint16(c(0xff, 0xff))
#> <pkd_uint16[1]>
#> [1] 65535
int32(c(0xff, 0xff, 0xff, 0xff))
#> <pkd_int32[1]>
#> [1] -1
uint32(c(0xff, 0xff, 0xff, 0xff))
#> <pkd_uint32[1]>
#> [1] 4294967295
int64(c(0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff))
#> <pkd_int64[1]>
#> [1] -1
uint64(c(0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff))
#> <pkd_uint64[1]>
#> [1] 1.844674e+19

# floating-point
as_dbl32(12.34)
#> <pkd_dbl32[1]>
#> [1] 12.34
as_dbl64(12.34)
#> <pkd_dbl64[1]>
#> [1] 12.34
```

Currently, `Math` and `Ops` are not implemented; however, coercion to
`integer()`/`double()`, subsetting, endian-swapping, and
subset-assignment are supported:

``` r
x <- as_uint8(1:10)
x
#> <pkd_uint8[10]>
#>  [1]  1  2  3  4  5  6  7  8  9 10
x[1:5]
#> <pkd_uint8[5]>
#> [1] 1 2 3 4 5

x[5] <- 255
x
#> <pkd_uint8[10]>
#>  [1]   1   2   3   4 255   6   7   8   9  10

uint32(c(0x00, 0x00, 0x00, 0x01), endian = 1L)
#> <pkd_uint32[1]>
#> [1] 16777216
uint32(c(0x00, 0x00, 0x00, 0x01), endian = 0L)
#> <pkd_uint32[1]>
#> [1] 1

pkd_ensure_endian(
  uint32(c(0x00, 0x00, 0x00, 0x01), endian = 0L), 
  endian = 1L
)
#> <pkd_uint32[1]>
#> [1] 1
```

Under the hood, these vectors are implemented as `raw()` vectors as part
of an S3 object. This design allows a great deal of code to be recycled
among the various fixed-width types.

``` r
unclass(as_uint32(255))
#> $data
#> [1] ff 00 00 00
#> 
#> $sizeof
#> [1] 4
#> 
#> $endian
#> [1] 1
#> 
#> $attr
#> list()
```
