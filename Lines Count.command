#!/bin/bash

cd "`dirname "$0"`"

find ./Super\ Maze/Source/ \( -name "*.h" -o -name "*.mm" -o -name "*.swift" \) -print0 | xargs -0 wc -l