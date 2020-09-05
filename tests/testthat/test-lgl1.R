
test_that("lgl1 constructor works", {
  expect_is(lgl1(), "pkd_lgl1")
  expect_is(lgl1(), "pkd_vctr")
  expect_error(lgl1(extra_bits = -1), "must be between")

  expect_output(print(lgl1()), "pkd_lgl1")
})

test_that("lgl1 logical conversion works", {
  expect_identical(as.logical(lgl1()), logical())
  expect_identical(as.logical(lgl1(0x80)), c(TRUE, rep(FALSE, 7)))
  expect_identical(as.logical(lgl1(c(0x80, 0x80), extra_bits = 1)), c(TRUE, rep(FALSE, 7), TRUE))

  expect_identical(as_lgl1(logical()), lgl1(raw()))
  expect_identical(as_lgl1(as.logical(lgl1(0x80))), lgl1(0x80))
  expect_identical(
    as_lgl1(as.logical(lgl1(c(0x80, 0x80), extra_bits = 1))),
    lgl1(c(0x80, 0x80), extra_bits = 1)
  )

  # default method
  expect_identical(
    as_lgl1(c(TRUE, rep(FALSE, 7))),
    as_lgl1(c(1L, rep(0L, 7)))
  )
})

test_that("lgl1 subset/subset assign works", {
  lgl1 <- lgl1(0x00)
  expect_identical(as.logical(lgl1[1:5]), rep(FALSE, 5))
  lgl1[1] <- TRUE
  expect_identical(lgl1, lgl1(0x80))
  expect_identical(lgl1[[1]], lgl1(0x80, extra_bits = 1))
})
