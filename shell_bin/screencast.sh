#!/bin/sh

# verificar qual eh o ID da janela
#xwininfo -frame 

recordmydesktop  -windowid $1 -s_quality 8  -delay 10 -buffer-size 40960  -o $2
