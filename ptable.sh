#!/bin/bash
# partition table

if ! [ -e ./bin/disk ]; then
    >&2 echo \
        "./bin/disk: Not found. Run: sudo dd if=/dev/sda of=./bin/disk bs=512 count=1"
    exit 1
fi

rm -f ./bin/tmp.1 ./bin/tmp.2 2> /dev/null
dd if=./bin/boot.img of=./bin/tmp.1 bs=1 count=$((0x1be))
dd if=./bin/disk of=./bin/tmp.2 bs=1 skip=$((0x1be))
cat ./bin/tmp.1 ./bin/tmp.2 > bin/boot.img
rm -f ./bin/tmp.1 ./bin/tmp.2 2> /dev/null