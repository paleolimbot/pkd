
pkd_swap_endian <- function(x) {
  assert_pkd_vctr(x)
  .Call(pkd_c_swap_endian, x)
}

pkd_ensure_endian <- function(x, endian = pkd_system_endian()) {
  assert_pkd_vctr(x)
  if (endian == pkd_system_endian()) {
    x
  } else {
    .Call(pkd_c_swap_endian, x)
  }
}

pkd_system_endian <- function() {
  .Call(pkd_c_system_endian)
}

new_pkd_vctr <- function(x, subclass) {
  structure(x, class = c(subclass, "pkd_vctr"))
}

#' @export
length.pkd_vctr <-  function(x) {
  x <- unclass(x)
  length(x$data) / x$sizeof
}

validate_pkd_vctr <- function(x) {
  if (!rlang::is_bare_list(x)) {
    abort("`x` must be a bare list")
  }

  if (!identical(names(x)[1:3], c("data", "sizeof", "endian"))) {
    abort("`x` must be named")
  }

  if (typeof(x$data) != "raw") {
    abort("`x$data` must be a 'raw' vector")
  }

  if (!rlang::is_bare_integer(x$sizeof) || (length(x$sizeof) != 1 ) || (x$sizeof < 1)) {
    abort("`x$sizeof` must be a scalar integer >= 1")
  }

  if (!rlang::is_bare_integer(x$endian) || (length(x$endian) != 1 ) || !(x$endian %in% c(0L, 1L, NA))) {
    abort("`x$sizeof` must be an 'integer' vector")
  }

  invisible(x)
}
