
test_that("int8 constructor works", {
  expect_is(int8(), "pkd_int8")
  expect_is(int8(), "pkd_vctr")

  expect_output(print(int8()), "pkd_int8")
})

test_that("int8 integer conversion works", {
  expect_identical(as.integer(int8()), integer())
  expect_identical(as.integer(int8(0x00)), 0L)
  expect_identical(as.integer(int8(0x01)), 1L)
  expect_identical(as.integer(int8(0xff)), -1L)

  expect_identical(as_int8(integer()), int8(raw()))
  expect_identical(as_int8(c(1L, 2L, 3L, -1L)), int8(c(0x01, 0x02, 0x03, 255)))
  # TODO: expect_warning(as_int8(NA), "out-of-range")
})

test_that("int8 numeric conversion works", {
  expect_identical(as.numeric(int8()), numeric())
  expect_identical(as.numeric(int8(0x00)), 0)
  expect_identical(as.numeric(int8(0x01)), 1)

  expect_identical(as_int8(numeric()), int8(raw()))
  expect_identical(as_int8(c(1, 2, 3, -1)), int8(c(0x01, 0x02, 0x03, 255)))
  # TODO: expect_warning(as_int8(NA), "out-of-range")
})

test_that("int8 subset/subset assign works", {
  x <- int8(c(1, 2, 3, 255, 5, 9))
  expect_identical(
    as.integer(x[c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)]),
    as.integer(c(1,  2, 3, -1, 5))
  )

  expect_identical(x[TRUE], x)
  expect_identical(x[FALSE], int8())

  expect_identical(as.integer(x[as.integer(1:5)]), as.integer(x)[1:5])
  expect_identical(as.integer(x[as.double(1:5)]), as.integer(x)[1:5])

  x_cpy <- x
  expect_error(x_cpy[c(TRUE, TRUE)] <- 8, "Can't subset-assign")

  # paired number of sets
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- c(99, 100)
  expect_identical(as.integer(x_cpy), c(99L, 2L, 3L, -1L, 5L, 100L))

  # recycled number of sets
  x_cpy <- x
  x_cpy[c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE)] <- 55
  expect_identical(as.integer(x_cpy), c(55L, 2L, 3L, -1L, 5L, 55L))
})
