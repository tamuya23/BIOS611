#!/usr/bin/env bash
set -euo pipefail

# Count the rendered lines in each manual page, then sort by the count
# (second comma-separated field) from largest to smallest.
tmp_file=$(mktemp)
trap 'rm -f "$tmp_file"' EXIT

for command_name in man ls find; do
    line_count=$(MANPAGER=cat man "$command_name" 2>/dev/null | wc -l | tr -d '[:space:]')
    printf '%s,%s\n' "$command_name" "$line_count" >> "$tmp_file"
done

LC_ALL=C sort -t, -k2,2gr "$tmp_file"
