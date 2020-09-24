
test_that("dbl64 constructor works", {
  expect_is(dbl64(), "pkd_dbl64")
  expect_is(dbl64(), "pkd_vctr")

  expect_output(print(dbl64()), "pkd_dbl64")
})

test_that("dbl64 integer conversion works", {
  expect_identical(as.integer(dbl64()), integer())
  expect_identical(as.integer(dbl64(c(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))), 0L)

  expect_identical(as_dbl64(integer()), dbl64(raw()))
  expect_identical(
    pkd_ensure_endian(as_dbl64(c(0L, 1L)), 1L),
    dbl64(
      c(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x3f),
      endian = 1L
    )
  )
  # TODO: expect_warning(as_dbl64(NA), "out-of-range")
})

test_that("dbl64 numeric conversion works", {
  expect_identical(as.numeric(dbl64()), numeric())
  expect_identical(as.numeric(dbl64(c(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))), 0)

  expect_identical(as_dbl64(numeric()), dbl64(raw()))
  expect_identical(
    pkd_ensure_endian(as_dbl64(c(0, 1)), 1L),
    dbl64(
      c(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x3f),
      endian = 1L
    )
  )
  # TODO: expect_warning(as_dbl64(NA), "out-of-range")
})

test_that("dbl64 subset/subset assign works", {
  x <- as_dbl64(c(1, 2, 3, 500, 5, 9))
  expect_identical(
    as.integer(x[c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)]),
    as.integer(c(1,  2, 3, 500, 5))
  )

  expect_identical(x[TRUE], x)
  expect_identical(x[FALSE], dbl64())

  expect_identical(as.integer(x[as.integer(1:5)]), as.integer(x)[1:5])
  expect_identical(as.integer(x[as.double(1:5)]), as.integer(x)[1:5])

  x_cpy <- x
  expect_error(x_cpy[c(TRUE, TRUE)] <- 8, "Can't subset-assign")
  expect_error(x_cpy[rep(NA, 6)] <- 8, "Can't subset-assign")
  expect_error(x_cpy[rep(NA_real_, 6)] <- 8, "Can't subset-assign")

  # paired number of sets
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- c(99, 100)
  expect_identical(as.integer(x_cpy), c(99L, 2L, 3L, 500L, 5L, 100L))

  # recycled number of sets
  x_cpy <- x
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 500L, 5L, 55L))

  # integer
  x_cpy <- x
  x_cpy[c(1L, 6L)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 500L, 5L, 55L))

  # double
  x_cpy <- x
  x_cpy[c(1, 6)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 500L, 5L, 55L))
})
