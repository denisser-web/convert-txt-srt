#!/bin/bash

for file in *.txt; do
    [ -f "$file" ] || continue
    ./convert-txt-srt.sh "$file" "$1"
done
