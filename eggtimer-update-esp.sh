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
esptool -vv -cd ck -cb 115200 -cp ${SERPORT} -ca 0x00000 -cf ${FWFILE}
echo "Update successful!"
