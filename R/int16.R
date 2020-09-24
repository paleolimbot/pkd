
#' Signed 16-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every two elements representing an
#'   individual unsigned integer value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_int16
#' @export
#'
int16 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_int16(
    list(
      data = as.raw(x),
      sizeof = 2L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname int16
#' @export
as_int16 <- function(x, ...) {
  UseMethod("as_int16")
}

#' @rdname int16
#' @export
as_int16.default <- function(x, ...) {
  as_int16(vec_cast(x, integer()))
}

#' @rdname int16
#' @export
as_int16.pkd_int16 <- function(x, ...) {
  x
}

#' @rdname int16
#' @export
as_int16.integer <- function(x, ...) {
  new_pkd_int16(.Call(pkd_c_int16_from_integer, x))
}

#' @rdname int16
#' @export
as_int16.numeric <- function(x, ...) {
  new_pkd_int16(.Call(pkd_c_int16_from_double, x))
}

#' @rdname int16
#' @export
new_pkd_int16 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_int16")
}

#' @export
pkd_as_r_vector.pkd_int16 <- function(x) {
  as.integer(x)
}

#' @export
as.integer.pkd_int16 <- function(x, ...) {
  .Call(pkd_c_int16_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_int16 <- function(x, ...) {
  .Call(pkd_c_int16_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
