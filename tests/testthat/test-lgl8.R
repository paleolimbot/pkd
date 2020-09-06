
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
  expect_warning(as_lgl8(NA), "out-of-range")
})

test_that("lgl1 subset/subset assign works", {
  lgl <- lgl8(c(0x00, 0x01, 0x00, 0x00, 0x01, 0x00))
  expect_identical(
    as.logical(lgl[c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)]),
    c(FALSE, TRUE, FALSE, FALSE, TRUE)
  )

  expect_identical(lgl[TRUE], lgl)
  expect_identical(lgl[FALSE], lgl8())

  expect_identical(as.logical(lgl[as.integer(1:5)]), as.logical(lgl)[1:5])
  expect_identical(as.logical(lgl[as.double(1:5)]), as.logical(lgl)[1:5])

  lgl_cpy <- lgl
  expect_error(lgl_cpy[c(TRUE, TRUE)] <- TRUE, "Can't subset-assign")

  # paired number of sets
  lgl_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- c(TRUE, TRUE)
  expect_identical(as.logical(lgl_cpy), c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE))

  # recycled number of sets
  lgl_cpy <- lgl
  lgl_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- TRUE
  expect_identical(as.logical(lgl_cpy), c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE))

})
