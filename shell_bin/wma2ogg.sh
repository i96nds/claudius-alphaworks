#!/bin/sh
# Convert a .wma to an .ogg using ?mplayer? and ?oggenc?.
#
# Public Domain

args_length=$#

if [ $args_length != 2 ]; then
    echo ""
    echo "Uso: wma2ogg <arquivo wma> <numero da qualidade do oggenc>"
    echo ""
    exit 1
fi

set -e
IN="$1"
OGGENC_QUALITY=$2
shift
if [ -z ?${IN}? ]; then
    IN=-
    WAV=audio.wav
else
    WAV=$(basename "${IN}" .wma).wav
fi

mplayer -vc dummy -vo null -ao pcm:waveheader:file="${WAV}" "${IN}"

FILEDAT=$(file "${WAV}")
BITS=$(echo "${FILEDAT}" | sed -e 's/.*\(8\|16\|32\) bit.*/\1/')

if echo "${FILEDAT}" | grep -q mono; then
    CHANS=1
else
    CHANS=2
fi

oggenc -R 44100 -B ${BITS} -q ${OGGENC_QUALITY} -C ${CHANS} "${WAV}" >/dev/null

rm -f "${WAV}"
