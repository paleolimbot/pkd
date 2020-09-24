
#' Signed 64-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every eight elements representing an
#'   individual double-precision floating point value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_dbl64
#' @export
#'
dbl64 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_dbl64(
    list(
      data = as.raw(x),
      sizeof = 8L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname dbl64
#' @export
as_dbl64 <- function(x, ...) {
  UseMethod("as_dbl64")
}

#' @rdname dbl64
#' @export
as_dbl64.default <- function(x, ...) {
  as_dbl64(vec_cast(x, integer()))
}

#' @rdname dbl64
#' @export
as_dbl64.pkd_dbl64 <- function(x, ...) {
  x
}

#' @rdname dbl64
#' @export
as_dbl64.integer <- function(x, ...) {
  new_pkd_dbl64(.Call(pkd_c_dbl64_from_integer, x))
}

#' @rdname dbl64
#' @export
as_dbl64.numeric <- function(x, ...) {
  new_pkd_dbl64(.Call(pkd_c_dbl64_from_double, x))
}

#' @rdname dbl64
#' @export
new_pkd_dbl64 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_dbl64")
}

#' @export
pkd_as_r_vector.pkd_dbl64 <- function(x) {
  as.double(x)
}

#' @export
as.integer.pkd_dbl64 <- function(x, ...) {
  .Call(pkd_c_dbl64_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_dbl64 <- function(x, ...) {
  .Call(pkd_c_dbl64_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
