#!/usr/bin/env bash

attempts=0
max_attempts=3

while [ "$attempts" -lt "$max_attempts" ]; do
    if doas "$@"; then
        exit 0
    fi
    status=$?
    attempts=$((attempts + 1))
done

exit "${status:-1}"
