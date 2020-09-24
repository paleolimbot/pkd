
#' Unsigned 16-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every two elements representing an
#'   individual unsigned integer value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_uint16
#' @export
#'
uint16 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_uint16(
    list(
      data = as.raw(x),
      sizeof = 2L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname uint16
#' @export
as_uint16 <- function(x, ...) {
  UseMethod("as_uint16")
}

#' @rdname uint16
#' @export
as_uint16.default <- function(x, ...) {
  as_uint16(vec_cast(x, integer()))
}

#' @rdname uint16
#' @export
as_uint16.pkd_uint16 <- function(x, ...) {
  x
}

#' @rdname uint16
#' @export
as_uint16.integer <- function(x, ...) {
  new_pkd_uint16(.Call(pkd_c_uint16_from_integer, x))
}

#' @rdname uint16
#' @export
as_uint16.numeric <- function(x, ...) {
  new_pkd_uint16(.Call(pkd_c_uint16_from_double, x))
}

#' @rdname uint16
#' @export
new_pkd_uint16 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_uint16")
}

#' @export
pkd_as_r_vector.pkd_uint16 <- function(x) {
  as.integer(x)
}

#' @export
as.integer.pkd_uint16 <- function(x, ...) {
  .Call(pkd_c_uint16_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_uint16 <- function(x, ...) {
  .Call(pkd_c_uint16_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
