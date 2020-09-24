
test_that("uint16 constructor works", {
  expect_is(uint16(), "pkd_uint16")
  expect_is(uint16(), "pkd_vctr")

  expect_output(print(uint16()), "pkd_uint16")
})

test_that("uint16 integer conversion works", {
  expect_identical(as.integer(uint16()), integer())
  expect_identical(as.integer(uint16(c(0x00, 0x00))), 0L)
  expect_identical(as.integer(uint16(c(0x01, 0x00), endian = 1L)), 1L)
  expect_identical(as.integer(uint16(c(0x00, 0x01), endian = 0L)), 1L)
  expect_identical(as.integer(uint16(c(0xff, 0xff))), 65535L)

  expect_identical(as_uint16(integer()), uint16(raw()))
  expect_identical(
    pkd_ensure_endian(as_uint16(c(0L, 1L, 65535L)), 1L),
    uint16(c(0x00, 0x00, 0x01, 0x00, 0xff, 0xff), endian = 1L)
  )
  # TODO: expect_warning(as_uint16(NA), "out-of-range")
})

test_that("uint16 numeric conversion works", {
  expect_identical(as.numeric(uint16()), numeric())
  expect_identical(as.numeric(uint16(c(0x00, 0x00))), 0)
  expect_identical(as.numeric(uint16(c(0x01, 0x00), endian = 1L)), 1)
  expect_identical(as.numeric(uint16(c(0x00, 0x01), endian = 0L)), 1)
  expect_identical(as.numeric(uint16(c(0xff, 0xff))), 65535)

  expect_identical(as_uint16(numeric()), uint16(raw()))
  expect_identical(
    pkd_ensure_endian(as_uint16(c(0, 1, 65535)), 1L),
    uint16(c(0x00, 0x00, 0x01, 0x00, 0xff, 0xff), endian = 1L)
  )
  # TODO: expect_warning(as_uint16(NA), "out-of-range")
})

test_that("uint16 subset/subset assign works", {
  x <- as_uint16(c(1, 2, 3, 65535, 5, 9))
  expect_identical(
    as.integer(x[c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)]),
    as.integer(c(1,  2, 3, 65535, 5))
  )

  expect_identical(x[TRUE], x)
  expect_identical(x[FALSE], uint16())

  expect_identical(as.integer(x[as.integer(1:5)]), as.integer(x)[1:5])
  expect_identical(as.integer(x[as.double(1:5)]), as.integer(x)[1:5])

  x_cpy <- x
  expect_error(x_cpy[c(TRUE, TRUE)] <- 8, "Can't subset-assign")
  expect_error(x_cpy[rep(NA, 6)] <- 8, "Can't subset-assign")
  expect_error(x_cpy[rep(NA_real_, 6)] <- 8, "Can't subset-assign")

  # paired number of sets
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- c(99, 100)
  expect_identical(as.integer(x_cpy), c(99L, 2L, 3L, 65535L, 5L, 100L))

  # recycled number of sets
  x_cpy <- x
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 65535L, 5L, 55L))

  # integer
  x_cpy <- x
  x_cpy[c(1L, 6L)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 65535L, 5L, 55L))

  # double
  x_cpy <- x
  x_cpy[c(1, 6)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 65535L, 5L, 55L))
})
