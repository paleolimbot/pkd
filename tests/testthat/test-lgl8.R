
test_that("lgl8 constructor works", {
  expect_is(lgl8(), "pkd_lgl8")
  expect_is(lgl8(), "pkd_vctr")

  expect_output(print(lgl8()), "pkd_lgl8")
})

test_that("lgl8 logical conversion works", {
  expect_identical(as.logical(lgl8()), logical())
  expect_identical(as.logical(lgl8(0x00)), FALSE)
  expect_identical(as.logical(lgl8(0x01)), TRUE)

  expect_identical(as_lgl8(logical()), lgl8(raw()))
  expect_identical(as_lgl8(c(TRUE, FALSE, TRUE)), lgl8(c(0x01, 0x00, 0x01)))
  expect_error(as_lgl8(NA), "Can't store NA values")
})

test_that("lgl1 subset/subset assign works", {
  lgl <- lgl8(c(0x00, 0x01, 0x00, 0x00, 0x01, 0x00))
  expect_identical(
    as.logical(lgl[c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)]),
    c(FALSE, TRUE, FALSE, FALSE, TRUE)
  )
  #expect_identical(as.logical(lgl[1:5]), c(FALSE, TRUE, FALSE, FALSE, FALSE))
  #lgl[1] <- TRUE
  #expect_identical(lgl, lgl1(0x80))
  #expect_identical(lgl[[1]], lgl1(0x80, extra_bits = 1))
})
