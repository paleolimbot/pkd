
assert_pkd_vctr <- function(x) {
  if (!inherits(x, "pkd_vctr")) {
    abort("`x` must inherit from 'pkd_vctr'")
  }

  invisible(x)
}
