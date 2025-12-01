#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo"
    echo "Usage: sudo ./install.sh"
    exit 1
fi

cp start-kinesis-swe.sh /usr/local/bin
cp 99-kinesis.rules /etc/udev/rules.d/
