
test_that("bitlgl constructor works", {
  expect_is(bitlgl(), "pkd_bitlgl")
  expect_is(bitlgl(), "pkd_vctr")
  expect_error(bitlgl(extra_bits = -1), "must be between")

  expect_output(print(bitlgl()), "pkd_bitlgl")
})

test_that("bitlgl logical conversion works", {
  expect_identical(as.logical(bitlgl()), logical())
  expect_identical(as.logical(bitlgl(0x80)), c(TRUE, rep(FALSE, 7)))
  expect_identical(as.logical(bitlgl(c(0x80, 0x80), extra_bits = 1)), c(TRUE, rep(FALSE, 7), TRUE))

  expect_identical(as_bitlgl(logical()), bitlgl(raw()))
  expect_identical(as_bitlgl(as.logical(bitlgl(0x80))), bitlgl(0x80))
  expect_identical(
    as_bitlgl(as.logical(bitlgl(c(0x80, 0x80), extra_bits = 1))),
    bitlgl(c(0x80, 0x80), extra_bits = 1)
  )
})
