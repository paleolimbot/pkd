
#' Signed 64-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every eight elements representing an
#'   individual signed integer value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_int64
#' @export
#'
int64 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_int64(
    list(
      data = as.raw(x),
      sizeof = 8L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname int64
#' @export
as_int64 <- function(x, ...) {
  UseMethod("as_int64")
}

#' @rdname int64
#' @export
as_int64.default <- function(x, ...) {
  as_int64(vec_cast(x, integer()))
}

#' @rdname int64
#' @export
as_int64.pkd_int64 <- function(x, ...) {
  x
}

#' @rdname int64
#' @export
as_int64.integer <- function(x, ...) {
  new_pkd_int64(.Call(pkd_c_int64_from_integer, x))
}

#' @rdname int64
#' @export
as_int64.numeric <- function(x, ...) {
  new_pkd_int64(.Call(pkd_c_int64_from_double, x))
}

#' @rdname int64
#' @export
new_pkd_int64 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_int64")
}

#' @export
pkd_as_r_vector.pkd_int64 <- function(x) {
  as.double(x)
}

#' @export
as.integer.pkd_int64 <- function(x, ...) {
  .Call(pkd_c_int64_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_int64 <- function(x, ...) {
  .Call(pkd_c_int64_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
