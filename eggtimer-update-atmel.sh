#!/bin/bash -e

SERPORT=$1
FWFILE=$2

if [ ! -w "$SERPORT" ] || [ ! -c "$SERPORT" ]; then
    echo "Cannot access serial port: $SERPORT" >&2
    exit 1
fi

if [ ! -r "$FWFILE" ]; then
    echo "Cannot read firmware file: $FWFILE" >&2
    exit 1
fi

echo "Beginning update"
avrdude -C/etc/avrdude.conf  -v -v -pm328p -carduino -P${SERPORT} -b115200 -D -Uflash:w:${FWFILE}:i
echo "Update successful!"
