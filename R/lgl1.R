
#' Bit-packed logical
#'
#' @param x A [raw()] vector of bytes with each bit representing an
#'   individual logical value.
#' @param extra_bits The number of bits from the last byte that
#'   should be considered part of the vector.
#' @param ... Unused
#'
#' @return A pkd_vctr of class pkd_lgl1
#' @export
#'
#' @examples
#' lgl1(0xff)
#' lgl1(0x80)
#' lgl1(c(0x01, 0xff), extra_bits = 1)
#'
lgl1 <- function(x = raw(), extra_bits = 0L) {
  if (extra_bits > 8 || extra_bits < 0) {
    abort("`extra_bits` must be between 0 and 8")
  } else if (extra_bits == 0 && length(x) > 0) {
    extra_bits <- 8L
  }

  new_pkd_lgl1(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list(extra_bits = as.raw(extra_bits)[1])
    )
  )
}

#' @rdname lgl1
#' @export
as_lgl1 <- function(x, ...) {
  UseMethod("as_lgl1")
}

#' @rdname lgl1
#' @export
as_lgl1.default <- function(x, ...) {
  as_lgl1(vec_cast(x, logical()))
}

#' @rdname lgl1
#' @export
as_lgl1.pkd_lgl1 <- function(x, ...) {
  x
}

#' @rdname lgl1
#' @export
as_lgl1.logical <- function(x, ...) {
  new_pkd_lgl1(.Call(pkd_c_lgl1_from_logical, x))
}

#' @rdname lgl1
#' @export
new_pkd_lgl1 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_lgl1")
}

#' @export
pkd_as_r_vector.pkd_lgl1 <- function(x) {
  as.logical(x)
}

#' @export
as.logical.pkd_lgl1 <- function(x, ...) {
  .Call(pkd_c_lgl1_to_logical, x)
}

#' @export
length.pkd_lgl1 <- function(x) {
  .Call(pkd_c_lgl1_length, x)
}

# these aren't efficient, but it's unclear whether or not
# optimization of a bit1 subset/subset assign is needed

#' @export
`[.pkd_lgl1` <- function(x, i) {
  as_lgl1.logical(.Call(pkd_c_lgl1_to_logical, x)[i])
}

#' @export
`[<-.pkd_lgl1` <- function(x, i, value) {
  lgl <- .Call(pkd_c_lgl1_to_logical, x)
  lgl[i] <- value
  as_lgl1.logical(lgl)
}
