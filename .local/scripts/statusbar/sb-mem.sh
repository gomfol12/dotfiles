#!/bin/sh
free | awk '/^Mem:/ {printf "%.2fG/%.2fG\n", $3/1024/1024, $2/1024/1024}'
