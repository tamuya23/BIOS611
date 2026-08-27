# BIOS 611 orientation assignment answers

## Problem 1

`alias hello="echo hello world"` defines an alias. When the next command line
starts with `hello`, Bash expands that first word to `echo hello world`, and the
`echo` builtin prints `hello world`. Therefore, command-name lookup must include
aliases before assuming that a command name is a file or executable on `PATH`.
In an evaluation strategy, add an alias-expansion step before command lookup
(for non-interactive scripts, Bash alias expansion must also be enabled with
`shopt -s expand_aliases`).

## Problem 2

`alias zz=zz; zz` produces a `zz: command not found`-type error. Bash does not
recursively expand an alias while expanding that same alias; otherwise a
self-referential alias would loop forever. Alias expansion is therefore
single-pass with respect to an alias already being expanded.

For

```bash
alias aa=bb
alias bb=aa
aa
```

Bash expands `aa` to `bb`, then `bb` to `aa`, but does not expand the original
`aa` again. The resulting command name is therefore `aa`; on the Linux image
used for this assignment it is normally not an installed command, so Bash
reports `aa: command not found` (if a platform happens to provide an `aa`
command, that command would run instead). The important rule is that alias
expansion is recursive only until an alias already seen on that expansion path
would be reused.

## Problem 3

With `./experiment.sh a b c d e`, the output is:

```text
argument number one is a
argument number two is b
rest of the arguments c d e
all arguments a b c d e
```

`$1` and `$2` are the first two positional parameters. `${@:3}` expands the
positional-parameter list beginning with parameter 3. `$@` expands to all
positional parameters. Inside these double-quoted strings, the expanded values
are displayed as a space-separated list.

## Problem 4

`#!/bin/bash` is a shebang. When the file is invoked directly, the operating
system reads it and starts `/bin/bash` to interpret the remainder of the file.
It is not an ordinary shell command in the script. If the script is invoked as
`bash experiment.sh`, Bash is already the interpreter and the shebang is treated
as a comment. The executable bit is needed for direct invocation (`./experiment.sh`).

## Problem 5

For

```bash
bash ./experiment.sh a 'b c' d
```

the output is:

```text
argument number one is a
argument number two is b c
rest of the arguments d
all arguments a b c d
```

The quotes group `b c` into one argument; quote removal happens before the
script receives its positional parameters. Thus `$2` is one parameter whose
value contains a space. The quoted form `"$@"` (if used) would preserve each
argument as a separate word; the sample uses `$@` inside an `echo` string, so
the visible output does not show the argument boundaries.

## Problem 6

`RUN` executes commands while the image is being built and commits their
filesystem changes into an image layer. It is used to install software or
create files needed by the image. `CMD` does not run during the build; it sets a
default command (or default arguments) that Docker will run when a container is
started. A command supplied to `docker run` replaces the image's default `CMD`.

## Problem 7

1. **`apt`** — Debian/Ubuntu's package manager. It installs and updates
   system-level packages and their dependencies from configured repositories.
2. **`pip`** — Python's package installer. It installs Python distributions and
   their Python dependencies, commonly from PyPI, into a selected Python
   environment.
3. **`install.packages`** — R's package-installation function. It downloads R
   packages (normally from a CRAN-like repository) and installs them into an R
   library.

## Problem 8

The included `Dockerfile` starts from `rocker/rstudio`, restores the minimized
image's documentation with `yes | unminimize` when that helper is available,
ensures `man-db` and `manpages` are installed, and removes apt's package lists
to keep the resulting layer smaller. After building the image, `man ls` should
display the manual page rather than the minimized-system message.

## Problem 9

`compare_man_pages.sh` renders the `man`, `ls`, and `find` pages with
`MANPAGER=cat`, counts their lines with `wc -l`, writes `command,count` records,
and sorts numerically on the second comma-separated field in descending order:

```bash
LC_ALL=C sort -t, -k2,2gr
```

The exact counts depend on the base image and package versions, so the script
reports the counts from the environment in which it is run.

## Problem 10

The required project files are present in this directory. The remaining
course step is account-specific: initialize/commit the directory, create a new
GitHub repository while signed in, add its remote URL, push the commit, and
submit that repository URL.

Example local commands (replace the remote URL with the repository you create):

```bash
git init
git add -A
git commit -m "First commit"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
git push -u origin main
```

### References

* [GNU Bash Reference Manual — Aliases](https://www.gnu.org/software/bash/manual/html_node/Aliases.html)
* [GNU Bash Reference Manual — Positional Parameters](https://www.gnu.org/software/bash/manual/html_node/Positional-Parameters.html)
* [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
* [R `install.packages` documentation](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/install.packages.html)
