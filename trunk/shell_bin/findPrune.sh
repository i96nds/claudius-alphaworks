#!/bin/sh

eval "find $1 \( $2  \) -prune -o $3 -print "
