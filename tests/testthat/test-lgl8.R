
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
