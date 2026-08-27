# BIOS 611 Programming in R assignment

# Problem 5: a closure that emits 1, 1, 2, 3, 5, ...
make_fib_counter <- function() {
  first <- 1
  second <- 1

  function() {
    result <- first
    first <<- second
    second <<- result + second
    result
  }
}

# Problem 6: the same idea, but with an arbitrary starting pair.
make_nocci <- function(c1, c2) {
  function() {
    result <- c1
    c1 <<- c2
    c2 <<- result + c2
    result
  }
}

# Small checks/examples.
fc <- make_fib_counter()
stopifnot(identical(unname(vapply(seq_len(6), function(...) fc(), numeric(1))),
                    c(1, 1, 2, 3, 5, 8)))

nc <- make_nocci(2, 3)
stopifnot(identical(unname(vapply(seq_len(5), function(...) nc(), numeric(1))),
                    c(2, 3, 5, 8, 13)))

# Problem 4: while loops also leave assignments in the current function
# environment; there is no new child environment for each iteration.
while_scope_test <- function() {
  test_value <- 10
  x <- 1
  while (x <= 100) {
    test_value <- x
    x <- x + 1
  }
  c(test_value = test_value, next_x = x)
}

stopifnot(identical(unname(while_scope_test()), c(100, 101)))

cat("Fibonacci:", paste(c(1, 1, 2, 3, 5, 8), collapse = ", "), "\n")
cat("Nocci(2, 3):", paste(c(2, 3, 5, 8, 13), collapse = ", "), "\n")
cat("while_scope_test:", paste(while_scope_test(), collapse = ", "), "\n")
