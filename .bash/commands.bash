#!/bin/bash

# Edit
# $1 : Editor
# $2 : Directory
# $3 : Default file
# $4 : File extension
# $5 : Filename
editfile()
{
    local file

    if [ $# -gt 4 ]; then
        file=$(find "$2" -type f -name "$5.$4")
        if [ -z "${file}" ]; then
            $1 "$2/$3"
        else
            $1 "${file}"
        fi
    elif [ $# -gt 3 ]; then
        $1 "$2/$3"
    fi
}

# Edit .bashrc with vim
bashrc()
{
    editfile vim "$HOME" .bashrc bash "$1"
}

# Edit .vimrc with vim
vimrc()
{
    editfile vim "$HOME" .vimrc vim "$1"
}

