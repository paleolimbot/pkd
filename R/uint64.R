
#' Unsigned 64-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every eight elements representing an
#'   individual unsigned integer value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_uint64
#' @export
#'
uint64 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_uint64(
    list(
      data = as.raw(x),
      sizeof = 8L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname uint64
#' @export
as_uint64 <- function(x, ...) {
  UseMethod("as_uint64")
}

#' @rdname uint64
#' @export
as_uint64.default <- function(x, ...) {
  as_uint64(vec_cast(x, integer()))
}

#' @rdname uint64
#' @export
as_uint64.pkd_uint64 <- function(x, ...) {
  x
}

#' @rdname uint64
#' @export
as_uint64.integer <- function(x, ...) {
  new_pkd_uint64(.Call(pkd_c_uint64_from_integer, x))
}

#' @rdname uint64
#' @export
as_uint64.numeric <- function(x, ...) {
  new_pkd_uint64(.Call(pkd_c_uint64_from_double, x))
}

#' @rdname uint64
#' @export
new_pkd_uint64 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_uint64")
}

#' @export
pkd_as_r_vector.pkd_uint64 <- function(x) {
  as.double(x)
}

#' @export
as.integer.pkd_uint64 <- function(x, ...) {
  .Call(pkd_c_uint64_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_uint64 <- function(x, ...) {
  .Call(pkd_c_uint64_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
