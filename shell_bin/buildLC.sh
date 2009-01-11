#!/bin/bash

MYJARS=$1
export CP=$(find $MYJARS -name *.jar -exec printf {}: ';')

echo $CP

