
#' Signed 32-bit floating-point vector
#'
#' @param x A [raw()] vector of bytes with every eight elements representing an
#'   individual floating point value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_dbl32
#' @export
#'
dbl32 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_dbl32(
    list(
      data = as.raw(x),
      sizeof = 4L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname dbl32
#' @export
as_dbl32 <- function(x, ...) {
  UseMethod("as_dbl32")
}

#' @rdname dbl32
#' @export
as_dbl32.default <- function(x, ...) {
  as_dbl32(vec_cast(x, integer()))
}

#' @rdname dbl32
#' @export
as_dbl32.pkd_dbl32 <- function(x, ...) {
  x
}

#' @rdname dbl32
#' @export
as_dbl32.integer <- function(x, ...) {
  new_pkd_dbl32(.Call(pkd_c_dbl32_from_integer, x))
}

#' @rdname dbl32
#' @export
as_dbl32.numeric <- function(x, ...) {
  new_pkd_dbl32(.Call(pkd_c_dbl32_from_double, x))
}

#' @rdname dbl32
#' @export
new_pkd_dbl32 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_dbl32")
}

#' @export
pkd_as_r_vector.pkd_dbl32 <- function(x) {
  as.double(x)
}

#' @export
as.integer.pkd_dbl32 <- function(x, ...) {
  .Call(pkd_c_dbl32_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_dbl32 <- function(x, ...) {
  .Call(pkd_c_dbl32_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
