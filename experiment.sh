#!/usr/bin/env bash

# Demonstration script for positional parameters and Bash parameter expansion.
echo "argument number one is $1"
echo "argument number two is $2"
echo "rest of the arguments ${@:3}"
echo "all arguments $@"
