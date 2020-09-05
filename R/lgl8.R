
#' Byte logical vector
#'
#' @param x A [raw()] vector of bytes with each element representing an
#'   individual logical value. Values of `0x00` are considered `FALSE`;
#'   all other values are considered `TRUE`.
#'
#' @return A pkd_vctr of class pkd_lgl8
#' @export
#'
lgl8 <- function(x = raw()) {
  new_pkd_lgl8(
    list(
      data = as.raw(x),
      sizeof = 1L,
      endian = NA_integer_,
      attr = list()
    )
  )
}

#' @rdname lgl8
#' @export
as_lgl8 <- function(x, ...) {
  UseMethod("as_lgl8")
}

#' @rdname lgl8
#' @export
as_lgl8.default <- function(x, ...) {
  as_lgl8(vec_cast(x, logical()))
}

#' @rdname lgl8
#' @export
as_lgl8.pkd_lgl8 <- function(x, ...) {
  x
}

#' @rdname lgl8
#' @export
as_lgl8.logical <- function(x, ...) {
  new_pkd_lgl8(.Call(pkd_c_lgl8_from_logical, x))
}

#' @rdname lgl8
#' @export
new_pkd_lgl8 <- function(x) {
  new_pkd_vctr(x, subclass = "pkd_lgl8")
}

#' @export
pkd_as_r_vector.pkd_lgl8 <- function(x) {
  as.logical(x)
}

#' @export
as.logical.pkd_lgl8 <- function(x, ...) {
  .Call(pkd_c_lgl8_to_logical, x)
}
