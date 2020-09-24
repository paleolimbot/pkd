
#' Unsigned 8-bit integer vector
#'
#' @param x A [raw()] vector of bytes with each element representing an
#'   individual unsigned integer value.
#' @param ... Unused
#'
#' @return A pkd_vctr of class pkd_uint8
#' @export
#'
uint8 <- function(x = raw()) {
  new_pkd_uint8(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list()
    )
  )
}

#' @rdname uint8
#' @export
as_uint8 <- function(x, ...) {
  UseMethod("as_uint8")
}

#' @rdname uint8
#' @export
as_uint8.default <- function(x, ...) {
  as_uint8(vec_cast(x, integer()))
}

#' @rdname uint8
#' @export
as_uint8.pkd_uint8 <- function(x, ...) {
  x
}

#' @rdname uint8
#' @export
as_uint8.integer <- function(x, ...) {
  # NA values do not throw an error but do give an ominous warning here
  # this is much faster than a custom method
  new_pkd_uint8(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list()
    )
  )
}

#' @rdname uint8
#' @export
as_uint8.numeric <- function(x, ...) {
  # NA values do not throw an error but do give an ominous warning here
  # this is much faster than a custom method
  new_pkd_uint8(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list()
    )
  )
}

#' @rdname uint8
#' @export
new_pkd_uint8 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_uint8")
}

#' @export
pkd_as_r_vector.pkd_uint8 <- function(x) {
  as.integer(x)
}

#' @export
as.integer.pkd_uint8 <- function(x, ...) {
  # much faster than a custom method
  as.integer(unclass(x)$data)
}

#' @export
as.double.pkd_uint8 <- function(x, ...) {
  # much faster than a custom method
  as.double(unclass(x)$data)
}
