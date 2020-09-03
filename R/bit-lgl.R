
bitlgl <- function(x, extra_bits = 0L) {
  extra_bits <- as.raw(extra_bits)[1]
  if (extra_bits > 8) {
    stop("`extra_bits` must be between 0 and 8")
  } else if (extra_bits == 0) {
    extra_bits <- as.raw(8L);
  }

  new_pkd_bitlgl(list(data = as.raw(x), extra_bits = as.raw(extra_bits)[1]))
}

new_pkd_bitlgl <- function(x) {
  structure(x, class = c("pkd_bitlgl", "pkd_vctr"))
}

#' @export
print.pkd_bitlgl <- function(x, ...) {
  print(unclass(x), ...)
  invisible(x)
}

#' @export
length.pkd_bitlgl <- function(x) {
  .Call(pkd_c_bitlgl_length, x)
}

#' @export
as.logical.pkd_bitlgl <- function(x) {
  .Call(pkd_c_bitlgl_to_logical, x)
}
