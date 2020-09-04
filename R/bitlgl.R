
#' Bit-packed logical
#'
#' @param x A [raw()] vector of bytes
#' @param extra_bits The number of bits from the last byte that
#'   should be considered part of the vector.
#' @param ... Unused
#'
#' @return A pkd_vctr of class pkd_bitlgl
#' @export
#'
#' @examples
#' bitlgl(0xff)
#' bitlgl(0x80)
#' bitlgl(c(0x01, 0xff), extra_bits = 1)
#'
bitlgl <- function(x = raw(), extra_bits = 0L) {
  if (extra_bits > 8 || extra_bits < 0) {
    abort("`extra_bits` must be between 0 and 8")
  } else if (extra_bits == 0 && length(x) > 0) {
    extra_bits <- 8L
  }

  new_pkd_bitlgl(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list(extra_bits = as.raw(extra_bits)[1])
    )
  )
}

#' @rdname bitlgl
#' @export
as_bitlgl <- function(x, ...) {
  UseMethod("as_bitlgl")
}

#' @rdname bitlgl
#' @export
as_bitlgl.default <- function(x, ...) {
  as_bitlgl(vec_cast(x, logical()))
}

#' @rdname bitlgl
#' @export
as_bitlgl.pkd_bitlgl <- function(x, ...) {
  x
}

#' @rdname bitlgl
#' @export
as_bitlgl.logical <- function(x, ...) {
  new_pkd_bitlgl(.Call(pkd_c_bitlgl_from_logical, x))
}

new_pkd_bitlgl <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_bitlgl")
}

#' @export
pkd_as_atomic.pkd_bitlgl <- function(x) {
  as.logical(x)
}

#' @export
length.pkd_bitlgl <- function(x) {
  .Call(pkd_c_bitlgl_length, x)
}

#' @export
as.logical.pkd_bitlgl <- function(x, ...) {
  .Call(pkd_c_bitlgl_to_logical, x)
}
