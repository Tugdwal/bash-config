#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
     *) return;;
esac

shopt -s globstar

# Source files in directory
# $1 : directory name
# $2 : file extension
# $3 : debug mode
load()
{
    local debug=${3:-false}
    local base
    local ext

    if [ -d "$1" ]; then
        if [ "${debug,,}" = "true" ]; then
            echo "Loading $1/"
        fi
        for file in $1**/*; do
            base=$(basename "${file}" ".$2")
            ext=${file##*.}
            if [ "${ext}" = "$2" ]; then
                if [ "${debug,,}" = "true" ]; then
                    echo "    Loading $1/${base}.$2"
                fi
                . "${file}"
            fi
        done
    fi
}

load "$HOME/.bash" bash

