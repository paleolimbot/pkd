
#' Unsigned 32-bit integer vector
#'
#' @param x A [raw()] vector of bytes with every four elements representing an
#'   individual unsigned integer value.
#' @param ... Unused
#' @inheritParams pkd_as_r_vector
#'
#' @return A pkd_vctr of class pkd_uint32
#' @export
#'
uint32 <- function(x = raw(), endian = pkd_system_endian()) {
  new_pkd_uint32(
    list(
      data = as.raw(x),
      sizeof = 4L,
      endian = vec_cast(endian, integer()),
      attr = list()
    )
  )
}

#' @rdname uint32
#' @export
as_uint32 <- function(x, ...) {
  UseMethod("as_uint32")
}

#' @rdname uint32
#' @export
as_uint32.default <- function(x, ...) {
  as_uint32(vec_cast(x, integer()))
}

#' @rdname uint32
#' @export
as_uint32.pkd_uint32 <- function(x, ...) {
  x
}

#' @rdname uint32
#' @export
as_uint32.integer <- function(x, ...) {
  new_pkd_uint32(.Call(pkd_c_uint32_from_integer, x))
}

#' @rdname uint32
#' @export
as_uint32.numeric <- function(x, ...) {
  new_pkd_uint32(.Call(pkd_c_uint32_from_double, x))
}

#' @rdname uint32
#' @export
new_pkd_uint32 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_uint32")
}

#' @export
pkd_as_r_vector.pkd_uint32 <- function(x) {
  as.double(x)
}

#' @export
as.integer.pkd_uint32 <- function(x, ...) {
  .Call(pkd_c_uint32_to_integer, pkd_ensure_endian(x, pkd_system_endian()))
}

#' @export
as.double.pkd_uint32 <- function(x, ...) {
  .Call(pkd_c_uint32_to_double, pkd_ensure_endian(x, pkd_system_endian()))
}
