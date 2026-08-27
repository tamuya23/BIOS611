FROM rocker/rstudio:latest

USER root

# Restore the documentation removed from a minimized Ubuntu base image.  The
# fallback also makes the build work if the selected rocker image has no
# unminimize helper but does have apt repositories configured.
RUN apt-get update \
    && if command -v unminimize >/dev/null 2>&1; then yes | unminimize || test "$?" -eq 123; fi \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends man-db manpages \
    && rm -rf /var/lib/apt/lists/*
