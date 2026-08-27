# BIOS 611 Programming in R — answers

## Problem 1

`<-` assigns in the current evaluation environment. `<<-` searches enclosing
parent environments for an existing binding and updates the first one it finds;
if it finds none, it creates the binding in the global environment. Thus
`<<-` is useful when a returned function (a closure) needs to update state held
by the function that created it.

## Problem 2

No new evaluation rule is strictly necessary. `1:10` is the infix form of the
primitive colon operator, equivalent to calling ``:`(1, 10)``. The existing
rule for evaluating a function/operator call can explain why it returns the
integer vector `c(1, 2, ..., 10)`. A separate rule can be a convenient shortcut
for the special behavior of `:`, but it is not a fundamentally new kind of
evaluation.

## Problem 3

The loop finishes with `test_value` equal to 100. The body of a `for` loop is
evaluated in the current evaluation environment; R does not create a fresh
lexical environment for every iteration. Therefore `<-` changes the binding in
the function environment if the loop is inside a function, or in the global
environment if it is run at the top level.

## Problem 4

One test is:

```r
while_scope_test <- function() {
  test_value <- 10
  x <- 1
  while (x <= 100) {
    test_value <- x
    x <- x + 1
  }
  c(test_value = test_value, next_x = x)
}

while_scope_test()
# test_value    next_x
#         100        101
```

The assignments remain available after the loop, so `while` follows the same
environment rule as `for`: it does not make a new environment per iteration.

## Problem 5

The required counter is a closure. It keeps two private bindings, `first` and
`second`, and returns the old `first` value on each call. `<<-` updates those
bindings in the enclosing `make_fib_counter` environment:

```r
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
```

Calling the returned function repeatedly produces `1, 1, 2, 3, 5, 8, ...`.

## Problem 6

Generalize the previous function by accepting the initial pair as arguments:

```r
make_nocci <- function(c1, c2) {
  function() {
    result <- c1
    c1 <<- c2
    c2 <<- result + c2
    result
  }
}
```

For example, `nc <- make_nocci(2, 3)` returns `2, 3, 5, 8, 13, ...` on
successive calls. Each call to `make_nocci` creates a separate environment, so
two counters do not share state.

## Problem 7

`make_nocci` first creates `c1` and `c2` in its function execution environment.
It then returns the inner function. That inner function retains a reference to
the creator's environment after `make_nocci` returns; this retained function
plus its enclosing environment is a closure. On each invocation, `result <- c1`
reads the current first value. The two `<<-` assignments then shift the pair
forward: the old second value becomes the new first value, and the sum becomes
the new second value. The returned `result` is therefore the next value in the
sequence.

## Problem 8

Examples of R environments include:

* `.GlobalEnv` (the interactive workspace)
* `baseenv()` (the base package environment)
* `emptyenv()` (the parentless empty environment)
* a function's execution environment/call frame
* the enclosing environment captured by a closure
* `new.env()` (a newly created user environment)
* package environments such as `as.environment("package:stats")`
* namespace environments such as `asNamespace("stats")`
* the parent environments obtained with `parent.env()`
* the environment returned by `environment()` inside a function

An environment maps names to bindings, has a parent environment, and can be
mutated. It is not the same thing as a list or data frame, even though all three
can store named values.
