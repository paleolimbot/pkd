
#' Signed 32-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every four elements representing an
#'   individual signed integer value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_int32
#' @export
#'
int32 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_int32(
    list(
      data = as.raw(x),
      sizeof = 4L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname int32
#' @export
as_int32 <- function(x, ...) {
  UseMethod("as_int32")
}

#' @rdname int32
#' @export
as_int32.default <- function(x, ...) {
  as_int32(vec_cast(x, integer()))
}

#' @rdname int32
#' @export
as_int32.pkd_int32 <- function(x, ...) {
  x
}

#' @rdname int32
#' @export
as_int32.integer <- function(x, ...) {
  new_pkd_int32(.Call(pkd_c_int32_from_integer, x))
}

#' @rdname int32
#' @export
as_int32.numeric <- function(x, ...) {
  new_pkd_int32(.Call(pkd_c_int32_from_double, x))
}

#' @rdname int32
#' @export
new_pkd_int32 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_int32")
}

#' @export
pkd_as_r_vector.pkd_int32 <- function(x) {
  as.integer(x)
}

#' @export
as.integer.pkd_int32 <- function(x, ...) {
  .Call(pkd_c_int32_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_int32 <- function(x, ...) {
  .Call(pkd_c_int32_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
