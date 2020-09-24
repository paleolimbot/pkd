
test_that("uint8 constructor works", {
  expect_is(uint8(), "pkd_uint8")
  expect_is(uint8(), "pkd_vctr")

  expect_output(print(uint8()), "pkd_uint8")
})

test_that("uint8 integer conversion works", {
  expect_identical(as.integer(uint8()), integer())
  expect_identical(as.integer(uint8(0x00)), 0L)
  expect_identical(as.integer(uint8(0x01)), 1L)
  expect_identical(as.integer(uint8(0xff)), 255L)

  expect_identical(as_uint8(integer()), uint8(raw()))
  expect_identical(as_uint8(c(1L, 2L, 3L, 255L)), uint8(c(0x01, 0x02, 0x03, 255)))
  expect_warning(as_uint8(NA), "out-of-range")
})

test_that("uint8 numeric conversion works", {
  expect_identical(as.numeric(uint8()), numeric())
  expect_identical(as.numeric(uint8(0x00)), 0)
  expect_identical(as.numeric(uint8(0x01)), 1)

  expect_identical(as_uint8(numeric()), uint8(raw()))
  expect_identical(as_uint8(c(1, 2, 3, 255)), uint8(c(0x01, 0x02, 0x03, 255)))
  expect_warning(as_uint8(NA), "out-of-range")
})

test_that("uint8 subset/subset assign works", {
  x <- uint8(c(1, 2, 3, 255, 5, 9))
  expect_identical(
    as.integer(x[c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)]),
    as.integer(c(1,  2, 3, 255, 5))
  )

  expect_identical(x[TRUE], x)
  expect_identical(x[FALSE], uint8())

  expect_identical(as.integer(x[as.integer(1:5)]), as.integer(x)[1:5])
  expect_identical(as.integer(x[as.double(1:5)]), as.integer(x)[1:5])

  x_cpy <- x
  expect_error(x_cpy[c(TRUE, TRUE)] <- 8, "Can't subset-assign")

  # paired number of sets
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- c(99, 100)
  expect_identical(as.integer(x_cpy), c(99L, 2L, 3L, 255L, 5L, 100L))

  # recycled number of sets
  x_cpy <- x
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, 255L, 5L, 55L))
})
