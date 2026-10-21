#!/bin/sh
# Run a command up to 8 times, waiting 30 s more before each retry
# (30 s, 60 s, ... 210 s; about 14 minutes in all).
# pecl.php.net's origin returns 500 or 504 through its CDN for minutes at a
# time. PEAR caches none of these errors, so each retry is a fresh request,
# and install-php-extensions skips the modules that already installed.
max=8
attempt=1
while :; do
    "$@" && exit 0
    echo "Attempt $attempt of $max failed: $*" >&2
    [ "$attempt" -ge "$max" ] && exit 1
    sleep $((attempt * 30))
    attempt=$((attempt + 1))
done
