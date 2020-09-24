
#' Signed 8-bit integer vector
#'
#' @param x A [raw()] vector of bytes with each element representing an
#'   individual integer value.
#' @param ... Unused
#'
#' @return A pkd_vctr of class pkd_int8
#' @export
#'
int8 <- function(x = raw()) {
  new_pkd_int8(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list()
    )
  )
}

#' @rdname int8
#' @export
as_int8 <- function(x, ...) {
  UseMethod("as_int8")
}

#' @rdname int8
#' @export
as_int8.default <- function(x, ...) {
  as_int8(vec_cast(x, integer()))
}

#' @rdname int8
#' @export
as_int8.pkd_int8 <- function(x, ...) {
  x
}

#' @rdname int8
#' @export
as_int8.integer <- function(x, ...) {
  new_pkd_int8(.Call(pkd_c_int8_from_integer, x))
}

#' @rdname int8
#' @export
as_int8.numeric <- function(x, ...) {
  new_pkd_int8(.Call(pkd_c_int8_from_double, x))
}

#' @rdname int8
#' @export
new_pkd_int8 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_int8")
}

#' @export
pkd_as_r_vector.pkd_int8 <- function(x) {
  as.integer(x)
}

#' @export
as.integer.pkd_int8 <- function(x, ...) {
  .Call(pkd_c_int8_to_integer, x)
}

#' @export
as.double.pkd_int8 <- function(x, ...) {
  .Call(pkd_c_int8_to_double, x)
}
