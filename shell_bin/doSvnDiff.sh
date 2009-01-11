#!/bin/sh

svn status -q "$@" | grep '^[GM]'| cut -c 8- | while read file; do 
    svn diff --diff-cmd colordiff "$file"; 
done 
